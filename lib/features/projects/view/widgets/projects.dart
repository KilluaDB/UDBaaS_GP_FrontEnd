import 'package:dbaas_project/features/backup/view_model/backup_cubit.dart';
import 'package:dbaas_project/features/projects/data/models/project_model.dart';
import 'package:dbaas_project/features/projects/view/widgets/project_view.dart';
import 'package:dbaas_project/features/projects/view_model/project_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Projects extends StatelessWidget {
  final List<ProjectModel> projects;

  const Projects({super.key, required this.projects});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,

        childAspectRatio: 363 / 210,
      ),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        return ProjectView(
          project: projects[index],
          onDelete: () {
            if (projects[index].id != null) {
              context.read<ProjectCubit>().deleteProject(projects[index].id!);
            }
          },
          onExport: () {
            if (projects[index].id != null) {
              context.read<BackupCubit>().exportProject(projectId:  projects[index].id!);
            }
          },
       onImport: () async {
  await context.read<BackupCubit>().importProjectFromPicker(
    projectId: projects[index].id!,
  );
}
        );
      },
    );
  }
}
