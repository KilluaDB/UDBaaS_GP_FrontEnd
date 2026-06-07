import 'package:dbaas_project/features/no_sql_projects/dash_board/data/models/dashboard_model.dart';

abstract class MongoDashboardStates {}

class MongoDashboardInit extends MongoDashboardStates {}

class GetMongoDashboardMetricsLoading extends MongoDashboardStates {}

class GetMongoDashboardMetricsSuccess extends MongoDashboardStates {
  final MongoDashboardMetrics mongoDashboardMetrics;

  GetMongoDashboardMetricsSuccess(
    this.mongoDashboardMetrics,
  );
}

class GetMongoDashboardMetricsError extends MongoDashboardStates {
  final String message;

  GetMongoDashboardMetricsError(this.message);
}