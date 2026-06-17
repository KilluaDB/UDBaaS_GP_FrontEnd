import 'dart:convert';

import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/features/no_sql_projects/collections_editor/view/widgets/collection_editor_header.dart';
import 'package:dbaas_project/features/no_sql_projects/collections_editor/view/widgets/edit_document.dart';
import 'package:dbaas_project/features/no_sql_projects/collections_editor/view_model/mongo_edior_states.dart';
import 'package:dbaas_project/features/no_sql_projects/collections_editor/view_model/mongo_editor_cubit.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:dbaas_project/features/sql_projects/query/view/screens/full_query_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MongoCollectionFullScreen extends StatelessWidget {
  final String projectId;
  final String collectionName;
  final VoidCallback onOpenDrawer;

  const MongoCollectionFullScreen({
    super.key,
    required this.projectId,
    required this.collectionName,
    required this.onOpenDrawer,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SettingsProvider>(context);

    return BlocConsumer<MongoCollectionEditorCubit, MongoEditorStates>(
      listener: (context, state) {
        final cubit = context.read<MongoCollectionEditorCubit>();

   
        if (state is AddFieldSuccess ||
            state is UpdateFieldSuccess ||
            state is DeleteFieldSuccess ||
            state is UpdateDocumentsSuccess ||
            state is DeleteDocumentsSuccess ||
            state is DeleteDocumentSuccess) {
          cubit.getDocuments(
            projectId: projectId,
            collectionName: collectionName,
            showLoading: false,
          );
        }

   
        if (state is AddFieldSuccess ||
            state is UpdateFieldSuccess ||
            state is DeleteFieldSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        }

     
        if (state is AddFieldError ||
            state is UpdateFieldError ||
            state is DeleteFieldError ||
            state is UpdateDocumentsError ||
            state is DeleteDocumentsError ||
            state is DeleteDocumentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.watch<MongoCollectionEditorCubit>();
        final docs = cubit.cachedDocuments?.documents ?? [];
        final count = cubit.cachedCount ?? 0;

        return Column(
          children: [
            CollectionEditorHeader(
              collectionName: collectionName,
              documentsCount: count,
              onAddDoc: onOpenDrawer,
              onDeleteAll: () => _confirmDeleteAll(context),
              onUpdateDocs: () => openUpdateDialog(context),
            ),
            Expanded(child: _buildBody(context, cubit, state, docs,provider)),
          ],
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    MongoCollectionEditorCubit cubit,
    MongoEditorStates state,
    List<Map<String, dynamic>> docs,
SettingsProvider provider

  ) {
    if (state is GetDocumentsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is GetDocumentsError) {
      return Center(child: Text(state.message));
    }

    if (docs.isEmpty) {
return Center(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: provider.isDark
              ? Colors.white.withOpacity(.08)
              : Colors.grey.shade100,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.description_outlined,
          size: 50,
          color: provider.isDark
              ? AppTheme.white
              : AppTheme.gray,
        ),
      ),
      const SizedBox(height: 20),
      Text(
        "No Documents Found",
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: provider.isDark
                  ? AppTheme.white
                  : AppTheme.black,
            ),
      ),
      const SizedBox(height: 8),
      Text(
        "This collection doesn't contain any documents yet.",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.gray,
            ),
      ),
    ],
  ),
);    }

    return ListView.separated(
      padding: EdgeInsets.all(12.w),
      itemCount: docs.length,
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemBuilder: (context, index) {
        final doc = docs[index];
        final id = doc["_id"]?.toString() ?? "";
        final isEditing = cubit.editingDocId == id;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: isEditing
              ? EditableMongoDocument(
                  key: ValueKey("edit_$id"),
                  document: Map<String, dynamic>.from(doc),

                  onCancel: cubit.cancelEditing,

                  onDeleteField: (field) {
                    cubit.deleteField(
                      projectId: projectId,
                      collectionName: collectionName,
                      docId: id,
                      field: field,
                    );
                  },

                  onAddFieldConfirm: (fields) {
                    final newField = fields.last;

                    if (newField.key.trim().isEmpty) return;

                    cubit.addField(
                      projectId: projectId,
                      collectionName: collectionName,
                      docId: id,
                      field: newField.key.trim(),
                      value: newField.value,
                      type: newField.type,
                    );
                  },
              onSave: (fields) async {
  final cubit = context.read<MongoCollectionEditorCubit>();

  final originalDoc = doc;

  final changedFields = fields.where((field) {
    if (field.key == "_id") return false;

    return originalDoc[field.key] != field.value;
  }).toList();

  await Future.wait(
    changedFields.map((field) async {
      final normalizedValue = normalizeMongoValue(
        field.value,
        field.type,
      );


      return cubit.updateField(
        projectId: projectId,
        collectionName: collectionName,
        docId: id,
        field: field.key.trim(),
        value: normalizedValue,
        type: field.type,
      );
    }),
  );

  cubit.cancelEditing();
},
             
                )
              : _ViewMongoCard(
                  key: ValueKey("view_$id"),
                  document: doc,

                  onEdit: () => cubit.startEditing(id),

                  onDelete: () {
                    cubit.deleteDocument(
                      projectId: projectId,
                      collectionName: collectionName,
                      docId: id,
                    );
                  },

                  onDeleteField: (field) {
                    cubit.deleteField(
                      projectId: projectId,
                      collectionName: collectionName,
                      docId: id,
                      field: field,
                    );
                  },

                  onUpdateField: (field, value) {
                    cubit.updateField(
                      projectId: projectId,
                      collectionName: collectionName,
                      docId: id,
                      field: field,
                      value: value,
                    );
                  },
                ),
        );
      },
    );
  }

dynamic normalizeMongoValue(dynamic value, String type) {
  switch (type) {
    case "int32":
    case "int64":
      if (value is int) return value;
      return int.tryParse(value.toString()) ?? 0;

    case "double":
      if (value is double) return value;
      return double.tryParse(value.toString()) ?? 0.0;

    case "boolean":
      if (value is bool) return value;
      return value.toString().toLowerCase() == "true";

    case "array":
      if (value is List) return value;

      try {
        return jsonDecode(value.toString());
      } catch (_) {
        return [];
      }

    case "object":
      if (value is Map) return value;

      try {
        return jsonDecode(value.toString());
      } catch (_) {
        return {};
      }

    default:
      return value.toString();
  }
}
  void _confirmDeleteAll(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.white,
        title: const Text("Delete All Documents",style: TextStyle(color: AppTheme.black),),
        content: const Text("Are you sure you want to delete ALL documents?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel",style: TextStyle(color: AppTheme.black),),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              context.read<MongoCollectionEditorCubit>().deleteDocuments(
                projectId: projectId,
                collectionName: collectionName,
                filter: null,
              );
            },
            child: const Text("Delete All"),
          ),
        ],
      ),
    );
  }
void openUpdateDialog(BuildContext context) {
  final filterController = TextEditingController();
  final updateController = TextEditingController();
  final provider = context.read<SettingsProvider>();

  showDialog(
    context: context,
    useSafeArea: true,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor:
            provider.isDark ? AppTheme.black : AppTheme.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.edit_document,
              color: provider.isDark
                  ? AppTheme.white
                  : AppTheme.black,
            ),
            const SizedBox(width: 10),
            const Text("Update Documents"),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              
              TextField(
                  style: TextStyle(
    color: provider.isDark ? Colors.white : Colors.black,
  ),
                controller: filterController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: '{"name":"Ahmed"}',
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                                  style: TextStyle(
    color: provider.isDark ? Colors.white : Colors.black,
  ),
                controller: updateController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: '{"age":25}',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              try {
                final f = filterController.text.isEmpty
                    ? null
                    : jsonDecode(filterController.text);

                final u = jsonDecode(updateController.text);

                Navigator.pop(dialogContext);

                context
                    .read<MongoCollectionEditorCubit>()
                    .updateDocuments(
                      projectId: projectId,
                      collectionName: collectionName,
                      filter: f,
                      update: {"\$set": u},
                    );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Invalid JSON: $e")),
                );
              }
            },
            child: const Text("Update"),
          ),
        ],
      );
    },
  );
}

}

class _ViewMongoCard extends StatelessWidget {
  final Map<String, dynamic> document;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  final Function(String field, dynamic value) onUpdateField;
  final Function(String field) onDeleteField;

  const _ViewMongoCard({
    super.key,
    required this.document,
    required this.onEdit,
    required this.onDelete,
    required this.onUpdateField,
    required this.onDeleteField,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SettingsProvider>(context);
    final textTheme = Theme.of(context).textTheme;

    final id = document["_id"]?.toString() ?? "";

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: provider.isDark ? const Color(0xff252525) : AppTheme.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppTheme.semiGray.withOpacity(.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.description_outlined,
                      color: AppTheme.primary,
                      size: 18.sp,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        "_id: $id",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: provider.isDark
                              ? AppTheme.white
                              : AppTheme.black,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10.h),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: provider.isDark
                        ? const Color(0xff121212)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: SelectableText(
                    const JsonEncoder.withIndent('  ').convert(document),
                    maxLines: 8,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12.sp,
                      height: 1.5,
                      color: provider.isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 8.w),

          Column(
            children: [
              IconButton(
                icon: Icon(
                  Icons.edit_outlined,
                  color: AppTheme.primary,
                  size: 20.sp,
                ),
                onPressed: onEdit,
              ),

              SizedBox(height: 6.h),

              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: AppTheme.red,
                  size: 20.sp,
                ),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
