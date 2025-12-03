import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/constants/app_images.dart';
import 'package:dbaas_project/core/models/language_model.dart';
import 'package:dbaas_project/core/provider/settings_provider.dart';
import 'package:dbaas_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class AppearanceSection extends StatefulWidget {
  @override
  State<AppearanceSection> createState() => _AppearanceSectionState();
}

class _AppearanceSectionState extends State<AppearanceSection> {
  @override
  List<LanguageModel> languages = [
    LanguageModel(code: 'ar', name: 'Arabic'),
    LanguageModel(code: 'en', name: 'English'),
  ];
  String? selectedLanguage;
  Widget build(BuildContext context) {
    SettingsProvider provider = Provider.of<SettingsProvider>(context);

    final TextTheme textTheme = Theme.of(context).textTheme;
    final AppLocalizations local = AppLocalizations.of(context)!;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final horizontalPadding = screenWidth * 0.04; // 4% padding
    final verticalPadding = screenHeight * 0.03;
    return Center(
      child: Container(
        width: 1.sw,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        decoration: BoxDecoration(
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                 AppImages.apperance,
                  width: 32.w,
                  height: 32.h,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    local.appearance,
                    style: textTheme.titleMedium!.copyWith(
                      color: provider.isDark ? AppTheme.white : AppTheme.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(local.customizeLookAndFeel, style: textTheme.titleMedium),
            SizedBox(height: 36.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
               AppImages.mode,
                  width: 40.w,
                  height: 40.h,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        local.darkMode,
                        style: textTheme.titleMedium!.copyWith(
                          color: provider.isDark
                              ? AppTheme.white
                              : AppTheme.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        local.switchBetweenThemes,
                        style: textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: provider.isDark,
                  onChanged: (newValue) {
                    provider.changeThemeMode(
                      newValue ? ThemeMode.dark : ThemeMode.light,
                    );
                  },
                  thumbColor: MaterialStateProperty.all(AppTheme.white),
                  trackColor: MaterialStateProperty.all(
                    AppTheme.backgroundColor.withValues(alpha: 0.2),
                  ),
                  activeTrackColor: Colors.blue,
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Divider(
              color: provider.isDark
                  ? AppTheme.white
                  : AppTheme.black.withValues(alpha: 0.1),
              thickness: 1,
            ),
            SizedBox(height: 24.h),
            Text(
              local.themePreview,
              style: textTheme.titleMedium!.copyWith(
                color: provider.isDark ? AppTheme.white : AppTheme.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 18.h),
            Row(
              children: [
                Expanded(
                  child: Image.asset(
                   AppImages.lightMode,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: 24.w),
                Expanded(
                  child: Image.asset(
                      AppImages.darkMode  ,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
            Divider(
              color: provider.isDark
                  ? AppTheme.white
                  : AppTheme.black.withValues(alpha: 0.1),
              thickness: 1,
            ),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    local.yourLanguage,
                    style: textTheme.titleMedium!.copyWith(
                      color: provider.isDark ? AppTheme.white : AppTheme.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                              border: Border.all(
            width: 1,
            color: provider.isDark
                ? AppTheme.white
                : AppTheme.black.withValues(alpha: 0.1),
          ),
                    ),
                    child: DropdownButton(
                     dropdownColor: provider.isDark ? AppTheme.black : AppTheme.white.withValues(alpha: .7),
       
                      isExpanded: true,
                      underline: SizedBox(),
                      iconEnabledColor: AppTheme.backgroundColor,

                      value: provider.languageMode,
                      items: languages
                          .map(
                            (language) => DropdownMenuItem(
                              value: language.code,
                              child: Text(
                                language.name,
                                style: textTheme.titleLarge!.copyWith(
                                color: provider.isDark ? AppTheme.white : AppTheme.black, 
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        provider.changeLanguageMode(value.toString());
                      },
                    ),
                  
                  
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
