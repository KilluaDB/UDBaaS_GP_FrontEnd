import 'package:dbaas_project/core/constants/app_images.dart';
import 'package:dbaas_project/core/widgets/empty_projects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CloudTab extends StatelessWidget {
  static const String routeName = '/cloudProjects';

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cloud Management',
            style: textTheme.headlineLarge!.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 8.h,),
          Text(
            'Manage your cloud resources and deployments',
            style: textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500),
            textAlign: TextAlign.left,
          ),
           SizedBox(height: 32.h,),
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
          EmptyProjects(subTitle: "No cloud projects yet",subDecribtion: "Create a project to get started",logoName: AppImages.cloudEmptyProjectsLogo,),
        ],
      ),
    );
  }
}
