import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/helper/searching_project.dart';
import 'package:dbaas_project/core/util/ui_utils.dart';
import 'package:dbaas_project/features/projects/view_model/project_cubit.dart';
import 'package:dbaas_project/core/widgets/custome_elevated_button.dart';
import 'package:dbaas_project/features/projects/view/screens/no_projects_screen.dart';
import 'package:dbaas_project/features/projects/view/screens/create_project_screen.dart';
import 'package:dbaas_project/features/projects/view/widgets/projects.dart';
import 'package:dbaas_project/features/projects/view_model/project_states.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_provider.dart';
import 'package:dbaas_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProjectTab extends StatefulWidget {
  static const String routeName = '/projects';

  @override
  State<ProjectTab> createState() => _ProjectTabState();
}

class _ProjectTabState extends State<ProjectTab> {
 int selectedIndex = 0;
  String searchQuery = "";
  TextEditingController searchController = TextEditingController();
@override
void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<ProjectCubit>().getAllProject();
  });
}
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
     SettingsProvider provider = Provider.of<SettingsProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth * 0.12;
    final textTheme = Theme.of(context).textTheme;
    AppLocalizations local = AppLocalizations.of(context)!;

      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                  bool isWide = constraints.maxWidth > 600; 
        
                  if (isWide) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                  SizedBox(
          width: 448.w,
          height: 36,
          child: TextField(
            controller: searchController,
                style:TextStyle(color:  provider.isDark?AppTheme.white:AppTheme.black),
            decoration: InputDecoration(
        hintText: local.searchForProject,
        prefixIcon: const Icon(Icons.search),
            ),
            onChanged: (value) {
        setState(() {
          searchQuery = value;
        });
            },
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
                          onTap: () async{
                          await  Navigator.of(
                              context,
                            ).pushNamed(CreateProjectPage.routeName);
                            if (context.mounted) {
            context.read<ProjectCubit>().getAllProject(); 
          }
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
          controller: searchController, 
          onChanged: (value) {         
            setState(() {
        searchQuery = value;
            });
          },
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
                          onTap: () async {
                            await Navigator.of(
                              context,
                            ).pushNamed(CreateProjectPage.routeName);
                            if (context.mounted) {
            context.read<ProjectCubit>().getAllProject(); 
          }
                          },
                        ),
                      ],
                    );
                  }
                },
              ),
              SizedBox(height: 24.h),
        BlocConsumer<ProjectCubit, ProjectStates>(
          listener: (context, state) {
            if (state is GetAllProjectsLoading || state is DeleteProjectLoading) {
        UiUtils.showLoading(context);
            } else {
        UiUtils.hideLoading();
            }
        
            if (state is DeleteProjectSuccess) {
        UiUtils.showSuccessMessage(context, "Project deleted successfully!");
        context.read<ProjectCubit>().getAllProject();
            }
        
            if (state is GetAllProjectsError) {
        UiUtils.showErrorMessage(context, state.message);
            }
        
            if (state is DeleteProjectError) {
        UiUtils.showErrorMessage(context, state.message);
            }
          },
         
         
          builder: (context, state) {
            if (state is GetAllProjectsSuccess) {
        final projects = SearchingProject.filterProjects(
          state.getProjectSuccessResponse.data ?? [],
          searchQuery,
        );
        
        if (projects.isEmpty) {
          return EmptyProjects();
        }
        
        return Projects(projects: projects);
            }
  
        
            return const SizedBox();
          },
        )     
             
             
            ],
          ),
        ),
      );
  }
}