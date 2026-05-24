import 'package:flutter/material.dart';
class TableEditor extends StatelessWidget {
  final String tableName;
  const TableEditor({super.key,required this.tableName});

  @override
  Widget build(BuildContext context) {


    return  Center(child: Text("Please select a table from the sidebar ${tableName}"));
  }
}