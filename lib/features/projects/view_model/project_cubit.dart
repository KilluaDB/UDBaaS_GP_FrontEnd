import 'package:dbaas_project/features/projects/data/data_source/project_api_service.dart';
import 'package:dbaas_project/features/projects/view_model/project_states.dart';
import 'package:dbaas_project/features/settings/viewModel/user_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectCubit extends Cubit<ProjectStates> {
  final ProjectApiService _dataSource;
  final UserProvider userProvider;

  ProjectCubit({required this.userProvider, ProjectApiService? dataSource})
    : _dataSource = dataSource ?? ProjectApiService(),
      super(ProjectInit());

  Future<void> createProject(
    String name,
    String dbType,
    String password,

  ) async {
     
    emit(CreateProjectLoading());
    try {
      final accessToken = userProvider.currentUser?.data?.accessToken;
      if (accessToken == null || accessToken.isEmpty) {
        emit(CreateProjectError("User not logged in"));
        return;
      }

      final response = await _dataSource.createProject(
        accessToken,
        name,
        dbType,
        password,
      );
         await Future.delayed(const Duration(seconds:1 ));

      emit(CreateProjectSuccess(response));

    } catch (e) {
      emit(CreateProjectError(e.toString()));
    }
  }

  Future<void> getAllProject(    {bool isSilentRefresh = false}) async {
      if (!isSilentRefresh)   emit(GetAllProjectsLoading());
  
    try {
      final accessToken = userProvider.currentUser?.data?.accessToken;
      if (accessToken == null || accessToken.isEmpty) {
        emit(GetAllProjectsError("User not logged in"));
        return;
      }

      final response = await _dataSource.getAllProjects(accessToken);

      emit(GetAllProjectsSuccess(response));
    } catch (e) {
      emit(GetAllProjectsError(e.toString()));
    }
  }

  Future<void> getProject(String projectId) async {
    emit(GetProjectLoading());
    try {
      final accessToken = userProvider.currentUser?.data?.accessToken;
      if (accessToken == null || accessToken.isEmpty) {
        emit(GetProjectError("User not logged in"));
        return;
      }

      final response = await _dataSource.getProject(accessToken, projectId);

      emit(GetProjectSuccess(response));
    } catch (e) {
      emit(GetProjectError(e.toString()));
    }
  }

  Future<void> deleteProject(String projectId) async {
    emit(DeleteProjectLoading());
    try {
      final accessToken = userProvider.currentUser?.data?.accessToken;
      if (accessToken == null || accessToken.isEmpty) {
        emit(DeleteProjectError("User not logged in"));
        return;
      }

      final response = await _dataSource.deleteProject(accessToken, projectId);

      emit(DeleteProjectSuccess(response));
    } catch (e) {
      emit(DeleteProjectError(e.toString()));
    }
  }
}
