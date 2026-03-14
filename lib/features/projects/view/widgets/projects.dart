import 'package:dbaas_project/core/util/ui_utils.dart';
import 'package:dbaas_project/features/projects/data/models/project_model.dart';
import 'package:dbaas_project/features/projects/view/widgets/project_view.dart';
import 'package:dbaas_project/features/projects/view_model/project_cubit.dart';
import 'package:dbaas_project/features/projects/view_model/project_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Projects extends StatelessWidget {
  final List<ProjectModel> projects;

  const Projects({super.key, required this.projects});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProjectCubit, ProjectStates>(
      listener: (context, state) {
        if (state is DeleteProjectLoading) {
          UiUtils.showLoading(context);
        }

        if (state is DeleteProjectSuccess) {
          UiUtils.hideLoading();
          UiUtils.showSuccessMessage(context, "Project deleted successfully!");
          
         
          context.read<ProjectCubit>().getAllProject();
        }

        if (state is DeleteProjectError) {
          UiUtils.hideLoading();
          UiUtils.showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {

        List<ProjectModel> displayList = projects;
        
        if (state is GetAllProjectsSuccess) {
          displayList = state.getProjectSuccessResponse.data ?? [];
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 313 / 200,
          ),
          itemCount: displayList.length, 
          itemBuilder: (context, index) {
            final project = displayList[index];
            return ProjectView(
              project: project,
              onDelete: () {
                if (project.id != null) {
                  context.read<ProjectCubit>().deleteProject(project.id!);
                }
              },
            );
          },
        );
      },
    );
  }
}