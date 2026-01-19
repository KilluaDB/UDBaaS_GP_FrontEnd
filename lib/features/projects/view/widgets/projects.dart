import 'package:dbaas_project/features/projects/data/models/project_model.dart';
import 'package:dbaas_project/features/projects/view/widgets/project_view.dart';
import 'package:flutter/material.dart';

class Projects extends StatelessWidget {
  List<ProjectModel> projects;
  Projects({super.key, required this.projects});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: GridView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 313 / 200,
          ),
          itemCount: projects.length,
          itemBuilder: (_, index) {
            return Project(project: projects[index], index: index);
          },
        ),
      ),
    );
  }
}
