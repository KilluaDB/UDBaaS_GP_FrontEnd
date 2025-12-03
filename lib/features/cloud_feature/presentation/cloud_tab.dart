import 'package:dbaas_project/core/constants/app_images.dart';
import 'package:dbaas_project/core/provider/project_provider.dart';
import 'package:dbaas_project/core/widgets/empty_projects.dart';
import 'package:dbaas_project/features/cloud_feature/presentation/widgets/cloud_projects.dart';
import 'package:dbaas_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CloudTab extends StatelessWidget {
  static const String routeName = '/cloudProjects';

  @override
  Widget build(BuildContext context) {
        final projectProvider = Provider.of<ProjectProvider>(context); 

    final projects = projectProvider.projects;
    TextTheme textTheme = Theme.of(context).textTheme;
           AppLocalizations local = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            local.cloudManagement,
            style: textTheme.headlineLarge!.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 8.h,),
          Text(
              local.manageCloudResources,
            style: textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500),
            textAlign: TextAlign.left,
          ),
           SizedBox(height: 32.h,),
          SizedBox(
            width: 448.w,
            height: 36,
            child: TextField(
              decoration: InputDecoration(
                hintText:local.searchForProject,
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
    projects.isEmpty
    ? EmptyProjects(
        subTitle: local.noProjectsYet,
        subDecribtion: local.createOneToGetStarted,
        logoName: AppImages.cloudEmptyProjectsLogo,
      )
    : CloudProjects()  ],
      ),
    );
  }
}
