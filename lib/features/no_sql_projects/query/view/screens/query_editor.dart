import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/util/ui_utils.dart';
import 'package:dbaas_project/features/no_sql_projects/collections/view_model/mongo_collections_cubit.dart';
import 'package:dbaas_project/features/no_sql_projects/collections/view_model/mongo_collections_states.dart';
import 'package:dbaas_project/features/no_sql_projects/query/view/screens/empty_tab_query.dart';
import 'package:dbaas_project/features/no_sql_projects/query/view/screens/full_query_tab.dart';
import 'package:dbaas_project/features/projects/data/models/project_model.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';

import 'package:dbaas_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class QueryMongoEditor extends StatefulWidget {
  final ProjectModel project;
  const QueryMongoEditor({super.key, required this.project});

  @override
  State<QueryMongoEditor> createState() => _QueryEditorState();
}

class _QueryEditorState extends State<QueryMongoEditor> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final SettingsProvider provider = Provider.of<SettingsProvider>(context);
    AppLocalizations local = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 0.05.sw),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
             "Mongo Query Editor",
            style: textTheme.headlineSmall!.copyWith(
              color: provider.isDark ? AppTheme.white : AppTheme.black,
              fontWeight: FontWeight.bold,
              fontSize: 22.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Write and execute database queries',
            style: textTheme.titleMedium!.copyWith(
              fontSize: 16.sp,
              color: provider.isDark ? AppTheme.white : AppTheme.black,
            ),
          ),
          SizedBox(height: 24.h),

          Expanded(
            child: BlocConsumer<MongoCollectionsCubit, MongoCollectionsStates>(
              listener: (context, state) {
           

                if (state is GetMongoCollectionsError) {
                  bool isNewProjectSchemaError =
                      state.message.contains('Invalid project ID') ||
                      state.message.contains('schema name');

                  if (!isNewProjectSchemaError) {
                    UiUtils.showErrorMessage(context, state.message);
                  }
                }
              },
              builder: (context, state) {
                if (state is GetMongoCollectionsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is GetMongoCollectionsSuccess) {
                  final collectionList =
                      (state.collections as List?) ?? [];

                  if (collectionList.isEmpty) {
                    return  EmptyTabMongoQuery();
                  } else {
                    return FullQueryMongoTab(project: widget.project);
                  }
                }

                return const EmptyTabMongoQuery();
              },
            ),
          ),
        ],
      ),
    );
  }
}
