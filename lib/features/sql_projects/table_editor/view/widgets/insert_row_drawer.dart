import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/features/sql_projects/DB/data/models/postgres_column_detail.dart';
import 'package:dbaas_project/features/sql_projects/DB/view_model/tables_cubit.dart';
import 'package:dbaas_project/features/sql_projects/table_editor/view_model/edits_cubit.dart';
import 'package:dbaas_project/features/sql_projects/table_editor/view_model/edits_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InsertRowDrawer extends StatefulWidget {
  final String tableName;
  final String projectId;

  const InsertRowDrawer({
    super.key,
    required this.tableName,
    required this.projectId,
  });

  @override
  State<InsertRowDrawer> createState() => _InsertRowDrawerState();
}

class _InsertRowDrawerState extends State<InsertRowDrawer> {
  final Map<String, TextEditingController> _controllers = {};
  bool _loading = false;

  void _syncControllers(List<PostgresColumnDetail> columns) {
    final nonIdentityColumns = columns.where((c) => !(c.isIdentity ?? false));
    final names = nonIdentityColumns.map((c) => c.name).whereType<String>().toSet();

    _controllers.removeWhere((key, value) => !names.contains(key));
    for (final name in names) {
      _controllers.putIfAbsent(name, () => TextEditingController());
    }
  }

  Future<void> _submit() async {
    final data = <String, dynamic>{};

    _controllers.forEach((k, c) {
      data[k] = c.text.trim().isEmpty ? null : c.text.trim();
    });

    await context.read<PostgresTableEditorCubit>().insertRow(
          projectId: widget.projectId,
          tableName: widget.tableName,
          values: data,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostgresTableEditorCubit, PostgresTableEditorStates>(
      listener: (context, state) {
        setState(() => _loading = state is InsertRowLoading);

        if (state is InsertRowSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Row inserted successfully"),
              backgroundColor: Colors.green));

          context.read<PostgresTablesCubit>().getTable(
              projectId: widget.projectId, tableName: widget.tableName);
          context.read<PostgresTableEditorCubit>().getAllRows(
              projectId: widget.projectId,
              tableName: widget.tableName,
              showLoading: false);

          Navigator.pop(context);
        } else if (state is InsertRowError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message), backgroundColor: Colors.red));
        }
      },
      child: BlocBuilder<PostgresTablesCubit, dynamic>(
        builder: (context, state) {
          final List<PostgresColumnDetail> columns = context
                  .watch<PostgresTablesCubit>()
                  .cachedTablesMap[widget.tableName]
                  ?.columns ??
              [];
          
          _syncControllers(columns);

          final displayColumns = columns.where((col) => !(col.isIdentity ?? false)).toList();

          return Drawer(
            width: 420.w,
            backgroundColor: const Color(0xffF8FAFC),
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(20.w),
                    children: displayColumns.map((col) {
                      final name = col.name ?? "";
                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name,
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600)),
                            SizedBox(height: 8.h),
                            TextFormField(
                              controller: _controllers[name],
                              decoration: _inputDecoration("Enter $name"),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                _buildFooter(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Insert New Row",
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700)),
        Text("Table: ${widget.tableName}"),
      ]),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Row(
        children: [
          Expanded(
              child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"))),
          SizedBox(width: 12.w),
          Expanded(
            child: ElevatedButton(
              onPressed: _loading ? null : _submit,
              child: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Text("Insert Row"),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)));

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }
}