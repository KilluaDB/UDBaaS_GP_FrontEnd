class ProjectModel {
  String name;
  String DBType;
  int id = 1;

  String providerType;
  ProjectModel({
    required this.DBType,
    required this.name,
    required this.providerType,
    this.id = 1,
  });
  static List<ProjectModel> projects = [];
  static void addProjects(ProjectModel project) {
    projects.add(project);
  }
}
