import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/util/ui_utils.dart';
import 'package:dbaas_project/features/no_sql_projects/collections/view/screens/empty_collection_screen.dart';
import 'package:dbaas_project/features/no_sql_projects/collections/view_model/mongo_collections_cubit.dart';
import 'package:dbaas_project/features/no_sql_projects/collections/view_model/mongo_collections_states.dart';
import 'package:dbaas_project/features/projects/data/models/project_model.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:dbaas_project/features/sql_projects/DB/view/screens/empty_database_screen.dart';
import 'package:dbaas_project/features/sql_projects/DB/view/screens/full_database_screen.dart';
import 'package:dbaas_project/features/sql_projects/DB/view_model/tables_cubit.dart';
import 'package:dbaas_project/features/sql_projects/DB/view_model/tables_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class Collections extends StatelessWidget {
  final ProjectModel project;

  final Function(String tableName, int index) onNavigate;

  const Collections({
    super.key,
    required this.project,
    required this.onNavigate,
  });

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
            'Database Collections',
               style: textTheme.headlineSmall!.copyWith(
              color: provider.isDark ? AppTheme.white : AppTheme.black,
              fontWeight: FontWeight.bold,
              fontSize: 22.sp,
            ),
          ),
      
          SizedBox(height: 24.h),

          Expanded(
            child: BlocConsumer<MongoCollectionsCubit, MongoCollectionsStates>(
              listener: (context, state) {
                if (state is GetMongoCollectionsError) {
                  final isNewProjectError =
                      state.message.contains('Invalid project ID') ||
                      state.message.contains('schema name');

                  if (!isNewProjectError) {
                    UiUtils.showErrorMessage(context, state.message);
                  }
                }

                if (state is CreateMongoCollectionSuccess) {
                  UiUtils.showSuccessMessage(
                    context,
                    "Collection created successfully",
                  );
                }
              },
              builder: (context, state) {
                final cubit = context.read<MongoCollectionsCubit>();

                if (state is GetMongoCollectionsLoading 
                   ) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is GetMongoCollectionsSuccess) {
                  final collectionList = state.collections;

                  if (collectionList.isEmpty) {
                    return const EmptyCollectionScreen();
                  }

                  return FullDatabaseScreen(
                    projectId: project.id!,
                    onTableSelected: (tableName) {
                      onNavigate(tableName, 2);
                    },
                  );
                }

              if (cubit.cachedCollections.isNotEmpty) {
                  final collectionList = cubit.cachedCollections ;

                  if (collectionList.isEmpty) {
                    return const EmptyCollectionScreen();
                  }

                  return FullDatabaseScreen(
                    projectId: project.id!,
                    onTableSelected: (tableName) {
                      onNavigate(tableName, 2);
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