import 'package:dbaas_project/features/sql_projects/schema_visulization/data/models/schema_response.dart';
abstract class SchemaStates {}

class SchemaInit extends SchemaStates {}
class PostgresSchemaVisualizationLoading extends SchemaStates {}

class PostgresSchemaVisualizationSuccess extends SchemaStates {
  final PostgresSchemaVisualizeResponse response;

  PostgresSchemaVisualizationSuccess(this.response);
}

class PostgresSchemaVisualizationError extends SchemaStates {
  final String message;

  PostgresSchemaVisualizationError(this.message);
}