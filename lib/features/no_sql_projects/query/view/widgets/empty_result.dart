import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/constants/app_images.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class EmptyResult extends StatelessWidget {
  const EmptyResult({super.key});

  @override
  Widget build(BuildContext context) {
       final provider = Provider.of<SettingsProvider>(context);
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppImages.codeLogo,
                      width: 30.w,
                      height: 30.h,
                      color: provider.isDark ? AppTheme.white : AppTheme.black,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No results to display',
                      style: textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: provider.isDark
                            ? AppTheme.white
                            : AppTheme.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Execute a query to see results here',
                      style: textTheme.titleSmall!.copyWith(
                        fontSize: 12.sp,
                        color: provider.isDark
                            ? AppTheme.white
                            : AppTheme.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24.h),
                  ],
                );
             
  }
}