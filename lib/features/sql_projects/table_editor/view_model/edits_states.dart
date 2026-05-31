import 'package:dbaas_project/features/sql_projects/table_editor/data/models/table_editor_models.dart';

abstract class PostgresTableEditorStates {}

class PostgresTableEditorInit extends PostgresTableEditorStates {}

class GetAllRowsLoading extends PostgresTableEditorStates {}
class GetAllRowsSuccess extends PostgresTableEditorStates {
  final GetRowsResponse getRowsResponse;
  GetAllRowsSuccess(this.getRowsResponse);
}
class GetAllRowsError extends PostgresTableEditorStates {
  final String message;
  GetAllRowsError(this.message);
}



class InsertRowLoading extends PostgresTableEditorStates {}
class InsertRowSuccess extends PostgresTableEditorStates {
  final InsertRowResponse insertRowResponse;
  InsertRowSuccess(this.insertRowResponse);
}
class InsertRowError extends PostgresTableEditorStates {
  final String message;
  InsertRowError(this.message);
}


class UpdateRowsLoading extends PostgresTableEditorStates {}
class UpdateRowsSuccess extends PostgresTableEditorStates {
   UpdateRowsSuccess();
}
class UpdateRowsError extends PostgresTableEditorStates {
  final String message;
  UpdateRowsError(this.message);
}



class DeleteRowsLoading extends PostgresTableEditorStates {}
class DeleteRowsSuccess extends PostgresTableEditorStates {
   DeleteRowsSuccess();
}
class DeleteRowsError extends PostgresTableEditorStates {
  final String message;
  DeleteRowsError(this.message);
}


class InsertColumnLoading extends PostgresTableEditorStates {}
class InsertColumnSuccess extends PostgresTableEditorStates {
  final InsertColumnResponse insertColumnResponse;
  InsertColumnSuccess(this.insertColumnResponse);
}
class InsertColumnError extends PostgresTableEditorStates {
  final String message;
  InsertColumnError(this.message);
}


class DeleteColumnLoading extends PostgresTableEditorStates {}
class DeleteColumnSuccess extends PostgresTableEditorStates {
   DeleteColumnSuccess();
}
class DeleteColumnError extends PostgresTableEditorStates {
  final String message;
  DeleteColumnError(this.message);
}
