
import 'package:dbaas_project/features/sql_projects/schema_generation/data/models/schema_generation_models.dart';

abstract class SchemaGenerationStates {}

class SchemaGenerationInit extends SchemaGenerationStates {}


class GenerateSchemaLoading extends SchemaGenerationStates {}

class GenerateSchemaSuccess extends SchemaGenerationStates {
  final PostgresSchemaGenerationResponse response;

  GenerateSchemaSuccess(this.response);
}

class GenerateSchemaError extends SchemaGenerationStates {
  final String message;

  GenerateSchemaError(this.message);
}
class SchemaPromptUpdated extends SchemaGenerationStates {
  final String prompt;
  SchemaPromptUpdated(this.prompt);
}

class ApproveSchemaLoading extends SchemaGenerationStates {}

class ApproveSchemaSuccess extends SchemaGenerationStates {
  final ApproveSchemaResponse response;

  ApproveSchemaSuccess(this.response);
}

class ApproveSchemaError extends SchemaGenerationStates {
  final String message;

  ApproveSchemaError(this.message);
}