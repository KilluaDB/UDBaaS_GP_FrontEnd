import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/provider/settings_provider.dart';
import 'package:dbaas_project/features/projects/sql_projects/query_tab/widgets/empty_tab_query.dart';
import 'package:dbaas_project/features/projects/sql_projects/query_tab/widgets/full_query_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class QueryEditor extends StatelessWidget {
  bool isEmpty = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final SettingsProvider provider = Provider.of<SettingsProvider>(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 0.05.sw),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SQL Editor',
            style: textTheme.headlineSmall!.copyWith(
              color: AppTheme.black,
              fontWeight: FontWeight.bold,
              fontSize: 22.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Write and execute database queries',
            style: textTheme.titleMedium!.copyWith(fontSize: 16.sp),
          ),
          SizedBox(height: 24.h),
          isEmpty ? EmptyTabQuery() : FullQueryTab(),
        ],
      ),
    );
  }
}
