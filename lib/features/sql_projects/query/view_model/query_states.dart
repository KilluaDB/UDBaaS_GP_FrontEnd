import 'package:dbaas_project/features/sql_projects/query/data/models/execute_query_response.dart';

abstract class QueryStates {}

class QueryInit extends QueryStates {}

class QueryExecutionLoading extends QueryStates {}

class QueryExecutionSuccess extends QueryStates {
  ExecuteQueryResponse executeQueryResponse;
  QueryExecutionSuccess(this.executeQueryResponse);
}
class QueryExecutionError extends QueryStates {
  final String message;
  QueryExecutionError(this.message);
}