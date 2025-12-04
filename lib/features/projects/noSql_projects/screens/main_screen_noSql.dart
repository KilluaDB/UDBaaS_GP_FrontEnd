import 'package:dbaas_project/core/models/project_model.dart';
import 'package:dbaas_project/core/screens/dash_board.dart';
import 'package:dbaas_project/features/projects/noSql_projects/screens/collection_editor.dart';
import 'package:dbaas_project/features/projects/noSql_projects/screens/collections.dart';
import 'package:dbaas_project/features/projects/widgets/drawer/drawer.dart';
import 'package:flutter/material.dart';

class MainScreenNOSQL extends StatefulWidget {
    static const String routeName = '/noSqlProject';
  const MainScreenNOSQL({super.key});

  @override
  State<MainScreenNOSQL> createState() => _MainScreenNOSQLState();
}

class _MainScreenNOSQLState extends State<MainScreenNOSQL> {
    int selectedIndex = 0;

  final List<Widget> tabs = [
      DashBoard(),
    CollectionEditor(),
    Collections(),
  
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