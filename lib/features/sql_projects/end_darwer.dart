import 'package:dbaas_project/features/projects/data/models/project_model.dart';
import 'package:dbaas_project/features/sql_projects/DB/view/widgets/drawer_db.dart';
import 'package:dbaas_project/features/sql_projects/schema_generation/view/widgets/drawer_chatbot.dart';
import 'package:dbaas_project/features/sql_projects/table_editor/view/widgets/drawer_table.dart';
import 'package:flutter/material.dart';

class EndDarwer extends StatelessWidget {
  int selectedIndex;
  ProjectModel project;
  EndDarwer({required this.selectedIndex,required this.project});

  @override
  Widget build(BuildContext context) {
    switch (selectedIndex) {
      case 1:
        return DrawerDB(projectId: project.id!,);
      case 2:
        return DrawerTable();
      case 5:
        return DrawerChatbot();
    }
    return SizedBox();
  }
}
