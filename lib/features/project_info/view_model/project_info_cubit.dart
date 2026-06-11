import 'package:dbaas_project/features/project_info/data/api_service/project_info_service.dart';
import 'package:dbaas_project/features/project_info/data/models/project_info_model.dart';
import 'package:dbaas_project/features/project_info/view_model/project_info_states.dart';
import 'package:dbaas_project/features/settings/viewModel/user_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dbaas_project/core/helper/api_error_handler.dart';
class ProjectAccessCubit extends Cubit<ProjectAccessState> {
  final ProjectAccessApiService _dataSource;
  final UserProvider userProvider;

 

  ProjectAccessCubit({
    required this.userProvider,
    ProjectAccessApiService? dataSource,
  }) : _dataSource = dataSource ?? ProjectAccessApiService(),
       super(ProjectAccessInitial());

  String? get _token => userProvider.currentUser?.data?.accessToken;


  ProjectAccessModel? accessData;

  Future<void> getProjectAccess({

    required String projectId,
    bool isSilentRefresh = false,
  }) async {
    if (!isSilentRefresh || accessData == null) {
      emit(GetProjectAccessLoading());
    }
    if (_token == null) {
        emit(GetProjectAccessError("User not logged in"));
        return;
      }
    try {
      accessData = await _dataSource.getProjectAccess(
        _token!,
        projectId,
      );

      emit(GetProjectAccessSuccess(accessData!));
    } on ApiException catch (e) {
      emit(GetProjectAccessError(e.message));
    } catch (e) {
      emit(GetProjectAccessError(e.toString()));
    }
  }
}