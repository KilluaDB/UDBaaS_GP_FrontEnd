import 'package:dbaas_project/core/util/ui_utils.dart';
import 'package:dbaas_project/features/no_sql_projects/collections/view_model/mongo_collections_cubit.dart';
import 'package:dbaas_project/features/no_sql_projects/collections/view_model/mongo_collections_states.dart';
import 'package:dbaas_project/features/no_sql_projects/dash_board/view/screens/empty_screen.dart';
import 'package:dbaas_project/features/no_sql_projects/dash_board/view/screens/full_screen.dart';
import 'package:dbaas_project/features/projects/data/models/project_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class DashBoardMongo extends StatefulWidget {
  final ProjectModel project;
  const DashBoardMongo({super.key, required this.project});

  @override
  State<DashBoardMongo> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoardMongo> {
  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: BlocConsumer<MongoCollectionsCubit, MongoCollectionsStates>(
        listener: (context, state) {
          if (state is GetMongoCollectionsLoading) {
            UiUtils.showLoading(context);
          } else {
            UiUtils.hideLoading();
          }

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
              return const EmptyScreen();
            } else {
              return MongoDashboardFullScreen(project: widget.project);
            }
          }

          return const EmptyScreen();
        },
      ),
    );
  }
}
