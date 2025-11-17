import 'package:flutter/material.dart';

class CloudTab extends StatelessWidget {
  static const String routeName = '/cloudProjects';

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(

      body: Column(
        children: [
          Text('Cloud Management',
          
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
