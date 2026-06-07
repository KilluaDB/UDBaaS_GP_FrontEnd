import 'package:dbaas_project/features/no_sql_projects/dash_board/data/api_service/mongo_dashboard_api_service.dart';
import 'package:dbaas_project/features/no_sql_projects/dash_board/data/models/dashboard_model.dart';
import 'package:dbaas_project/features/no_sql_projects/dash_board/view_model/mongo_dashboard_states.dart';
import 'package:dbaas_project/features/settings/viewModel/user_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MongoDashboardCubit
    extends Cubit<MongoDashboardStates> {
  final MongoDashboardApiService _dataSource;
  final UserProvider userProvider;

  MongoDashboardMetrics? metrics;

  MongoDashboardCubit({
    required this.userProvider,
    MongoDashboardApiService? dataSource,
  }) : _dataSource =
            dataSource ?? MongoDashboardApiService(),
       super(MongoDashboardInit());

  Future<void> getDashboardMetrics(
    String? projectId,
  ) async {
    if (projectId == null || projectId.isEmpty) {
      emit(
        GetMongoDashboardMetricsError(
          "Invalid Project ID. Please try re-opening the project.",
        ),
      );
      return;
    }

    emit(GetMongoDashboardMetricsLoading());

    try {
      final accessToken =
          userProvider.currentUser?.data?.accessToken;

      if (accessToken == null || accessToken.isEmpty) {
        emit(
          GetMongoDashboardMetricsError(
            "User session expired. Please login again.",
          ),
        );
        return;
      }

      final response =
          await _dataSource.getDashboardMetrics(
        projectId: projectId,
        accessToken: accessToken,
      );

      metrics = response;

      emit(
        GetMongoDashboardMetricsSuccess(
          response,
        ),
      );
    } catch (e) {
      String errorMessage = e.toString();

      if (errorMessage.contains("Exception:")) {
        errorMessage = errorMessage
            .replaceAll("Exception:", "")
            .trim();
      }

      emit(
        GetMongoDashboardMetricsError(
          errorMessage,
        ),
      );
    }
  }
}