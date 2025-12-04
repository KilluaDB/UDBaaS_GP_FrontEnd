import 'package:dbaas_project/core/models/project_model.dart';
import 'package:dbaas_project/core/screens/dash_board.dart';
import 'package:dbaas_project/features/projects/sql_projects/screens/query_editor.dart';
import 'package:dbaas_project/features/projects/sql_projects/screens/schema_visualizer.dart';
import 'package:dbaas_project/features/projects/sql_projects/screens/scheme_generator.dart';
import 'package:dbaas_project/features/projects/sql_projects/screens/table_editor.dart';
import 'package:dbaas_project/features/projects/sql_projects/screens/tables.dart';
import 'package:dbaas_project/features/projects/widgets/drawer/drawer.dart';
import 'package:flutter/material.dart';

class MainScreenSQL extends StatefulWidget {
  static const String routeName = '/SqlProject';
  const MainScreenSQL({super.key});

  @override
  State<MainScreenSQL> createState() => _MainScreenSQLState();
}

class _MainScreenSQLState extends State<MainScreenSQL> {
  int selectedIndex = 0;

  final List<Widget> tabs = [
    DashBoard(),
    Tables(),
    TableEditor(),

    QueryEditor(),
    SchemaVisualizer(),
    SchemeGenerator(),
  ];
  @override
  Widget build(BuildContext context) {
    ProjectModel project =
        ModalRoute.of(context)!.settings.arguments as ProjectModel;
    return Scaffold(
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
    );
  }
}
