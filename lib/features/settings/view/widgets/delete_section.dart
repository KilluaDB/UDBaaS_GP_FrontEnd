import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/provider/settings_provider.dart';
import 'package:dbaas_project/features/Auth/view/screens/register_screen.dart';
import 'package:dbaas_project/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DeleteSection extends StatelessWidget {
  const DeleteSection({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    SettingsProvider provider = Provider.of<SettingsProvider>(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 0.04.sw, vertical: 0.03.sh),
      margin: EdgeInsets.symmetric(horizontal: 0.04.sw, vertical: 0.03.sh),
      decoration: BoxDecoration(
        color: provider.isDark
            ? AppTheme.black.withOpacity(0.1)
            : AppTheme.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppTheme.red),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Danger Zone',
            style: textTheme.titleMedium!.copyWith(
              color: AppTheme.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 7.h),
          Text(
            'Irreversible and destructive actions',
            style: textTheme.titleMedium,
          ),
          SizedBox(height: 24.h),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 0.02.sw,
              vertical: 0.02.sh,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppTheme.red),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delete Account',
                        style: textTheme.titleMedium!.copyWith(
                          color: AppTheme.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 7.h),
                      Text(
                        'Permanently delete your account and all associated data',
                        style: textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 16.w),

                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.red,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    onPressed: () {
                      //API Delete User
                      Navigator.pushReplacementNamed(
                        context,
                        RegisterScreen.routeName,
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete_rounded, color: AppTheme.white),
                        SizedBox(width: 8.w),
                        Flexible(
                          child: Text(
                            'Delete Account',
                            style: textTheme.titleMedium!.copyWith(
                              color: AppTheme.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
