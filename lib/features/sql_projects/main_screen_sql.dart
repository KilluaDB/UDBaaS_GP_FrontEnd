import 'package:dbaas_project/features/projects/data/models/project_model.dart';
import 'package:dbaas_project/features/settings/viewModel/user_provider.dart';
import 'package:dbaas_project/features/sql_projects/dash_board/dash_board.dart';
import 'package:dbaas_project/features/sql_projects/query/view/screens/query_editor.dart';
import 'package:dbaas_project/features/sql_projects/query/view_model/query_cubit.dart';
import 'package:dbaas_project/features/sql_projects/schema_visulization/schema_visualizer.dart';
import 'package:dbaas_project/features/sql_projects/schema_generation/scheme_generator.dart';
import 'package:dbaas_project/features/sql_projects/table_editor/table_editor.dart';
import 'package:dbaas_project/features/sql_projects/DB/tables.dart';
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

  @override
  Widget build(BuildContext context) {
 
    final project = ProjectModel(
      dbType: 'sql',
      id: '1',
      name: 'test',
      resourceTier: 'free',
    );

  
    final List<Widget> tabs = [
      DashBoard(),
      Tables(),
      TableEditor(),
      QueryEditor(project: project),
      SchemaVisualizer(),
      SchemeGenerator(),
    ];

  
    return BlocProvider(
      create: (context) => QueryCubit(
        userProvider: context.read<UserProvider>(),
      ),
      child: Scaffold(
        body: Row(
          children: [
            ProjectDrawer(
              project: project,
              selectedIndex: selectedIndex,
              onItemSelected: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
    
            Expanded(child: tabs[selectedIndex]),
          ],
        ),
      ),
    );
  }
}