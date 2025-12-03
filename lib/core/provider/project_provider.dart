import 'package:dbaas_project/core/models/project_model.dart';
import 'package:flutter/material.dart';

class ProjectProvider with ChangeNotifier {
  List<ProjectModel> _projects = [];

  List<ProjectModel> get projects => _projects;

  void addProject(ProjectModel project) {
    _projects.add(project);
    notifyListeners();
  }

  void deleteProject(int index) {
    _projects.removeAt(index);
    notifyListeners();
  }
}
