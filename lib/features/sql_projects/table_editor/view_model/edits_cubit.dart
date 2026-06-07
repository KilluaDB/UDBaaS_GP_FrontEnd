import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dbaas_project/features/settings/viewModel/user_provider.dart';
import 'package:dbaas_project/features/sql_projects/table_editor/view_model/edits_states.dart';
import 'package:dbaas_project/features/sql_projects/table_editor/data/data_source/editor_api_service.dart';
import 'package:dbaas_project/features/sql_projects/table_editor/data/models/table_editor_models.dart';

class PostgresTableEditorCubit extends Cubit<PostgresTableEditorStates> {
  final EditorApiService _dataSource;
  final UserProvider userProvider;

  GetRowsResponse? cachedRows;

  PostgresTableEditorCubit({
    required this.userProvider,
    EditorApiService? dataSource,
  }) : _dataSource = dataSource ?? EditorApiService(),
       super(PostgresTableEditorInit());

  String? get _token => userProvider.currentUser?.data?.accessToken;

  Future<void> getAllRows({
    required String projectId,
    required String tableName,
    String schema = 'public',
    int limit = 5,
    int offset = 0,
    bool showLoading = true,
  }) async {
    try {
      if (showLoading) emit(GetAllRowsLoading());

      if (_token == null) {
        emit(GetAllRowsError("User not logged in"));
        return;
      }

      final response = await _dataSource.getListPostgresRows(
        _token!,
        projectId,
        tableName,
        schema: schema,
        limit: limit,
        offset: offset,
      );

      cachedRows = response;

      emit(GetAllRowsSuccess(response));
    } catch (e) {
      emit(GetAllRowsError(e.toString()));
    }
  }

  Future<void> insertRow({
    required String projectId,
    required String tableName,
    required Map<String, dynamic> values,
    String schema = 'public',
  }) async {
    try {
      emit(InsertRowLoading());

      if (_token == null) {
        emit(InsertRowError("User not logged in"));
        return;
      }

      final response = await _dataSource.insertRow(
        _token!,
        projectId,
        tableName,
        InsertRowRequest(values: values),
        schema: schema,
      );
      print(response.rowId);
      emit(InsertRowSuccess(response));

      await _refreshRows(projectId, tableName, schema);
    } catch (e) {
       print(e.toString());
      emit(InsertRowError(e.toString()));
    }
  }

  Future<void> updateRows({
    required String projectId,
    required String tableName,
    Map<String, dynamic>? filter,
    required Map<String, dynamic> update,
    String schema = 'public',
  }) async {
    try {
      emit(UpdateRowsLoading());

      if (_token == null) {
        emit(UpdateRowsError("User not logged in"));
        return;
      }

      await _dataSource.updateRows(
        _token!,
        projectId,
        tableName,
        UpdateRowsRequest(filter: filter, update: update),
        schema: schema,
      );

      emit(UpdateRowsSuccess());

      await _refreshRows(projectId, tableName, schema);
    } catch (e) {
       print(e.toString());
      emit(UpdateRowsError(e.toString()));
    }
  }

  Future<void> deleteRows({
    required String projectId,
    required String tableName,
    Map<String, dynamic>? filter,
    String schema = 'public',
  }) async {
    try {
      emit(DeleteRowsLoading());

      if (_token == null) {
        emit(DeleteRowsError("User not logged in"));
        return;
      }

      await _dataSource.deleteRows(
        _token!,
        projectId,
        tableName,
        filter: filter,
        schema: schema,
      );

      emit(DeleteRowsSuccess());

      await _refreshRows(projectId, tableName, schema);
    } catch (e) {
       print(e.toString());
      emit(DeleteRowsError(e.toString()));
    }
  }

  Future<void> insertColumn({
    required String projectId,
    required String tableName,
    required String name,
    required String type,
    dynamic defaultValue,
    bool primary = false,
    bool isUnique = false,
    bool isIdentity = false,
    bool nullable = true,
    List<ForeignKeyColumn>? foreignKeys,
    String schema = 'public',
  }) async {
    try {
      emit(InsertColumnLoading());

      if (_token == null) {
        emit(InsertColumnError("User not logged in"));
        return;
      }

      final response = await _dataSource.addColumn(
        _token!,
        projectId,
        tableName,
        InsertColumnRequest(
          name: name,
          type: type,
          defaultValue: defaultValue,
          primary: primary,
          isUnique: isUnique,
          isIdentity: isIdentity,
          nullable: nullable,
          foreignKeys: foreignKeys,
        ),
        schema: schema,
      );
    
      emit(InsertColumnSuccess(response));

      await _refreshRows(projectId, tableName, schema);
    } catch (e) {
      print(e.toString());
      emit(InsertColumnError(e.toString()));
    }
  }

  Future<void> deleteColumn({
    required String projectId,
    required String tableName,
    required String columnName,
    String schema = 'public',
  }) async {
    try {
      emit(DeleteColumnLoading());

      if (_token == null) {
        emit(DeleteColumnError("User not logged in"));
        return;
      }

      await _dataSource.deleteColumn(
        _token!,
        projectId,
        tableName,
        columnName,
        schema: schema,
      );

      emit(DeleteColumnSuccess());

      await _refreshRows(projectId, tableName, schema);
    } catch (e) {
       print(e.toString());
      emit(DeleteColumnError(e.toString()));
    }
  }

  Future<void> _refreshRows(
    String projectId,
    String tableName,
    String schema,
  ) async {
    try {
      final response = await _dataSource.getListPostgresRows(
        _token!,
        projectId,
        tableName,
        schema: schema,
      );

      cachedRows = response;

      // IMPORTANT: emit ONLY success (no loading flicker)
      emit(GetAllRowsSuccess(response));
    } catch (e) {
      emit(GetAllRowsError(e.toString()));
    }
  }
}
