import 'package:dbaas_project/features/settings/viewModel/user_provider.dart';
import 'package:dbaas_project/features/sql_projects/dash_board/data/data_source/dashboard_api_service.dart';
import 'package:dbaas_project/features/sql_projects/dash_board/data/models/dash_metrics.dart';
import 'package:dbaas_project/features/sql_projects/dash_board/data/models/dash_overview_model.dart';
import 'package:dbaas_project/features/sql_projects/dash_board/data/models/query_history.dart';
import 'package:dbaas_project/features/sql_projects/dash_board/view_model/dash_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashCubit extends Cubit<DashStates> {
  final DashboardApiService _dataSource;
  final UserProvider userProvider;
PostgresDashboardOverview? overview;
PostgresDashboardMetrics? metrics;
List<QueryHistoryItem> queryHistory = [];
  DashCubit({required this.userProvider, DashboardApiService? dataSource})
      : _dataSource = dataSource ?? DashboardApiService(),
        super(DashInit());

  Future<void> getDashboardOverview( String? projectId) async {



    if (projectId == null || projectId.isEmpty) {
      emit(GetDashboardOverviewError("Invalid Project ID. Please try re-opening the project."));
      return;
    }

    emit(GetDashboardOverviewLoading());
    
    try {
      final accessToken = userProvider.currentUser?.data?.accessToken;
      
      if (accessToken == null || accessToken.isEmpty) {
        emit(GetDashboardOverviewError("User session expired. Please login again."));
        return;
      }

      final response = await _dataSource.getDashboardOverview(
       
        projectId: projectId,
        accessToken: accessToken,
      );
overview = response;
      emit(GetDashboardOverviewSuccess(response));
      
    } catch (e) {

      
      String errorMessage = e.toString();
      if (errorMessage.contains("Exception:")) {
        errorMessage = errorMessage.replaceAll("Exception:", "").trim();
      }
      emit(GetDashboardOverviewError(errorMessage));
    }
  }


  Future<void> getDashboardMetrics( String? projectId) async {



    if (projectId == null || projectId.isEmpty) {
      emit(GetDashboardMetricsError("Invalid Project ID. Please try re-opening the project."));
      return;
    }

    emit(GetDashboardMetricsLoading());
    
    try {
      final accessToken = userProvider.currentUser?.data?.accessToken;
      
      if (accessToken == null || accessToken.isEmpty) {
        emit(GetDashboardMetricsError("User session expired. Please login again."));
        return;
      }

      final response = await _dataSource.getDashboardMetrics(
       
        projectId: projectId,
        accessToken: accessToken,
      );
metrics = response;
      emit(GetDashboardMetricsSuccess(response));
      
    } catch (e) {

      
      String errorMessage = e.toString();
      if (errorMessage.contains("Exception:")) {
        errorMessage = errorMessage.replaceAll("Exception:", "").trim();
      }
      emit(GetDashboardMetricsError(errorMessage));
    }
  }

Future<void> getQueryHistory(String? projectId) async {
  if (projectId == null || projectId.isEmpty) {
    emit(GetQueryHistoryError(
      "Invalid Project ID. Please try re-opening the project.",
    ));
    return;
  }

  emit(GetQueryHistoryLoading());

  try {
    final accessToken = userProvider.currentUser?.data?.accessToken;

    if (accessToken == null || accessToken.isEmpty) {
      emit(GetQueryHistoryError(
        "User session expired. Please login again.",
      ));
      return;
    }

    final response = await _dataSource.getQueryHistory(
      projectId: projectId,
      accessToken: accessToken,
    );

    queryHistory = response;

    emit(GetQueryHistorySuccess(response));
  } catch (e) {
    String errorMessage = e.toString();

    if (errorMessage.contains("Exception:")) {
      errorMessage =
          errorMessage.replaceAll("Exception:", "").trim();
    }

    emit(GetQueryHistoryError(errorMessage));
  }
}
}