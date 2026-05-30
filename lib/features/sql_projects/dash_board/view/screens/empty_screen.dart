import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/constants/app_images.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SettingsProvider settings = Provider.of<SettingsProvider>(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
   
        children: [
          Text('Dashboard', style: textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 64.h),
          Container(
            height: 325.h,
       
            decoration: BoxDecoration(
              color: settings.isDark
                  ? AppTheme.backgroundColor.withValues(alpha: 0.2)
                  : AppTheme.semiGray,
              borderRadius: BorderRadius.circular(14.r),
              border: BoxBorder.all(color: AppTheme.primary, width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppImages.emptyProjectsLogo,

                  width: 80.w,
                  height: 96.h,
                ),
                SizedBox(height: 16.h),
                Text(
                  'No Database Schema Available',
                  style: textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Create tables or generate a schema to view insights and metrics',
                  style: textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.w400,
                    color: AppTheme.boldGray,
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline, color: AppTheme.boldGray),
                    Text(
                      '  Navigate to "Database" tab to add tables or use "Schema Generator" to create your schema',
                      style: textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: AppTheme.boldGray,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
