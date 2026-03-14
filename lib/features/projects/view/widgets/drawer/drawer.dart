import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/constants/app_images.dart';
import 'package:dbaas_project/core/util/ui_utils.dart';
import 'package:dbaas_project/features/projects/data/models/project_model.dart';
import 'package:dbaas_project/features/home/presentation/widgets/drawer_item.dart';
import 'package:dbaas_project/features/projects/view/widgets/drawer/tabs.dart';
import 'package:dbaas_project/features/projects/view_model/project_cubit.dart';
import 'package:dbaas_project/features/projects/view_model/project_states.dart';
import 'package:dbaas_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ProjectDrawer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  ProjectModel project;

  ProjectDrawer({
    required this.selectedIndex,
    required this.onItemSelected,
    required this.project,
  });

  late final tabs = project.dbType?.toUpperCase() == 'SQL' ? Tabs.sqlTabs : Tabs.noSqlTabs;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    AppLocalizations local = AppLocalizations.of(context)!;
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    size: 20,
                    color: AppTheme.boldGray,
                  ),
                ),
                Text(local.backToProjects, style: textTheme.titleMedium),
              ],
            ),
            Row(
              children: [
                SvgPicture.asset(
                  AppImages.projectSelected,
                  width: 32,
                  height: 32,
                ),
                SizedBox(width: 8),
                Text(
                  project.name!,
                  style: textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Container(
                  width: 56,
                  height: 30,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    project.dbType!,
                    style: textTheme.titleMedium!.copyWith(
                      fontSize: 12,
                      color: AppTheme.backgroundColor,
                    ),
                  ),
                ),
                SizedBox(width: 20.w),
                Text(project.resourceTier!, style: textTheme.titleMedium),
              ],
            ),

            SizedBox(height: 50.h),
            Divider(color: AppTheme.black.withValues(alpha: 0.1), thickness: 1),
            SizedBox(
              child: ListView.builder(
                itemCount: tabs.length - 1,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => onItemSelected(index),
                    child: DrawerItem(
                      name: tabs[index]['name']!,
                      isSelected: selectedIndex == index,
                      selectedImage: tabs[index]['selected']!,
                      unselectedImage: tabs[index]['unselected']!,
                    ),
                  );
                },
              ),
            ),
            Divider(color: AppTheme.black.withValues(alpha: 0.1), thickness: 1),

BlocListener<ProjectCubit, ProjectStates>(
  listener: (context, state) {
    if (state is DeleteProjectLoading) {
      UiUtils.showLoading(context);
    }

    if (state is DeleteProjectSuccess) {
      UiUtils.hideLoading(context);
      UiUtils.showSuccessMessage("Project deleted successfully!");
      Navigator.pop(context); 
      
      context.read<ProjectCubit>().getAllProject();
    }

    if (state is DeleteProjectError) {
      UiUtils.hideLoading(context);
      UiUtils.showErrorMessage(state.message);
    }
  },
  child: InkWell(
    onTap: () {
   
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this project?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx); 
                context.read<ProjectCubit>().deleteProject(project.id!);
              },
              child: Text("Delete"),
            ),
          ],
        ),
      );
    },
    child: DrawerItem(
      name: tabs[tabs.length - 1]['name']!,
      isSelected: selectedIndex == tabs.length,
      selectedImage: tabs[tabs.length - 1]['selected']!,
      unselectedImage: tabs[tabs.length - 1]['unselected']!,
      isDelete: true,
    ),
  ),
),

          ],
        ),
      ),
    );
  }
}
