import 'package:dbaas_project/features/sql_projects/dash_board/view/screens/empty_screen.dart';
import 'package:dbaas_project/features/sql_projects/dash_board/view/screens/full_screen.dart';
import 'package:flutter/material.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardFullScreen();
  }
}
