import 'package:dbaas_project/core/util/ui_utils.dart';
import 'package:dbaas_project/features/projects/data/models/project_model.dart';
import 'package:dbaas_project/features/sql_projects/DB/view/screens/empty_database_screen.dart';
import 'package:dbaas_project/features/sql_projects/DB/view/screens/full_database_screen.dart';
import 'package:dbaas_project/features/sql_projects/DB/view_model/tables_cubit.dart';
import 'package:dbaas_project/features/sql_projects/DB/view_model/tables_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DataBaseTab extends StatefulWidget {
  final ProjectModel project;

  final Function(String tableName, int index) onNavigate;

  const DataBaseTab({
    super.key,
    required this.project,
    required this.onNavigate,
  });

  @override
  State<DataBaseTab> createState() => _DataBaseTabState();
}

class _DataBaseTabState extends State<DataBaseTab> {
@override
  void initState() {
    super.initState();
 
    context.read<PostgresTablesCubit>().getAllTables(widget.project.id!);
  }
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Database Tables',
            style: textTheme.headlineSmall,
          ),
          SizedBox(height: 4.h),
          Text(
            'Manage your database tables and schemas',
            style: textTheme.titleMedium,
          ),
          SizedBox(height: 24.h),

          Expanded(
            child: BlocConsumer<PostgresTablesCubit, PostgresTablesStates>(
              listener: (context, state) {
                if (state is GetAllTablesError) {
                  final isNewProjectError =
                      state.message.contains('Invalid project ID') ||
                      state.message.contains('schema name');

                  if (!isNewProjectError) {
                    UiUtils.showErrorMessage(context, state.message);
                  }
                }

                if (state is CreateTableSuccess) {
                  UiUtils.showSuccessMessage(
                    context,
                    "Table created successfully",
                  );
                }
              },
              builder: (context, state) {
                final cubit = context.read<PostgresTablesCubit>();

                if (state is GetAllTablesLoading &&
                    cubit.cachedTables == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is GetAllTablesSuccess) {
                  final tablesList = state.getTablesSuccessResponse.data ?? [];

                  if (tablesList.isEmpty) {
                    return const EmptyDatabaseScreen();
                  }

                  return FullDatabaseScreen(
                    projectId: widget.project.id!,
                    onTableSelected: (tableName) {
                      widget.onNavigate(tableName, 2);
                    },
                  );
                }

                if (cubit.cachedTables != null) {
                  final tablesList = cubit.cachedTables!.data ?? [];

                  if (tablesList.isEmpty) {
                    return const EmptyDatabaseScreen();
                  }

                  return FullDatabaseScreen(
                    projectId: widget.project.id!,
                    onTableSelected: (tableName) {
                      widget.onNavigate(tableName, 2);
                    },
                  );
                }

                return const EmptyDatabaseScreen();
              },
            ),
          ),
        ],
      ),
    );
  }
}