import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/helper/searching_project.dart';
import 'package:dbaas_project/core/util/ui_utils.dart';
import 'package:dbaas_project/features/projects/view_model/project_cubit.dart';
import 'package:dbaas_project/features/projects/view/screens/no_projects_screen.dart';
import 'package:dbaas_project/features/cloud/presentation/widgets/cloud_projects.dart';
import 'package:dbaas_project/features/projects/view_model/project_states.dart';
import 'package:dbaas_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CloudTab extends StatefulWidget {
  static const String routeName = '/cloudProjects';

  const CloudTab({super.key});

  @override
  State<CloudTab> createState() => _CloudTabState();
}

class _CloudTabState extends State<CloudTab> {
   int selectedIndex = 0;
  String searchQuery = "";
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final local = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final contentWidth = width >= 1200
            ? width * 0.85
            : width >= 800
            ? width * 0.95
            : width;

        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: SizedBox(
              width: contentWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    local.cloudManagement,
                    style: textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    local.manageCloudResources,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: width >= 800 ? 420 : double.infinity,
                    height: 40,
                    child:  TextField(
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
                  ),

                  const SizedBox(height: 24),

                  Expanded(
                    child: BlocBuilder<ProjectCubit, ProjectStates>(
                      builder: (context, state) {
                        if (state is GetAllProjectsLoading) {
                         UiUtils.showLoading(context);
                        }

                        if (state is GetAllProjectsError) {
                          return Center(child: Text(state.message,      style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppTheme.red
                    ),));
                        }

                        if (state is GetAllProjectsSuccess) {
    final projects =SearchingProject. filterProjects(state.getProjectSuccessResponse.data ?? [],searchQuery);
      
      if (  projects.isEmpty) {
        return  EmptyProjects();
      }
      

                          return CloudProjects(projects: projects);
                        }

                        return const SizedBox();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
