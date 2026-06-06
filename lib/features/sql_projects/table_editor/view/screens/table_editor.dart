import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/util/ui_utils.dart';
import 'package:dbaas_project/features/projects/data/models/project_model.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:dbaas_project/features/sql_projects/table_editor/view/screens/editor_empty_screen.dart';
import 'package:dbaas_project/features/sql_projects/table_editor/view/screens/editor_full_screen.dart';
import 'package:dbaas_project/features/sql_projects/table_editor/view_model/edits_cubit.dart';
import 'package:dbaas_project/features/sql_projects/table_editor/view_model/edits_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
class TableEditor extends StatefulWidget {
  final ProjectModel project;
  final String tableName;

  const TableEditor({
    super.key,
    required this.project,
    required this.tableName,
  });

  @override
  State<TableEditor> createState() => _TableEditorState();
}

class _TableEditorState extends State<TableEditor> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final provider = Provider.of<SettingsProvider>(context);

    final hasTableSelected = widget.tableName.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 0.05.sw),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Table Editor",
            style: textTheme.headlineSmall!.copyWith(
              color: provider.isDark ? AppTheme.white : AppTheme.black,
              fontWeight: FontWeight.bold,
              fontSize: 22.sp,
            ),
          ),

          SizedBox(height: 4.h),

          Text(
            'Edit table rows and manage your database content',
            style: textTheme.titleMedium!.copyWith(
              fontSize: 16.sp,
              color: provider.isDark ? AppTheme.white : AppTheme.black,
            ),
          ),

          SizedBox(height: 24.h),

          Expanded(
            child: !hasTableSelected
                ?  EditorEmptyScreen()
                : BlocConsumer<PostgresTableEditorCubit,
                    PostgresTableEditorStates>(
                    listener: (context, state) {
                      if (state is GetAllRowsLoading) {
                        UiUtils.showLoading(context);
                      } else {
                        UiUtils.hideLoading();
                      }

                      if (state is GetAllRowsError) {
                        UiUtils.showErrorMessage(context, state.message);
                      }
                    },

                    builder: (context, state) {
               final cubit = context.read<PostgresTableEditorCubit>();

  final rows = (state is GetAllRowsSuccess)
      ? state.getRowsResponse.rows
      : cubit.cachedRows?.rows ?? [];
                      final isLoading = state is GetAllRowsLoading;

                      return EditorFullScreen(
                        projectId: widget.project.id!,
                        tableName: widget.tableName,
                        rows: rows, 
                        isLoading: isLoading,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}