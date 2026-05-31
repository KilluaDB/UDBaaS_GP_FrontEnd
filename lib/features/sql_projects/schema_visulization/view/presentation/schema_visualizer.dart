import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/util/ui_utils.dart';
import 'package:dbaas_project/features/projects/data/models/project_model.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:dbaas_project/features/settings/viewModel/user_provider.dart';
import 'package:dbaas_project/features/sql_projects/DB/view_model/tables_cubit.dart';
import 'package:dbaas_project/features/sql_projects/DB/view_model/tables_states.dart';
import 'package:dbaas_project/features/sql_projects/schema_visulization/view/presentation/empty_tab.dart';
import 'package:dbaas_project/features/sql_projects/schema_visulization/view/presentation/full_screen_tab.dart';
import 'package:dbaas_project/features/sql_projects/schema_visulization/view_model/schema_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SchemaVisualizer extends StatefulWidget {
  final ProjectModel project;
   SchemaVisualizer({super.key, required this.project});

  @override
  State<SchemaVisualizer> createState() => _SchemaVisualizerState();
}

class _SchemaVisualizerState extends State<SchemaVisualizer> {

    
    @override
@override
void initState() {
  super.initState();
  context.read<SchemaCubit>().visualizeSchema(
    projectId: widget.project.id!,
  );
  
 
  context.read<PostgresTablesCubit>().getAllTables(
   widget.project.id!, 
    isSilentRefresh: false
  );
}
  
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final SettingsProvider provider = Provider.of<SettingsProvider>(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 0.05.sw),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Schema Visualizer",
            style: textTheme.headlineSmall!.copyWith(
              color: provider.isDark ? AppTheme.white : AppTheme.black,
              fontWeight: FontWeight.bold,
              fontSize: 22.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Interactive database schema diagram with relationships',
            style: textTheme.titleMedium!.copyWith(
              fontSize: 16.sp,
              color: provider.isDark ? AppTheme.white : AppTheme.black,
            ),
          ),
          SizedBox(height: 24.h),

          Expanded(
            child: BlocConsumer<PostgresTablesCubit, PostgresTablesStates>(
              listener: (context, state) {
                if (state is GetAllTablesLoading) {
                  UiUtils.showLoading(context);
                } else {
                  UiUtils.hideLoading();
                }

                if (state is GetAllTablesError) {
                  bool isNewProjectSchemaError =
                      state.message.contains('Invalid project ID') ||
                      state.message.contains('schema name');

                  if (!isNewProjectSchemaError) {
                    UiUtils.showErrorMessage(context, state.message);
                  }
                }
              },
              builder: (context, state) {
                if (state is GetAllTablesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is GetAllTablesSuccess) {
                  final tablesList =
                      (state.getTablesSuccessResponse.data as List?) ?? [];

                  if (tablesList.isEmpty) {
                    return const EmptyTab();
                  } else {
                    return FullScreenTab(project: widget.project);
                  }
                }

                return const EmptyTab();
              },
            ),
          ),
        ],
      ),
    );
  }
}