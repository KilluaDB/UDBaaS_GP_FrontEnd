import 'package:flutter/material.dart';

class SettingsTab extends StatelessWidget {
  static const String routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(

      body: Column(
        children: [
          Text('SettingsTab Management',
          
          ),
          Text('Manage your cloud resources and deployments'),
          SizedBox(
            width: 448,
            height: 36,
            child: TextField(
              
              decoration: InputDecoration(
                hintText: 'Search projects',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
