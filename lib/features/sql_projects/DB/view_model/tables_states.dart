import 'package:dbaas_project/features/sql_projects/DB/data/models/postgres_list_tables_response.dart';
import 'package:dbaas_project/features/sql_projects/DB/data/models/postgres_table_meta_response.dart';
import 'package:dbaas_project/features/sql_projects/DB/data/models/postgres_table_op_response.dart';

abstract class PostgresTablesStates {}

class PostgresTablesInit extends PostgresTablesStates {}

class GetAllTablesLoading extends PostgresTablesStates {}
class GetAllTablesSuccess extends PostgresTablesStates {
  final PostgresListTablesResponse getTablesSuccessResponse;
  GetAllTablesSuccess(this.getTablesSuccessResponse);
}
class GetAllTablesError extends PostgresTablesStates {
  final String message;
  GetAllTablesError(this.message);
}

class GetTableLoading extends PostgresTablesStates {}
class GetTableSuccess extends PostgresTablesStates {
  final PostgresTableMetadata getTableSuccessResponse;
  GetTableSuccess(this.getTableSuccessResponse);
}
class GetTableError extends PostgresTablesStates {
  final String message;
  GetTableError(this.message);
}




class CreateTableLoading extends PostgresTablesStates {}
class CreateTableSuccess extends PostgresTablesStates {
  final PostgresTableOpResponse createTableSuccessResponse;
  CreateTableSuccess(this.createTableSuccessResponse);
}
class CreateTableError extends PostgresTablesStates {
  final String message;
  CreateTableError(this.message);
}


class UpdateTableLoading extends PostgresTablesStates {}
class UpdateTableSuccess extends PostgresTablesStates {
  final PostgresTableOpResponse updateTableSuccessResponse;
  UpdateTableSuccess(this.updateTableSuccessResponse);
}
class UpdateTableError extends PostgresTablesStates {
  final String message;
  UpdateTableError(this.message);
}


class DeleteTableLoading extends PostgresTablesStates {}
class DeleteTableSuccess extends PostgresTablesStates {
  final PostgresTableOpResponse deleteTableResponse;
  DeleteTableSuccess(this.deleteTableResponse);
}
class DeleteTableError extends PostgresTablesStates {
  final String message;
  DeleteTableError(this.message);
}