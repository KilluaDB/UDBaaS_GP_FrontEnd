import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/features/projects/data/models/project_model.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:dbaas_project/features/no_sql_projects/view/screens/main_screen_noSql.dart';
import 'package:dbaas_project/features/sql_projects/main_screen_sql.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
class ProjectView extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onDelete;

  const ProjectView({
    super.key,
    required this.project,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    final horizontalPadding = screenWidth * 0.02;
    final verticalPadding = screenHeight * 0.02;

    return InkWell(
      onTap: () {
        if (project.dbType!.toUpperCase() == 'SQL') {
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
              project.name!,
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
                  width: 56.w,
                  height: 50.h,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    project.dbType!,
                    style: textTheme.titleMedium!.copyWith(
                      fontSize: 12,
                      color: AppTheme.backgroundColor,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_forever_rounded,
                    color: AppTheme.red,
                    size: 25,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(project.resourceTier!, style: textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
