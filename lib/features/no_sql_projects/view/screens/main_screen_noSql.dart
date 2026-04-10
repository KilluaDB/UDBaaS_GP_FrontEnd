import 'package:dbaas_project/features/projects/data/models/project_model.dart';
import 'package:dbaas_project/features/no_sql_projects/view/screens/tabs/collection_editor.dart';
import 'package:dbaas_project/features/no_sql_projects/view/screens/tabs/collections.dart';
import 'package:dbaas_project/features/projects/view/screens/delete_screen.dart';
import 'package:dbaas_project/features/sql_projects/dash_board/dash_board.dart';
import 'package:dbaas_project/features/projects/view/widgets/drawer/drawer.dart';
import 'package:flutter/material.dart';

class MainScreenNOSQL extends StatefulWidget {
  static const String routeName = '/noSqlProject';
  const MainScreenNOSQL({super.key});

  @override
  State<MainScreenNOSQL> createState() => _MainScreenNOSQLState();
}

class _MainScreenNOSQLState extends State<MainScreenNOSQL> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    ProjectModel project =

        ModalRoute.of(context)!.settings.arguments as ProjectModel;
  final List<Widget> tabs = [DashBoard(), CollectionEditor(), Collections(),DeleteScreen(project: project)];
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
