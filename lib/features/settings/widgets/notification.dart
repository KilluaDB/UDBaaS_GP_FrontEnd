import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/constants/app_images.dart';
import 'package:dbaas_project/core/provider/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class NotificationSection extends StatelessWidget {
  late SettingsProvider provider;
  @override
  Widget build(BuildContext context) {
  provider = Provider.of<SettingsProvider>(context);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 0.04.sw, vertical: 0.03.sh),
      margin: EdgeInsets.symmetric(horizontal: 0.04.sw, vertical: 0.03.sh),
      decoration: BoxDecoration(
          color:  provider.isDark
                  ? AppTheme.black.withOpacity(0.1)
                  : AppTheme.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          width: 1,
          color: provider.isDark
              ? AppTheme.white
              : AppTheme.black.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                AppImages.notificationLogo,
                width: 30.r,
                height: 30.r,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  'Notifications',
                  style: textTheme.titleMedium!.copyWith(
                color: provider.isDark ? AppTheme.white : AppTheme.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Text(
            "Choose what notifications you want to receive",
            style: textTheme.titleMedium,
          ),
          SizedBox(height: 24.h),

          _buildNotificationRow(
            context,
            'Email Notifications',
            'Receive notifications via email',
            provider.emailNotifications,
            (val) => provider.setEmailNotifications(val),
          ),
          _buildNotificationRow(
            context,
            'Push Notifications',
            'Get notified when you create or edit tables, schemas, and queries',
            provider.pushNotifications,
            (val) => provider.setPushNotifications(val),
          ),
          Divider(height: 1.h),
          SizedBox(height: 24.h),
          _buildNotificationRow(
            context,
            'Query Alerts',
            'Alert on long-running queries',
            provider.queryAlerts,
            (val) => provider.setQueryAlerts(val),
          ),
          _buildNotificationRow(
            context,
            'Schema Changes',
            'Notify on database schema modifications',
            provider.schemaChanges,
            (val) => provider.setSchemaChanges(val),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationRow(
    BuildContext context,
    String title,
    String subTitle,
    bool value,
    Function(bool) onChanged,
  ) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: provider.isDark ? AppTheme.white : AppTheme.black,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subTitle,
                  style: textTheme.titleMedium!.copyWith(fontSize: 14.sp),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Switch(
            value: value,
            onChanged: (newValue) => onChanged(newValue),
            thumbColor: MaterialStateProperty.all(AppTheme.white),

            activeTrackColor: AppTheme.primary,
            inactiveTrackColor: AppTheme.boldGray!.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }
}
