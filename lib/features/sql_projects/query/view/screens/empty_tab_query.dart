import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/constants/app_images.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:dbaas_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class EmptyTabQuery extends StatelessWidget {
  const EmptyTabQuery({super.key});

  @override
  Widget build(BuildContext context) {
        AppLocalizations local = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final SettingsProvider provider = Provider.of<SettingsProvider>(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 0.08.sw, vertical: 0.06.sh),
      margin: EdgeInsets.symmetric(horizontal: 0.04.sw, vertical: 0.03.sh),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          width: 1.w,
          color: provider.isDark
              ? AppTheme.white
              : AppTheme.backgroundColor.withOpacity(0.1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(AppImages.codeLogo, width: 80.w, height: 90.h),
          SizedBox(height: 16.h),
          Text(
          local.noTablesAvailable ,
            style: textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
              color: provider.isDark ? AppTheme.white : AppTheme.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          Text(
            'Create tables first to start writing and executing queries',
            style: textTheme.titleSmall!.copyWith(fontSize: 14.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info_outline, size: 14.sp, color: AppTheme.boldGray),
              SizedBox(width: 4.w),
              Flexible(
                child: Text(
                  'Navigate to "Database" tab to add tables or use "Schema Generator"',
                  style: textTheme.titleSmall!.copyWith(
                    color: AppTheme.boldGray,
                    fontSize: 12.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
