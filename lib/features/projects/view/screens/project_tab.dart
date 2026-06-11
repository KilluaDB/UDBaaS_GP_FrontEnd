import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/helper/searching_project.dart';
import 'package:dbaas_project/core/util/ui_utils.dart';

import 'package:dbaas_project/features/projects/view_model/project_cubit.dart';
import 'package:dbaas_project/features/projects/view_model/project_states.dart';

import 'package:dbaas_project/features/backup/view_model/backup_cubit.dart';
import 'package:dbaas_project/features/backup/view_model/backup_states.dart';

import 'package:dbaas_project/core/widgets/custome_elevated_button.dart';
import 'package:dbaas_project/features/projects/view/screens/no_projects_screen.dart';
import 'package:dbaas_project/features/projects/view/screens/create_project_screen.dart';
import 'package:dbaas_project/features/projects/view/widgets/projects.dart';

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
  String searchQuery = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectCubit>().getAllProject(isSilentRefresh: true);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SettingsProvider>(context);
    final textTheme = Theme.of(context).textTheme;
    final local = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth * 0.12;

    return MultiBlocListener(
      listeners: [

        // ================= PROJECT =================
        BlocListener<ProjectCubit, ProjectStates>(
          listener: (context, state) {
            if (state is GetAllProjectsLoading
              ) {
              UiUtils.showLoading(context);
            } else {
              UiUtils.hideLoading();
            }

            if (state is DeleteProjectSuccess) {
              UiUtils.showSuccessMessage(
                context,
                "Project deleted successfully!",
              );
              context.read<ProjectCubit>().getAllProject(isSilentRefresh: true);
            }

            if (state is GetAllProjectsError) {
              UiUtils.showErrorMessage(context, state.message);
            }

            if (state is DeleteProjectError) {
              UiUtils.showErrorMessage(context, state.message);
            }
          },
        ),

        // ================= BACKUP =================
        BlocListener<BackupCubit, BackupState>(
          listener: (context, state) {
            if (state is ExportBackupLoading ||
                state is ImportBackupLoading) {
              UiUtils.showLoading(context);
            } else {
              UiUtils.hideLoading();
            }

            if (state is ExportBackupSuccess) {
              UiUtils.showSuccessMessage(
                context,
                "Export completed ",
              );
            }

            if (state is ExportBackupError) {
              UiUtils.showErrorMessage(context, state.message);
            }

            if (state is ImportBackupSuccess) {
              UiUtils.showSuccessMessage(
                context,
                "Import completed ",
              );

              // 🔥 refresh projects after import
              context.read<ProjectCubit>().getAllProject(isSilentRefresh: true);
            }

            if (state is ImportBackupError) {
              UiUtils.showErrorMessage(context, state.message);
            }
          },
        ),
      ],

      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
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
                style: textTheme.titleMedium,
              ),

              SizedBox(height: 32.h),

              // ================= SEARCH + CREATE =================
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 600;

                  final searchField = SizedBox(
                    width: isWide ? 448.w : double.infinity,
                    height: 36,
                    child: TextField(
                      controller: searchController,
                      onChanged: (v) => setState(() => searchQuery = v),
                      decoration: const InputDecoration(
                        hintText: "Search project",
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  );

                  final createButton = CustomElevatedButton(
                    width: isWide ? buttonWidth.clamp(150, 250) : double.infinity,
                    child: Text(
                      local.newProject,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () async {
                      await Navigator.pushNamed(
                        context,
                        CreateProjectPage.routeName,
                      );

                      if (context.mounted) {
                        context.read<ProjectCubit>().getAllProject(isSilentRefresh: true);
                      }
                    },
                  );

                  return isWide
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            searchField,
                            SizedBox(width: 12.w),
                            createButton,
                          ],
                        )
                      : Column(
                          children: [
                            searchField,
                            SizedBox(height: 16.h),
                            createButton,
                          ],
                        );
                },
              ),

              SizedBox(height: 24.h),

              // ================= PROJECT LIST =================
              BlocBuilder<ProjectCubit, ProjectStates>(
                builder: (context, state) {
                  if (state is GetAllProjectsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

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

                  if (state is GetAllProjectsError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}