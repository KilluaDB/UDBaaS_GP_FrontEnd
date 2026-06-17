import 'dart:convert';

import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/widgets/custome_elevated_button.dart';
import 'package:dbaas_project/features/no_sql_projects/collections_editor/view_model/mongo_editor_cubit.dart';
import 'package:dbaas_project/features/no_sql_projects/collections_editor/view_model/mongo_edior_states.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class InsertDocumentDrawer extends StatefulWidget {
  final String collectionName;
  final String projectId;

  const InsertDocumentDrawer({
    super.key,
    required this.collectionName,
    required this.projectId,
  });

  @override
  State<InsertDocumentDrawer> createState() => _InsertDocumentDrawerState();
}

class _InsertDocumentDrawerState extends State<InsertDocumentDrawer> {
  final TextEditingController _jsonController = TextEditingController();

  void _insertDocument(BuildContext context) {
    final cubit = context.read<MongoCollectionEditorCubit>();

    try {
      final jsonText = _jsonController.text.trim();

      if (jsonText.isEmpty) {
        throw Exception("Document is empty");
      }

      final parsed = jsonDecode(jsonText);

      if (parsed is! Map<String, dynamic>) {
        throw Exception("Document must be a JSON object");
      }

      cubit.insertDocuments(
        projectId: widget.projectId,
        collectionName: widget.collectionName,
        documents: [parsed],
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _formatJson() {
    try {
      final decoded = jsonDecode(_jsonController.text);
      const encoder = JsonEncoder.withIndent('  ');
      _jsonController.text = encoder.convert(decoded);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid JSON"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _jsonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SettingsProvider>(context);
final textTheme = Theme.of(context).textTheme;
    return BlocListener<MongoCollectionEditorCubit, MongoEditorStates>(
      listener: (context, state) {
        if (state is InsertDocumentsSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Document inserted successfully"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }

        if (state is InsertDocumentsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<MongoCollectionEditorCubit, MongoEditorStates>(
        builder: (context, state) {
          final isLoading = state is InsertDocumentsLoading;

   return Container(
  padding: EdgeInsets.all(20.w),
  color: Theme.of(context).scaffoldBackgroundColor,
  child: Column(
    children: [



      Expanded(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: provider.isDark
                ? const Color(0xff121212)
                : AppTheme.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: provider.isDark
                  ? Colors.white10
                  : Colors.grey.shade300,
            ),
          ),
          child: Column(
            children: [
              Container(
                height: 42.h,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: provider.isDark
                      ? const Color(0xff1B1B1B)
                      : AppTheme.semiGray,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(14.r),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.code,
                      size: 18.sp,
                      color: AppTheme.primary,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "document.json",
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: TextFormField(
                    controller: _jsonController,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13.sp,
                      color: provider.isDark
                          ? Colors.greenAccent
                          : AppTheme.black,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: false,
                      hintText: '''
{
  "name": "John",
  "age": 25
}
''',
                      hintStyle: TextStyle(
                        color: AppTheme.boldGray,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      SizedBox(height: 20.h),

      Row(
        children: [
          Expanded(
            flex: 2,
            child: CustomElevatedButton(
              backgroundColor: AppTheme.primary,
              onTap: isLoading
                  ? null
                  : () => _insertDocument(context),
              child: isLoading
                  ? SizedBox(
                      height: 18.h,
                      width: 18.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text("Insert Document"),
            ),
          ),

          SizedBox(width: 10.w),

          Expanded(
            child: CustomElevatedButton(
              backgroundColor:
                  provider.isDark ? const Color(0xff2A2A2A) : AppTheme.black,
              onTap: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
          ),
        ],
      ),
    ],
  ),
);
       
        },
      ),
    );
  }
}