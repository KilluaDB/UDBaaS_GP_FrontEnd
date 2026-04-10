import 'package:dbaas_project/features/projects/data/models/project_model.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:dbaas_project/features/sql_projects/query/view/widgets/query_section.dart';
import 'package:dbaas_project/features/sql_projects/query/view/widgets/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';

late TextTheme textTheme;
late SettingsProvider provider;

class FullQueryTab extends StatelessWidget {

  ProjectModel project;
   FullQueryTab({required this.project});
  @override
  Widget build(BuildContext context) {
    provider = Provider.of<SettingsProvider>(context);
    textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        QueryPart(project:project),
        SizedBox(height: 24.h),
        ResultPart(),
      ],
    );
  }
}
