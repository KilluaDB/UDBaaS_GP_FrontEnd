import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/widgets/custome_elevated_button.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class InputSection extends StatelessWidget {
  const InputSection({super.key});

  @override
  Widget build(BuildContext context) {
    SettingsProvider settings = Provider.of<SettingsProvider>(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        border: BoxBorder.all(width: 0.5, color: AppTheme.boldGray),
        borderRadius: BorderRadius.circular(14),
        color: settings.isDark ? AppTheme.black : AppTheme.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(
                Icons.file_upload_outlined,
                color: AppTheme.primary,
                size: 20,
              ),
              SizedBox(width: 8.w),
              Text(
                "Input Method",
                style: textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                  color: settings.isDark ? AppTheme.white : AppTheme.black,
                ),
              ),
            ],
          ),
          SizedBox(height:14.h),

          Row(
            children: [
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.file_present_outlined,
                        color: AppTheme.white,
                        size: 16,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'File Upload',
                        style: textTheme.titleSmall!.copyWith(
                          color: AppTheme.white,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {},
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: settings.isDark
                        ? AppTheme.black
                        : AppTheme.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.face_retouching_natural_sharp,
                        color: AppTheme.black,
                        size: 16,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'NLP Chat',
                        style: textTheme.titleSmall!.copyWith(
                          color: settings.isDark
                              ? AppTheme.white
                              : AppTheme.black,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Icon(Icons.file_upload_outlined, size: 32, color: AppTheme.gray),
          SizedBox(height: 8.h),
          Text(
            "Drag and drop JSON or CSV files",
            style: textTheme.titleSmall!.copyWith(
              color: settings.isDark ? AppTheme.white : AppTheme.black,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              backgroundColor: settings.isDark
                  ? AppTheme.black
                  : AppTheme.white,
            ),
            child: Text(
              'Choose Files',
              style: textTheme.titleSmall!.copyWith(
                color: settings.isDark ? AppTheme.white : AppTheme.black,
              ),
            ),
            onPressed: () {},
          ),
          SizedBox(height: 16.h),
          CustomElevatedButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.generating_tokens_outlined,
                  color: AppTheme.white,
                  size: 16,
                ),
                SizedBox(width: 4.w),
                Text(
                  'Generate Schema',
                  style: textTheme.titleSmall!.copyWith(color: AppTheme.white),
                ),
              ],
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
