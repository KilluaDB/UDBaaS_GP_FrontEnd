import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/features/projects/data/models/project_model.dart';
import 'package:dbaas_project/features/projects/view/screens/delete_screen.dart';

import 'package:dbaas_project/features/sql_projects/dash_board/view/screens/dash_board.dart';
import 'package:dbaas_project/features/sql_projects/query/view/screens/query_editor.dart';
import 'package:dbaas_project/features/sql_projects/schema_visulization/schema_visualizer.dart';
import 'package:dbaas_project/features/sql_projects/schema_generation/view/screens/scheme_generator.dart';
import 'package:dbaas_project/features/sql_projects/table_editor/table_editor.dart';
import 'package:dbaas_project/features/sql_projects/DB/tables.dart';
import 'package:dbaas_project/features/projects/view/widgets/drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


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
 

    ProjectModel project =

        ModalRoute.of(context)!.settings.arguments as ProjectModel;
  
    final List<Widget> tabs = [
      DashBoard(),
      Tables(),
      TableEditor(),
      QueryEditor(project: project),
      SchemaVisualizer(),
      SchemeGenerator(),
      DeleteScreen(project: project,)
    ];

  
    return Scaffold(
   floatingActionButton: Transform.scale(
  scale: 1.2, 
  child: FloatingActionButton(
  
    onPressed: () {},
    backgroundColor: AppTheme.primary,
    shape: const CircleBorder(),
    child: const Icon(
      Icons.chat_bubble_outline,
      color: AppTheme.white,
      size: 28, 
    ),
  ),
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
            },
          ),
        
          Expanded(child: tabs[selectedIndex]),
        ],
      ),
    );
  }
}