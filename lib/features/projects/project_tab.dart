import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/constants/app_images.dart';
import 'package:dbaas_project/core/models/project_model.dart';
import 'package:dbaas_project/core/provider/project_provider.dart';
import 'package:dbaas_project/core/widgets/custome_elevated_button.dart';
import 'package:dbaas_project/core/widgets/empty_projects.dart';
import 'package:dbaas_project/features/projects/screens/create_project_screen.dart';
import 'package:dbaas_project/features/projects/widgets/project.dart';
import 'package:dbaas_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProjectTab extends StatefulWidget {
  static const String routeName = '/projects';

  @override
  State<ProjectTab> createState() => _ProjectTabState();
}

class _ProjectTabState extends State<ProjectTab> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final buttonWidth = screenWidth * 0.12;
    final textTheme = Theme.of(context).textTheme;
    AppLocalizations local = AppLocalizations.of(context)!;
    final projectProvider = Provider.of<ProjectProvider>(context); 

    final projects = projectProvider.projects;
        return Padding(
      padding: EdgeInsets.all(32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            local.projects,
            style: textTheme.headlineLarge!.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            local.manageProjects,
            style: textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 32.h),

          LayoutBuilder(
            builder: (context, constraints) {
              bool isWide = constraints.maxWidth > 600; // يعتبر Desktop/Tablet

              if (isWide) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 448.w,
                      height: 36,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: local.searchForProject,
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
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
                        onTap: ()  {
                  Navigator.of(
                          context,
                        ).pushNamed(CreateProjectPage.routeName);
                      },
                    ),
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 36,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: local.searchForProject,
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    CustomElevatedButton(
                      width: double.infinity,
                      child: Row(
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
                      onTap: ()  {
                  Navigator.of(
                          context,
                        ).pushNamed(CreateProjectPage.routeName);
                      },
                    ),
                  ],
                );
              }
            },
          ),

projects.isEmpty
              ? EmptyProjects(
                  subTitle: local.noProjectsYet,
                  subDecribtion: local.createOneToGetStarted,
                  logoName: AppImages.emptyProjectsLogo,
                )
              : SizedBox(
                  height: screenHeight*300/screenHeight,
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (_, __) => SizedBox(width: 16),
                    itemBuilder: (_, index) =>
                        Project(project: projects[index],index: index,),
                    itemCount:projects.length,
                  ),
                ),
        ],
      ),
    );
  }
}
