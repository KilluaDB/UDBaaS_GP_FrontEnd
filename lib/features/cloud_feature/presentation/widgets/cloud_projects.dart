import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/constants/app_images.dart';
import 'package:dbaas_project/core/provider/project_provider.dart';
import 'package:dbaas_project/core/provider/settings_provider.dart';
import 'package:dbaas_project/features/projects/widgets/project_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class CloudProjects extends StatelessWidget {
  const CloudProjects({super.key});

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    final textTheme = Theme.of(context).textTheme;
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    final cloudTypes = ["AWS", "Firebase", "Supabase", "Mongo Atlas"];

    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: cloudTypes.map((type) {
            final projectsOfType = projectProvider.projects
                .where((p) => p.providerType == type)
                .toList();

            if (projectsOfType.isEmpty) return SizedBox.shrink();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.h),
                Row(
                  children: [
                    SvgPicture.asset(
                      AppImages.cloudLogo,
                      fit: BoxFit.fill,
                      height: 40.h,
                      width: 40.w,
                    ),
                    SizedBox(width: 12.w),
                    Column(
                      children: [
                        Text("$type", style:          textTheme.titleLarge!.copyWith(
                      color: settingsProvider.isDark ? AppTheme.white : AppTheme.black,
                      fontWeight: FontWeight.bold,
                    ),),
                        Text(
                          "${projectsOfType.length} Projects",
                          style: textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                GridView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 16.h,
                    crossAxisSpacing: 16.w,
                    childAspectRatio: 313 / 210,
                  ),
                  itemCount: projectsOfType.length,
                  itemBuilder: (_, index) {
                    return Project(
                      project: projectsOfType[index],
                      index: projectProvider.projects.indexOf(
                        projectsOfType[index],
                      ),
                    );
                  },
                ),

                SizedBox(height: 32.h),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
