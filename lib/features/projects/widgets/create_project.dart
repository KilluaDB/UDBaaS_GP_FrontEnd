import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/constants/app_images.dart';
import 'package:dbaas_project/core/models/project_model.dart';
import 'package:dbaas_project/core/provider/settings_provider.dart';
import 'package:dbaas_project/core/widgets/custome_elevated_button.dart';
import 'package:dbaas_project/features/projects/widgets/input_section.dart';
import 'package:dbaas_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class CreateProjectSection extends StatefulWidget {
  @override
  State<CreateProjectSection> createState() => _CreateProjectSectionState();
}

class _CreateProjectSectionState extends State<CreateProjectSection> {
  bool isFormValid = false; 

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final AppLocalizations local = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    SettingsProvider provider = Provider.of<SettingsProvider>(context);

    final horizontalPadding = screenWidth * 0.02;
    final verticalPadding = screenHeight * 0.03;

    return Container(
      width: screenWidth * 0.4,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
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
          Row(
            children: [
              SvgPicture.asset(
                AppImages.projectSelected,
                width: 32.w,
                height: 32.h,
                fit: BoxFit.fill,
              ),
              SizedBox(width: 12.h),
              Text(local.createNewProject, style: textTheme.headlineLarge),
            ],
          ),
          SizedBox(height: 8.h),
          Text(local.setUpDatabaseProject, style: textTheme.titleMedium),

          InputSection(
            onFormChanged: (valid) {
              setState(() {
                isFormValid = valid;
              });
            },
          ),


        ],
      ),
    );
  }
}
