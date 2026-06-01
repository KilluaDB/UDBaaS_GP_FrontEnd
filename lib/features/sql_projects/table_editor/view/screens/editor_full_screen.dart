import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/features/sql_projects/DB/view_model/tables_cubit.dart';
import 'package:dbaas_project/features/sql_projects/table_editor/view/widgets/drawer_table.dart';
import 'package:dbaas_project/features/sql_projects/table_editor/view_model/edits_cubit.dart';
import 'package:dbaas_project/features/sql_projects/table_editor/view_model/edits_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditorFullScreen extends StatefulWidget {
  final String tableName;
  final String projectId;
  List<Map<String, dynamic>> rows;
  bool isLoading;
  EditorFullScreen({
    super.key,
    required this.tableName,
    required this.projectId,
    required this.rows,
    required this.isLoading,
  });

  @override
  State<EditorFullScreen> createState() => _EditorFullScreenState();
}

class _EditorFullScreenState extends State<EditorFullScreen> {
  late final PostgresTableEditorCubit editorCubit;

@override
void initState() {
  super.initState();
  editorCubit = context.read<PostgresTableEditorCubit>();

  editorCubit.getAllRows(
    projectId: widget.projectId,
    tableName: widget.tableName,
    showLoading: true,
  );
}
final Map<String, TextEditingController> _controllers = {};
@override
void dispose() {
  for (final controller in _controllers.values) {
    controller.dispose();
  }
  super.dispose();
}
  @override
  Widget build(BuildContext context) {
    final tableData = context
        .watch<PostgresTablesCubit>()
        .cachedTablesMap[widget.tableName];

    final columns = tableData?.columns ?? [];

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              Icon(Icons.storage, color: AppTheme.primary),
              SizedBox(width: 8.w),
              Text(
                widget.tableName,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Spacer(),
              _buildInsertButton(context),
            ],
          ),
        ),

        Container(
          color: AppTheme.semiGray,
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Row(
            children: [
              ...List.generate(columns.length, (index) {
                final column = columns[index];

                return Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      border: index < columns.length - 1
                          ? Border(
                              right: BorderSide(
                                color: AppTheme.boldGray.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            )
                          : null,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            column.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (index != 0)
                          _buildColumnOptionsMenu(column.name ),
                      ],
                    ),
                  ),
                );
              }),
              SizedBox(width: 48.w),
            ],
          ),
        ),

Expanded(
  child: BlocListener<PostgresTableEditorCubit, PostgresTableEditorStates>(
    listener: (context, state) {
      if (state is UpdateRowsSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Row updated successfully"),
            backgroundColor: AppTheme.green,
          ),
        );
      }

      if (state is UpdateRowsError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
            backgroundColor: AppTheme.red,
          ),
        );
      }

      if (state is DeleteRowsSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Row deleted successfully"),
            backgroundColor: AppTheme.green,
          ),
        );
      }

      if (state is DeleteRowsError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
            backgroundColor: AppTheme.red,
          ),
        );
      }

      if (state is DeleteColumnSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Column deleted successfully"),
            backgroundColor: AppTheme.green,
          ),
        );
      }

      if (state is DeleteColumnError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
            backgroundColor: AppTheme.red,
          ),
        );
      }
    },
    child: BlocBuilder<PostgresTableEditorCubit, PostgresTableEditorStates>(
            builder: (context, state) {
              if (state is GetAllRowsLoading) {
                return const Center(child: CircularProgressIndicator());
              }

final rows = (state is GetAllRowsSuccess)
    ? state.getRowsResponse.rows
    : editorCubit.cachedRows?.rows ?? [];
              if (rows.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.storage,
                        size: 64.sp,
                        color: AppTheme.boldGray.withValues(alpha: 0.5),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        "No rows in this table",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Click "Insert" to add your first row',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: rows.length,
                itemBuilder: (context, rowIndex) {
                  final row = rows[rowIndex];
                  return Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 4.h,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: AppTheme.boldGray.withValues(alpha: 0.15),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ...List.generate(columns.length, (colIndex) {
                          final colName = columns[colIndex].name ;

                          final text = row[colName]?.toString() ?? "";

                          return Flexible(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  right: colIndex != columns.length - 1
                                      ? BorderSide(
                                          color: AppTheme.boldGray.withValues(
                                            alpha: 0.1,
                                          ),
                                        )
                                      : BorderSide.none,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 4.h,
                              ),
                              child:
Focus(
  onFocusChange: (hasFocus) async {
    if (hasFocus) return;

    if (columns[colIndex].isIdentity ?? false) return;

    if (_controllers['${row["id"]}_$colName']!.text != text) {
      await editorCubit.updateRows(
        projectId: widget.projectId,
        tableName: widget.tableName,
        filter: {"id": row["id"]},
        update: {
          colName: _controllers['${row["id"]}_$colName']!.text,
        },
      );
    }
  },
  child: TextFormField(
    controller: _controllers.putIfAbsent(
      '${row["id"]}_$colName',
      () => TextEditingController(text: text),
    ),
    enabled: !(columns[colIndex].isIdentity ?? false),
    style: TextStyle(fontSize: 13.sp),
    decoration: InputDecoration(
      isDense: true,
      border: InputBorder.none,
      filled: (columns[colIndex].isIdentity ?? false),
      fillColor: (columns[colIndex].isIdentity ?? false)
          ? Colors.grey.shade100
          : Colors.transparent,
    ),
  ),
),                 
                            
                            ),
                          );
                        }),

                        SizedBox(
                          width: 40.w,
                          child: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: AppTheme.red,
                              size: 18.sp,
                            ),
                            onPressed: () async {
                              await editorCubit.deleteRows(
                                projectId: widget.projectId,
                                tableName: widget.tableName,
                                filter: {"id": row["id"]},
                              );
                                                        await editorCubit.getAllRows(
        projectId:widget. projectId,
        tableName: widget. tableName,
      
        showLoading: false,
      );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),)
      ],
    );
  }


  Widget _buildInsertButton(BuildContext context) {
    return PopupMenuButton<String>(
      borderRadius: BorderRadius.circular(7.r),
      color: AppTheme.white,
      offset: Offset(0, 40.h),
      onSelected: (value) {
        final tablesCubit = context.read<PostgresTablesCubit>();
        final editorCubit = context.read<PostgresTableEditorCubit>();
        showGeneralDialog(
          context: context,
          barrierDismissible: true,
          barrierLabel: '',
          barrierColor: Colors.black45,
          pageBuilder: (dialogContext, _, __) {
            return MultiBlocProvider(
              providers: [
                BlocProvider.value(value: tablesCubit),
                BlocProvider.value(value: editorCubit),
              ],

              child: Align(
                alignment: Alignment.centerRight,
                child: Material(
                  color: Colors.transparent,
                  child: SizedBox(
                    width: 420.w,
                    height: double.infinity,
                    child: DrawerTable(
                      tableName: widget.tableName,
                      selectedIndex: value,
                      projectId: widget.projectId,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'row',
          child: ListTile(
            leading: Icon(Icons.add, color: AppTheme.green),
            title: const Text("Insert Row"),
          ),
        ),
        PopupMenuItem(
          value: 'column',
          child: ListTile(
            leading: Icon(Icons.add, color: AppTheme.purple),
            title: const Text("Insert Column"),
          ),
        ),
      ],
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppTheme.primary,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Icon(Icons.add, color: AppTheme.white, size: 18.sp),
            SizedBox(width: 5.w),
            Text("Insert", style: TextStyle(color: AppTheme.white)),
            Icon(Icons.arrow_drop_down_outlined, color: AppTheme.white),
          ],
        ),
      ),
    );
  }


  Widget _buildColumnOptionsMenu(String columnName) {
    return PopupMenuButton<String>(
      color: AppTheme.white,
      icon: Icon(
        Icons.arrow_drop_down_outlined,
        size: 20.sp,
        color: AppTheme.boldGray,
      ),
      onSelected: (value) async {
        if (value == 'delete') {
          await editorCubit.deleteColumn(
            projectId: widget.projectId,
            tableName: widget.tableName,
            columnName: columnName,
          );

                                   await editorCubit.getAllRows(
        projectId:widget. projectId,
        tableName: widget. tableName,
      
        showLoading: false,
      );

          await context.read<PostgresTablesCubit>().getAllTables(
            widget.projectId,
            isSilentRefresh: true
          );
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, color: AppTheme.red, size: 16.sp),
              SizedBox(width: 8.w),
              Text("Delete column", style: TextStyle(color: AppTheme.red)),
            ],
          ),
        ),
      ],
    );
  }
}
