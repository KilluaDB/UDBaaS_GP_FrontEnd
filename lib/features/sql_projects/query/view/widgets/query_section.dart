import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/util/ui_utils.dart';
import 'package:dbaas_project/features/projects/data/models/project_model.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:dbaas_project/features/settings/viewModel/user_provider.dart';
import 'package:dbaas_project/features/sql_projects/query/view_model/query_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class QueryPart extends StatefulWidget {
  final ProjectModel project; 
  const QueryPart({super.key, required this.project});

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
    final provider = Provider.of<SettingsProvider>(context);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: provider.isDark ? AppTheme.black : AppTheme.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          width: 1.w,
          color: provider.isDark
              ? Colors.white24
              : AppTheme.backgroundColor.withOpacity(0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.code, size: 24.sp, color: AppTheme.primary),
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
              color: provider.isDark ? Colors.grey[400] : Colors.grey[700],
            ),
          ),
          SizedBox(height: 16.h),

          // Editor Container
          Container(
            width: double.infinity,
            height: 150.h, 
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: provider.isDark ? Colors.grey[900] : Colors.grey[50],
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: provider.isDark ? Colors.white10 : Colors.black12,
              ),
            ),
            child: TextField(
              controller: _queryController,
              maxLines: null,
              expands: true,
              keyboardType: TextInputType.multiline,
              style: TextStyle(
                fontSize: 13.sp,
                fontFamily: 'monospace',
                color: provider.isDark ? AppTheme.white : AppTheme.black,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'SELECT * FROM customers...',
              ),
            ),
          ),

          SizedBox(height: 16.h),

          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: () {
                final query = _queryController.text.trim();

                if (query.isEmpty) {
                  UiUtils.showErrorMessage(
                    context,
                    "Please write a query first",
                  );
                  return;
                }

               
                if (widget.project.id == null) {
                  UiUtils.showErrorMessage(context, "Project ID is missing!");
                  return;
                }

              
                final userProvider = context.read<UserProvider>();
                if (userProvider.currentUser != null) {
                  print("Project ID: ${widget.project.id}");
                  context.read<QueryCubit>().executeQuery(
                    query,
                    widget.project.id!,
                  );
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
