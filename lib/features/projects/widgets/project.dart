import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/models/project_model.dart';
import 'package:dbaas_project/core/provider/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class Project extends StatelessWidget {
  ProjectModel project;
  Project({required this.project});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    SettingsProvider provider = Provider.of<SettingsProvider>(context);

    final horizontalPadding = screenWidth * 0.02;
    final verticalPadding = screenHeight * 0.02;

    return Container(
      width: screenWidth * 313 / screenWidth,

      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      margin: EdgeInsets.only(top: verticalPadding),

      decoration: BoxDecoration(
        color: provider.isDark ? AppTheme.black : AppTheme.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          width: 1,
          color: provider.isDark
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
              color: provider.isDark ? AppTheme.white : AppTheme.black,
            ),
          ),
          SizedBox(height: 4.h),
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
          SizedBox(height: 4.h),
          Text(project.providerType, style: textTheme.titleMedium),
        ],
      ),
    );
  }
}
