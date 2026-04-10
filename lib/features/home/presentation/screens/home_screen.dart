import 'package:dbaas_project/features/cloud/view/screens/cloud_tab.dart';
import 'package:dbaas_project/features/home/presentation/screens/drawer.dart';
import 'package:dbaas_project/features/projects/view/screens/project_tab.dart';
import 'package:dbaas_project/features/projects/view_model/project_cubit.dart';
import 'package:dbaas_project/features/settings/view/presentation/settings_screen.dart';
import 'package:dbaas_project/features/settings/viewModel/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final List<Widget> tabs =  [
    ProjectTab(),
    CloudTab(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeDrawer(
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
