import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/helper/searching_project.dart';
import 'package:dbaas_project/core/util/ui_utils.dart';
import 'package:dbaas_project/features/projects/view_model/project_cubit.dart';
import 'package:dbaas_project/core/widgets/custome_elevated_button.dart';
import 'package:dbaas_project/features/projects/view/screens/no_projects_screen.dart';
import 'package:dbaas_project/features/projects/view/screens/create_project_screen.dart';
import 'package:dbaas_project/features/projects/view/widgets/projects.dart';
import 'package:dbaas_project/features/projects/view_model/project_states.dart';
import 'package:dbaas_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProjectTab extends StatefulWidget {
  static const String routeName = '/projects';

  @override
  State<ProjectTab> createState() => _ProjectTabState();
}

class _ProjectTabState extends State<ProjectTab> {
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
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth * 0.12;
    final textTheme = Theme.of(context).textTheme;
    AppLocalizations local = AppLocalizations.of(context)!;

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
              bool isWide = constraints.maxWidth > 600;
              
              Widget searchField = SizedBox(
                width: isWide ? 448.w : double.infinity,
                height: 36,
                child: TextField(
                  controller: searchController,
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
              );

              Widget addButton = CustomElevatedButton(
                width: isWide ? buttonWidth.clamp(150, 250) : double.infinity,
                onTap: () async {
                
                  final result = await Navigator.of(context).pushNamed(CreateProjectPage.routeName);
                  
              
                  if (mounted) {
                    context.read<ProjectCubit>().getAllProject();
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 16, color: AppTheme.white),
                    SizedBox(width: 8.w),
                    Text(
                      local.newProject,
                      style: textTheme.titleSmall!.copyWith(color: AppTheme.white),
                    ),
                  ],
                ),
              );

              return isWide 
                ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [searchField, addButton])
                : Column(children: [searchField, SizedBox(height: 16.h), addButton]);
            },
          ),
          
          SizedBox(height: 24.h),

     
          Expanded(
            child: BlocConsumer<ProjectCubit, ProjectStates>(
              listener: (context, state) {
                if (state is GetAllProjectsLoading) {
                  UiUtils.showLoading(context);
                } else {
                  UiUtils.hideLoading();
                }

                if (state is GetAllProjectsError) {
                  UiUtils.showErrorMessage(context, state.message);
                }
              },
              builder: (context, state) {
                if (state is GetAllProjectsSuccess) {
                
                  final allData = state.getProjectSuccessResponse.data ?? [];
                  final projects = SearchingProject.filterProjects(allData, searchQuery);

                  if (projects.isEmpty) {
                    return EmptyProjects();
                  }

                  return Projects(projects: projects);
                }

          
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}