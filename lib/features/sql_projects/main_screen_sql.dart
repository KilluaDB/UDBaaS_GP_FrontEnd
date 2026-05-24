import 'package:dbaas_project/features/projects/data/models/project_model.dart';
import 'package:dbaas_project/features/projects/view/screens/delete_screen.dart';
import 'package:dbaas_project/features/settings/viewModel/user_provider.dart';
import 'package:dbaas_project/features/sql_projects/DB/view_model/tables_cubit.dart';
import 'package:dbaas_project/features/sql_projects/dash_board/view/screens/dash_board.dart';
import 'package:dbaas_project/features/sql_projects/end_darwer.dart';
import 'package:dbaas_project/features/sql_projects/query/view/screens/query_editor.dart';
import 'package:dbaas_project/features/sql_projects/query/view_model/query_cubit.dart';
import 'package:dbaas_project/features/sql_projects/schema_visulization/schema_visualizer.dart';
import 'package:dbaas_project/features/sql_projects/schema_generation/view/screens/scheme_generator.dart';
import 'package:dbaas_project/features/sql_projects/table_editor/table_editor.dart';
import 'package:dbaas_project/features/sql_projects/DB/view/screens/database_tab.dart';
import 'package:dbaas_project/features/projects/view/widgets/drawer/drawer.dart';
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
  String selectedTableName='';

  @override
  Widget build(BuildContext context) {
    final project = ModalRoute.of(context)!.settings.arguments as ProjectModel;
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return MultiBlocProvider(
      providers: [
        BlocProvider<QueryCubit>(
          create: (context) => QueryCubit(userProvider: userProvider),
        ),
        BlocProvider<PostgresTablesCubit>(
          create: (context) => PostgresTablesCubit(userProvider: userProvider)
            ..getAllTables(project.id!), 
        ),
      ],
      child: Builder(
        builder: (context) {
          final List<Widget> tabs = [
            const DashBoard(),
            DataBaseTab(
              project: project,
              onNavigate: (tableName, index) {
                setState(() {
                  selectedIndex = index;
                  selectedTableName = tableName;
                });
              },
            ),
            TableEditor(
              key: ValueKey(selectedTableName), 
              tableName: selectedTableName,
            ),
            QueryEditor(project: project), 
            const SchemaVisualizer(),
            const SchemeGenerator(),
            DeleteScreen(project: project),
          ];

          return Scaffold(
            endDrawer: EndDarwer(selectedIndex: selectedIndex, project: project),
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
    context.read<PostgresTablesCubit>()
        .getAllTables(project.id!, isSilentRefresh: false);
  }
                  },
                ),
                Expanded(
                  child: IndexedStack(
                    index: selectedIndex,
                    children: tabs,
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