import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/constants/app_images.dart';
import 'package:dbaas_project/core/widgets/custome_elevated_button.dart';
import 'package:dbaas_project/core/widgets/empty_projects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProjectTab extends StatelessWidget {
  static const String routeName = '/projects';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth * 0.12;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.all(32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Projects',
            style: textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8.h),
          Text(
            'Manage your database projects',
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
                          hintText: 'Search projects',
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
                            "New Project",
                            style: textTheme.titleSmall!.copyWith(color: AppTheme.white),
                          ),
                        ],
                      ),
                      onTap: () {},
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
                          hintText: 'Search projects',
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
                            "New Project",
                            style: textTheme.titleSmall!.copyWith(color: AppTheme.white),
                          ),
                        ],
                      ),
                      onTap: () {},
                    ),
                  ],
                );
              }
            },
          ),

 

          EmptyProjects(
            subTitle: "No projects yet",
            subDecribtion: "Create a project to get started",
            logoName: AppImages.emptyProjectsLogo,
          ),
        ],
      ),
    );
  }
}
