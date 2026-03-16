import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/constants/app_images.dart';
import 'package:dbaas_project/features/projects/view_model/project_cubit.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:dbaas_project/core/widgets/custome_elevated_button.dart';
import 'package:dbaas_project/features/projects/view/screens/create_project_screen.dart';
import 'package:dbaas_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class EmptyProjects extends StatefulWidget {



  @override
  State<EmptyProjects> createState() => _EmptyProjectsState();
}

class _EmptyProjectsState extends State<EmptyProjects> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    SettingsProvider provider = Provider.of<SettingsProvider>(context);

    final buttonWidth = screenWidth * 0.2;

    return Center(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.05),
        margin: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.03,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: provider.isDark
                ? AppTheme.white
                : AppTheme.black.withValues(alpha: 0.1),
          ),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(   AppImages.emptyProjectsLogo, fit: BoxFit.contain),
            SizedBox(height: 16.h),
            Text(
               local.noProjectsYet,
              style: textTheme.titleLarge!.copyWith(
                color: provider.isDark ? AppTheme.white : null,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
                local.createOneToGetStarted,
              style: textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            CustomElevatedButton(
              width: buttonWidth.clamp(150, 250),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 16, color: AppTheme.white),
                  SizedBox(width: 8.w),
                  Text(
                    local.newProject,
                    style: textTheme.titleSmall!.copyWith(
                      color: AppTheme.white,
                    ),
                  ),
                ],
              ),
      onTap: () async {

  final result = await Navigator.of(context).pushNamed(CreateProjectPage.routeName);
  
  if (context.mounted) {
     context.read<ProjectCubit>().getAllProject();
  }
},
            ),
          ],
        ),
      ),
    );
  }
}
