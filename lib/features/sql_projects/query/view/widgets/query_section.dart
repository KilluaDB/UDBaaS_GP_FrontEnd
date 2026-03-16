import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/util/ui_utils.dart';
import 'package:dbaas_project/features/projects/data/models/project_model.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:dbaas_project/features/settings/viewModel/user_provider.dart';
import 'package:dbaas_project/features/sql_projects/query/view/screens/full_query_tab.dart';
import 'package:dbaas_project/features/sql_projects/query/view_model/query_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class QueryPart extends StatefulWidget {
  ProjectModel project;
   QueryPart({required this.project});

  @override
  State<QueryPart> createState() => _QueryPartState();
}

class _QueryPartState extends State<QueryPart> {
late TextEditingController _queryController;

  @override
  void initState() {
    super.initState();
    _queryController = TextEditingController();
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    provider = Provider.of<SettingsProvider>(context);
    textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: provider.isDark ? AppTheme.black : AppTheme.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          width: 1.w,
          color: provider.isDark
              ? AppTheme.white
              : AppTheme.backgroundColor.withOpacity(0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         
          Row(
            children: [
              Icon(Icons.code, size: 28.sp, color: AppTheme.primary),
              SizedBox(width: 12.w),
              Text(
                'SQL Query Editor',
                style: textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: provider.isDark ? AppTheme.white : AppTheme.black,
                ),
              ),
            ],
          ),

          SizedBox(height: 6.h),
          Text(
            'Execute queries against your database tables',
            style: textTheme.bodySmall!.copyWith(
              fontSize: 12.sp,
              color: provider.isDark ? AppTheme.white : AppTheme.black,
            ),
          ),

          SizedBox(height: 16.h),

        
          Container(
            width: double.infinity,
            height: 180.h,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: TextField(
              controller: _queryController,
              maxLines: null,
              expands: true,
              keyboardType: TextInputType.multiline,
              style: textTheme.bodySmall!.copyWith(
                fontSize: 13.sp,
                height: 1.5,
                fontFamily: 'monospace',
                color: provider.isDark ? AppTheme.white : AppTheme.black,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Write your SQL query here...',
              ),
            ),
          ),

          SizedBox(height: 16.h),

          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton.icon(
              onPressed: () {
   final query = _queryController.text.trim();
                if (query.isEmpty) {
                  UiUtils.showErrorMessage(context, "Please write a query first");
                  return;
                }
                
                final user = context.read<UserProvider>().currentUser;
                if (user != null) {
                  context.read<QueryCubit>().executeQuery(query, widget.project.id!);
                } else {
                  UiUtils.showErrorMessage(context, "User not authenticated");
                }
              },
              icon: Icon(Icons.play_arrow, size: 18.sp),
              label: Text('Execute Query', style: TextStyle(fontSize: 14.sp)),
            ),
          ),
        ],
      ),
    );
 
 
 
 
  }
}
