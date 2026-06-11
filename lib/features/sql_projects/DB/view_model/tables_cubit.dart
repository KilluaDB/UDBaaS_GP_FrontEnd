import 'package:dbaas_project/features/sql_projects/DB/data/data_source/tables_api_service.dart';
import 'package:dbaas_project/features/sql_projects/DB/data/models/postgres_foreign_key_request.dart';
import 'package:dbaas_project/features/sql_projects/DB/data/models/postgres_table_meta_response.dart';
import 'package:dbaas_project/features/sql_projects/DB/data/models/update_foreign_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dbaas_project/features/settings/viewModel/user_provider.dart';

import 'package:dbaas_project/features/sql_projects/DB/data/models/table_column.dart';
import 'package:dbaas_project/features/sql_projects/DB/data/models/postgres_list_tables_response.dart';

import 'package:dbaas_project/features/sql_projects/DB/data/models/create_table_request_body.dart';
import 'package:dbaas_project/features/sql_projects/DB/data/models/update_table_request_body.dart';
import 'package:dbaas_project/features/sql_projects/DB/data/models/delete_table_request_body.dart';

import 'tables_states.dart';
class PostgresTablesCubit extends Cubit<PostgresTablesStates> {
  final PostgresTablesApiService _dataSource;
  final UserProvider userProvider;

  PostgresListTablesResponse? cachedTables;
  Map<String, PostgresTableMetadata> cachedTablesMap = {};


  PostgresTablesCubit({
    required this.userProvider,
    PostgresTablesApiService? dataSource,
  })  : _dataSource = dataSource ?? PostgresTablesApiService(),
        super(PostgresTablesInit());

  String? _getAccessToken() {
    return userProvider.currentUser?.data?.accessToken;
  }
  Future<void> getAllTables(String projectId, {String schema = 'public', bool isSilentRefresh = false}) async {
    if (!isSilentRefresh) emit(GetAllTablesLoading());

    try {

      final token = _getAccessToken();
      if (token == null) return;

      final response = await _dataSource.getListPostgresTables(token, projectId, schema);
      
      cachedTables = response; 
      cachedTablesMap.clear(); 

      final tables = response.data ?? []; 

      for (String tableName in tables) {
         try {
           final tableDetails = await _dataSource.getPostgresTable(token, projectId, tableName, schema);
           cachedTablesMap[tableName] = tableDetails;
         } catch (e) {
           debugPrint("Skipping $tableName: $e");
           continue; 
         }
      }

      emit(GetAllTablesSuccess(response));
    } catch (e) {
      emit(GetAllTablesError(e.toString()));
    }
  }

  Future<void> createTable({
    required String projectId,
    required String tableName,
    required List<TableColumn> columns,
    String? schema,
  
    List<ForeignKey>? foreignKeys,
  }) async {
    emit(CreateTableLoading());

    try {
      final token = _getAccessToken();
      if (token == null) {
        emit(CreateTableError("User not logged in"));
        return;
      }
            await Future.delayed(const Duration(seconds: 1));

      final request = CreateTableRequestBody(
        schema: schema ?? 'public',
        table: tableName,
        columns: columns,
        foreignKeys: foreignKeys,
      );

      final response = await _dataSource.createPostgresTable(token, projectId, request);
      
      emit(CreateTableSuccess(response));


      await getAllTables(
        projectId,
        schema: schema ?? 'public',
        isSilentRefresh: true,
      );
    } catch (e) {
      emit(CreateTableError(e.toString()));
    }
  }

Future<void> updateTable({
  required String projectId,
  String? schema,
  String? tableName,
  List<TableColumn>? columns,
  UpdateForeignKeys? foreignKeys,
  String currentSchema = 'public',
}) async {
  emit(UpdateTableLoading());

  try {
    final token = _getAccessToken();
    if (token == null) {
      emit(UpdateTableError("User not logged in"));
      return;
    }

    final request = UpdateTableRequestBody(
      schema: schema,
      table: tableName,
      columns: columns,
      foreignKeys: foreignKeys,
    );

    final response = await _dataSource.updatePostgresTable(
      token,
      projectId,
      currentSchema,
      tableName ?? '',
      request,
    );

    emit(UpdateTableSuccess(response));

    await getAllTables(
      projectId,
      schema: schema ?? currentSchema,
      isSilentRefresh: true,
    );
  } catch (e) {
    emit(UpdateTableError(e.toString()));
  }
}
    
Future<void> deleteTable({
    required String projectId,
    required String tableName,
    String schema = 'public',
  }) async {
    emit(DeleteTableLoading());

    try {
      final token = _getAccessToken();
      if (token == null) {
        emit(DeleteTableError("User not logged in"));
        return;
      }

      final request = DeleteTableRequestBody(
        schema: schema,
        table: tableName,
      );

      final response = await _dataSource.deletePostgresTable(
        token,
        projectId,
          tableName,
        request,
      
      );


      emit(DeleteTableSuccess(response));

      await getAllTables(projectId, schema: schema, isSilentRefresh: true);
    } catch (e) {
      emit(DeleteTableError(e.toString()));
    }
  }
Future<void> getTable({
  required String projectId,
  required String tableName,
  String schema = 'public',
}) async {
  emit(GetTableLoading());

  try {
    final token = _getAccessToken();
    if (token == null) {
      emit(GetTableError("User not logged in"));
      return;
    }

    final response = await _dataSource.getPostgresTable(
      token,
      projectId,
      tableName,
      schema,
    );
 cachedTablesMap[tableName] = response;
    emit(GetTableSuccess(response));
  } catch (e) {
    emit(GetTableError(e.toString()));
  }
}
  
}