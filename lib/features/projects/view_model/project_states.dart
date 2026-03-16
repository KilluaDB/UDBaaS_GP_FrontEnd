import 'package:dbaas_project/features/projects/data/models/delete_project_response.dart';
import 'package:dbaas_project/features/projects/data/models/get_projects_response.dart';
import 'package:dbaas_project/features/projects/data/models/project_create_response.dart';

abstract class ProjectStates {}
class ProjectInit extends ProjectStates {}



class CreateProjectLoading extends ProjectStates {}

class CreateProjectSuccess extends ProjectStates {
  final ProjectCreateResponse createProjectSuccessResponse;

  CreateProjectSuccess(this.createProjectSuccessResponse);
}

class CreateProjectError extends ProjectStates {
  final String message;

  CreateProjectError(this.message);
}

class GetProjectLoading extends ProjectStates {}

class GetProjectSuccess extends ProjectStates {
  final ProjectCreateResponse getProjectSuccessResponse;

  GetProjectSuccess(this.getProjectSuccessResponse);
}

class GetProjectError extends ProjectStates {
  final String message;

  GetProjectError(this.message);
}
class DeleteProjectLoading extends ProjectStates {}

class DeleteProjectSuccess extends ProjectStates {
  final DeleteProjectResponse deleteProjectResponse;

  DeleteProjectSuccess(this.deleteProjectResponse);
}

class DeleteProjectError extends ProjectStates {
  final String message;

  DeleteProjectError(this.message);
}


class GetAllProjectsLoading extends ProjectStates {}

class GetAllProjectsSuccess extends ProjectStates {
  final GetProjectsResponse getProjectSuccessResponse;

  GetAllProjectsSuccess(this.getProjectSuccessResponse);
}

class GetAllProjectsError extends ProjectStates {
  final String message;

  GetAllProjectsError(this.message);
}
