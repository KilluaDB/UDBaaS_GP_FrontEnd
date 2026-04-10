import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/features/projects/data/models/project_model.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:dbaas_project/features/sql_projects/query/view/screens/empty_tab_query.dart';
import 'package:dbaas_project/features/sql_projects/query/view/screens/full_query_tab.dart';
import 'package:dbaas_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class QueryEditor extends StatefulWidget {
    ProjectModel project;
   QueryEditor({required this.project});
  @override
  State<QueryEditor> createState() => _QueryEditorState();
}

class _QueryEditorState extends State<QueryEditor> {
  bool isEmpty = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final SettingsProvider provider = Provider.of<SettingsProvider>(context);
 AppLocalizations local = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 0.05.sw),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            local.sqlEditor,
            style: textTheme.headlineSmall!.copyWith(
              color: provider.isDark ? AppTheme.white : AppTheme.black,
              fontWeight: FontWeight.bold,
              fontSize: 22.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Write and execute database queries',
            style: textTheme.titleMedium!.copyWith(fontSize: 16.sp, color: provider.isDark ? AppTheme.white : AppTheme.black,),
          ),
          SizedBox(height: 24.h),
          Expanded(child: isEmpty ? EmptyTabQuery() : FullQueryTab(project: widget.project,)),
        ],
      ),
    );
  }
}
