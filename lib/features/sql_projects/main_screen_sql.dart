import 'package:dbaas_project/features/project_info/view_model/project_info_cubit.dart';
import 'package:dbaas_project/features/projects/data/models/project_model.dart';
import 'package:dbaas_project/features/projects/view/screens/delete_screen.dart';
import 'package:dbaas_project/features/settings/viewModel/user_provider.dart';
import 'package:dbaas_project/features/sql_projects/DB/view/widgets/drawer_db.dart';
import 'package:dbaas_project/features/sql_projects/DB/view_model/tables_cubit.dart';
import 'package:dbaas_project/features/sql_projects/DB/view_model/tables_states.dart';
import 'package:dbaas_project/features/sql_projects/dash_board/view/screens/dash_board.dart';
import 'package:dbaas_project/features/sql_projects/dash_board/view_model/dash_cubit.dart';
import 'package:dbaas_project/features/sql_projects/index_tab/data/api_service/index_api_service.dart';
import 'package:dbaas_project/features/sql_projects/index_tab/view/screens/Index_tab.dart';
import 'package:dbaas_project/features/sql_projects/index_tab/view/widgets/index_drawer.dart';
import 'package:dbaas_project/features/sql_projects/index_tab/view_model/index_cubit.dart';
import 'package:dbaas_project/features/sql_projects/query/view/screens/query_editor.dart';
import 'package:dbaas_project/features/sql_projects/query/view_model/query_cubit.dart';
import 'package:dbaas_project/features/sql_projects/schema_generation/view_model/generation_cubit.dart';
import 'package:dbaas_project/features/sql_projects/schema_visulization/view/presentation/schema_visualizer.dart';
import 'package:dbaas_project/features/sql_projects/schema_generation/view/screens/scheme_generator.dart';
import 'package:dbaas_project/features/sql_projects/schema_visulization/view_model/schema_cubit.dart';
import 'package:dbaas_project/features/sql_projects/table_editor/view/screens/table_editor.dart';
import 'package:dbaas_project/features/sql_projects/DB/view/screens/database_tab.dart';
import 'package:dbaas_project/features/projects/view/widgets/drawer/drawer.dart';
import 'package:dbaas_project/features/sql_projects/table_editor/view_model/edits_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class MainScreenSQL extends StatefulWidget {
  static const String routeName = '/SqlProject';

  const MainScreenSQL({super.key});

  @override
  State<MainScreenSQL> createState() => _MainScreenSQLState();
}

class _MainScreenSQLState extends State<MainScreenSQL> {
  int selectedIndex = 0;
  String selectedTableName = '';

  @override
  Widget build(BuildContext context) {
    final ProjectModel project =
        ModalRoute.of(context)!.settings.arguments as ProjectModel;

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return MultiBlocProvider(
      providers: [
        BlocProvider<PostgresTablesCubit>(
          create: (context) =>
              PostgresTablesCubit(userProvider: userProvider)
                ..getAllTables(project.id!, isSilentRefresh: false),
        ),
        BlocProvider<ProjectAccessCubit>(
          create: (context) => ProjectAccessCubit(userProvider: userProvider)
            ..getProjectAccess(projectId: project.id!, isSilentRefresh: false),
        ),
        BlocProvider<DashCubit>(
          create: (context) => DashCubit(userProvider: userProvider),
        ),

        BlocProvider<PostgresTableEditorCubit>(
          create: (context) =>
              PostgresTableEditorCubit(userProvider: userProvider),
        ),
        BlocProvider<IndexCubit>(
          create: (context) => IndexCubit(userProvider: userProvider),
        ),
        BlocProvider<QueryCubit>(
          create: (context) => QueryCubit(userProvider: userProvider),
        ),

        BlocProvider<SchemaCubit>(
          create: (context) => SchemaCubit(userProvider: userProvider),
        ),
        BlocProvider<SchemaGenerationCubit>(
          create: (context) =>
              SchemaGenerationCubit(userProvider: userProvider),
        ),
      ],

      child: Builder(
        builder: (context) {
          final List<Widget> tabs = [
            DashBoard(project: project),

            DataBaseTab(
              project: project,
              onNavigate: (tableName, index) {
                setState(() {
                  selectedIndex = index;
                  selectedTableName = tableName;
                });

                context.read<PostgresTableEditorCubit>().getAllRows(
                  projectId: project.id!,
                  tableName: tableName,
                  showLoading: false,
                );
              },
            ),

            TableEditor(
              key: ValueKey(selectedTableName),
              tableName: selectedTableName,
              project: project,
            ),

            QueryEditor(project: project),

            SchemaVisualizer(project: project),

            SchemeGenerator(project: project),
            IndexTab(project: project),

            DeleteScreen(project: project),
          ];

          return Scaffold(
       endDrawer: selectedIndex == 1
    ? DrawerDB(projectId: project.id!)
    : CreateIndexDrawer(
            projectId: project.id!,
        
          ),
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

                    if (index == 4) {
                      context.read<SchemaCubit>().visualizeSchema(
                        projectId: project.id!,
                      );
                    }

                    if (index == 1) {
                      context.read<PostgresTablesCubit>().getAllTables(
                        project.id!,
                        isSilentRefresh: true,
                      );
                    }

                    if (index == 2 && selectedTableName.isNotEmpty) {
                      context.read<PostgresTableEditorCubit>().getAllRows(
                        projectId: project.id!,
                        tableName: selectedTableName,
                        showLoading: false,
                      );
                    }
                  },
                ),

                Expanded(
                  child: BlocBuilder<PostgresTablesCubit, PostgresTablesStates>(
                    builder: (context, state) {
                      final cubit = context.read<PostgresTablesCubit>();

                      if (state is GetAllTablesLoading &&
                          cubit.cachedTables == null) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return IndexedStack(index: selectedIndex, children: tabs);
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
