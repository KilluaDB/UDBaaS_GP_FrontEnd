import 'package:dbaas_project/features/sql_projects/dash_board/data/models/dash_metrics.dart';
import 'package:dbaas_project/features/sql_projects/dash_board/data/models/dash_overview_model.dart';
import 'package:dbaas_project/features/sql_projects/dash_board/data/models/query_history.dart';

abstract class DashStates {}

class DashInit extends DashStates {}

class GetDashboardOverviewLoading extends DashStates {}

class GetDashboardOverviewSuccess extends DashStates {
  PostgresDashboardOverview postgresDashboardOverview;
  GetDashboardOverviewSuccess(this.postgresDashboardOverview);
}
class GetDashboardOverviewError extends DashStates {
  final String message;
  GetDashboardOverviewError(this.message);
}




class GetDashboardMetricsLoading extends DashStates {}

class GetDashboardMetricsSuccess extends DashStates {
  PostgresDashboardMetrics postgresDashboardMetrics;
  GetDashboardMetricsSuccess(this.postgresDashboardMetrics);
}
class GetDashboardMetricsError extends DashStates {
  final String message;
  GetDashboardMetricsError(this.message);
}

class GetQueryHistoryLoading extends DashStates {}

class GetQueryHistorySuccess extends DashStates {
  final List<QueryHistoryItem> queryHistory;

  GetQueryHistorySuccess(this.queryHistory);
}

class GetQueryHistoryError extends DashStates {
  final String message;

  GetQueryHistoryError(this.message);
}