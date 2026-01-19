import 'package:dbaas_project/features/cloud_feature/presentation/cloud_tab.dart';
import 'package:dbaas_project/features/home/widgets/drawer.dart';
import 'package:dbaas_project/features/projects/project_tab.dart';
import 'package:dbaas_project/features/settings/view/presentation/settings_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final List<Widget> tabs = [ProjectTab(), CloudTab(), SettingsScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
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
