import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/models/project_model.dart';
import 'package:dbaas_project/core/provider/project_provider.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:dbaas_project/features/projects/noSql_projects/screens/main_screen_noSql.dart';
import 'package:dbaas_project/features/projects/sql_projects/screens/main_screen_sql.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class Project extends StatelessWidget {
  ProjectModel project;
  int index;
  Project({required this.project, required this.index});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    ProjectProvider projectProvider = Provider.of<ProjectProvider>(context);

    final horizontalPadding = screenWidth * 0.02;
    final verticalPadding = screenHeight * 0.02;

    return InkWell(
      onTap: () {
        if (project.DBType == 'SQL') {
          Navigator.pushNamed(
            context,
            MainScreenSQL.routeName,
            arguments: project,
          );
        } else {
          Navigator.pushNamed(
            context,
            MainScreenNOSQL.routeName,
            arguments: project,
          );
        }
      },
      child: Container(
        width: screenWidth * 313 / screenWidth,

        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        margin: EdgeInsets.only(top: verticalPadding),

        decoration: BoxDecoration(
          color: settingsProvider.isDark ? AppTheme.black : AppTheme.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            width: 1,
            color: settingsProvider.isDark
                ? AppTheme.white
                : AppTheme.black.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            SvgPicture.asset('assets/images/icons/logo.svg'),
            SizedBox(height: 12.h),
            Text(
              project.name,
              style: textTheme.titleMedium!.copyWith(
                color: settingsProvider.isDark
                    ? AppTheme.white
                    : AppTheme.black,
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Container(
                  width: 56,
                  height: 30,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    project.DBType,
                    style: textTheme.titleMedium!.copyWith(
                      fontSize: 12,
                      color: AppTheme.backgroundColor,
                    ),
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    projectProvider.deleteProject(index);
                  },
                  icon: Icon(
                    Icons.delete_forever_rounded,
                    color: AppTheme.red,
                    size: 25,
                  ),
                ),
              ],
            ),

            SizedBox(height: 4.h),
            Text(project.providerType, style: textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
