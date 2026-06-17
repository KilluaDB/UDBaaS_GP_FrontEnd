import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/util/ui_utils.dart';
import 'package:dbaas_project/features/projects/data/models/project_model.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:dbaas_project/features/sql_projects/DB/view_model/tables_cubit.dart';
import 'package:dbaas_project/features/sql_projects/DB/view_model/tables_states.dart';
import 'package:dbaas_project/features/sql_projects/index_tab/view/screens/empty_screen.dart';
import 'package:dbaas_project/features/sql_projects/index_tab/view/screens/full_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class IndexTab extends StatelessWidget {
  final ProjectModel project;


   IndexTab({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final SettingsProvider provider = Provider.of<SettingsProvider>(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Database Indexes',
            style: textTheme.headlineSmall!.copyWith(
              color: provider.isDark ? AppTheme.white : AppTheme.black,
              fontWeight: FontWeight.bold,
              fontSize: 22.sp,
            ),
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
                    return  IndexEmptyScreen();
                  }

                  return IndexFullScreen(projectId: project.id!,);
                }

                if (cubit.cachedTables != null) {
                  final tablesList = cubit.cachedTables!.data ?? [];

                  if (tablesList.isEmpty) {
                    return  IndexEmptyScreen();
                  }

                  return IndexFullScreen(projectId: project.id!,);
                }

                return  IndexEmptyScreen();
              },
            ),
          ),
        ],
      ),
    );
  }
}
