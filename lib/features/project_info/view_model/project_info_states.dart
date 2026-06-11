import 'package:dbaas_project/features/project_info/data/models/project_info_model.dart';

abstract class ProjectAccessState {}

class ProjectAccessInitial extends ProjectAccessState {}

class GetProjectAccessLoading extends ProjectAccessState {}

class GetProjectAccessSuccess extends ProjectAccessState {
  final ProjectAccessModel accessData;

  GetProjectAccessSuccess(this.accessData);
}

class GetProjectAccessError extends ProjectAccessState {
  final String message;

  GetProjectAccessError(this.message);
}