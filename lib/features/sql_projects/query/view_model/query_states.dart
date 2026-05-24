import 'package:dbaas_project/features/sql_projects/query/data/models/execute_query_response.dart';
import 'package:dbaas_project/features/sql_projects/query/data/models/text_to_sql_response.dart';

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
class TextToSQLExecutionLoading extends QueryStates {}

class TextToSQLExecutionSuccess extends QueryStates {
  TextToSQLResponse textToSQLResponse;
  TextToSQLExecutionSuccess(this.textToSQLResponse);
}
class TextToSQLExecutionError extends QueryStates {
  final String message;
  TextToSQLExecutionError(this.message);
}