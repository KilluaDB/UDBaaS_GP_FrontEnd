import 'package:dbaas_project/features/sql_projects/table_editor/view/widgets/insert_column_drawer.dart';
import 'package:dbaas_project/features/sql_projects/table_editor/view/widgets/insert_row_drawer.dart';
import 'package:flutter/material.dart';

class DrawerTable extends StatelessWidget {
  final String selectedIndex;
  final String tableName;
  final String projectId;

  const DrawerTable({
    super.key,
    required this.selectedIndex,
    required this.tableName,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedIndex == 'column') {
      return  InsertColumnDrawer(tableName: tableName,projectId: projectId,);
    }

    return  InsertRowDrawer(tableName:tableName ,projectId: projectId,);
  }
}