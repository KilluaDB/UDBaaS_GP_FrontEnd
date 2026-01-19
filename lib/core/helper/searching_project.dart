import 'package:dbaas_project/features/projects/data/models/project_model.dart';

class SearchingProject {
  static   List<ProjectModel> filterProjects(List<ProjectModel> projects,String searchQuery) {
    if (searchQuery.isEmpty) return projects;
    return projects
        .where((p) =>
            p.name!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }
}
