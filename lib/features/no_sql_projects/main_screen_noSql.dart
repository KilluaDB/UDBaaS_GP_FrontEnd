import 'package:dbaas_project/features/no_sql_projects/collections/view/widgets/create_colletion_sheet.dart';
import 'package:dbaas_project/features/no_sql_projects/collections/view_model/mongo_collections_cubit.dart';
import 'package:dbaas_project/features/no_sql_projects/collections/view_model/mongo_collections_states.dart';
import 'package:dbaas_project/features/no_sql_projects/collections_editor/view/screens/collection_editor.dart';
import 'package:dbaas_project/features/no_sql_projects/collections_editor/view_model/mongo_editor_cubit.dart';
import 'package:dbaas_project/features/no_sql_projects/dash_board/view/screens/dash_board.dart';
import 'package:dbaas_project/features/no_sql_projects/dash_board/view_model/mongo_dashboard_cubit.dart';
import 'package:dbaas_project/features/no_sql_projects/query/view_model/query_mongo_cubit.dart';
import 'package:dbaas_project/features/projects/data/models/project_model.dart';
import 'package:dbaas_project/features/no_sql_projects/collections/view/screens/collections.dart';
import 'package:dbaas_project/features/projects/view/screens/delete_screen.dart';
import 'package:dbaas_project/features/settings/viewModel/user_provider.dart';
import 'package:dbaas_project/features/projects/view/widgets/drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class MainScreenNOSQL extends StatefulWidget {
  static const String routeName = '/noSqlProject';
  const MainScreenNOSQL({super.key});

  @override
  State<MainScreenNOSQL> createState() => _MainScreenNOSQLState();
}

class _MainScreenNOSQLState extends State<MainScreenNOSQL> {
  int selectedIndex = 0;
  String selectedCollectionName = '';

  @override
  Widget build(BuildContext context) {
    ProjectModel project =
        ModalRoute.of(context)!.settings.arguments as ProjectModel;
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return MultiBlocProvider(
      providers: [
        BlocProvider<MongoCollectionsCubit>(
          create: (context) =>
              MongoCollectionsCubit(userProvider: userProvider)
                ..getCollections(project.id!, isSilentRefresh: false),
        ),

        BlocProvider<MongoDashboardCubit>(
          create: (context) => MongoDashboardCubit(userProvider: userProvider),
        ),

        BlocProvider<MongoEditorCubit>(
          create: (context) => MongoEditorCubit(userProvider: userProvider),
        ),

        BlocProvider<MongoQueryCubit>(
          create: (context) => MongoQueryCubit(userProvider: userProvider),
        ),
      ],

      child: Builder(
        builder: (context) {
          final List<Widget> tabs = [
            DashBoardMongo(project: project),

            Collections(
              project: project,
              onNavigate: (collectionName, index) {
                setState(() {
                  selectedIndex = index;
                  selectedCollectionName = collectionName;
                });

                context.read<MongoEditorCubit>().getDocuments(
                  projectId: project.id!,
                  collection: collectionName,
                  showLoading: false,
                );
              },
            ),

            CollectionEditor(
              // key: ValueKey(selectedCollectionName),
              // tableName: selectedCollectionName,
              // project: project,
            ),

            DeleteScreen(project: project),
          ];

          return Scaffold(
         

            body: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProjectDrawer(
                  project: project,
                  selectedIndex: selectedIndex,
                  onItemSelected: (index) {
                    setState(() {
                      selectedIndex = index;
                    });

                    if (index == 1) {
                      context.read<MongoCollectionsCubit>().getCollections(
                        project.id!,
                        isSilentRefresh: true,
                      );
                    }

                    // if (index == 2 && selectedCollectionName.isNotEmpty) {
                    //   context.read<PostgresTableEditorCubit>().getAllRows(
                    //         projectId: project.id!,
                    //         tableName: selectedTableName,
                    //         showLoading: false
                    //       );
                    // }
                  },
                ),

                Expanded(
                  child:
                      BlocBuilder<
                        MongoCollectionsCubit,
                        MongoCollectionsStates
                      >(
                        builder: (context, state) {
                          final cubit = context.read<MongoCollectionsCubit>();

                          if (state is GetMongoCollectionsLoading &&
                              cubit.cachedCollections.isEmpty) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return IndexedStack(
                            index: selectedIndex,
                            children: tabs,
                          );
                        },
                      ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
