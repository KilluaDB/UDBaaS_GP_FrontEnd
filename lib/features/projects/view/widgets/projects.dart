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
    return Expanded(
      child: BlocListener<ProjectCubit, ProjectStates>(
        listener: (context, state) {
          if (state is DeleteProjectLoading) {
            UiUtils.showLoading(context);
          }

          if (state is DeleteProjectSuccess) {
            UiUtils.hideLoading(context);
            UiUtils.showSuccessMessage(
              "Project deleted successfully!",
            );

        
            context.read<ProjectCubit>().getAllProject();
          }

          if (state is DeleteProjectError) {
            UiUtils.hideLoading(context);
            UiUtils.showErrorMessage(state.message);
          }
        },
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 313 / 200,
          ),
          itemCount: projects.length,
          itemBuilder: (context, index) {
            return ProjectView(
              project: projects[index],
              onDelete: () {
                context
                    .read<ProjectCubit>()
                    .deleteProject(projects[index].id!);
              },
            );
          },
        ),
      ),
    );
  }
}
