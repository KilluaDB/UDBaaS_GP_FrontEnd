import 'package:dbaas_project/features/sql_projects/table_editor/view_model/edits_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dbaas_project/features/settings/viewModel/user_provider.dart';

import 'package:dbaas_project/features/sql_projects/table_editor/data/data_source/editor_api_service.dart';
import 'package:dbaas_project/features/sql_projects/table_editor/data/models/table_editor_models.dart';


class PostgresTableEditorCubit extends Cubit<PostgresTableEditorStates> {
  final EditorApiService _dataSource;
  final UserProvider userProvider;

  GetRowsResponse? cachedRows;

  PostgresTableEditorCubit({
    required this.userProvider,
    EditorApiService? dataSource,
  })  : _dataSource = dataSource ?? EditorApiService(),
        super(PostgresTableEditorInit());

  String? _getAccessToken() {
    return userProvider.currentUser?.data?.accessToken;
  }


  Future<void> getAllRows({
    required String projectId,
    required String tableName,
    int limit = 50,
    int offset = 0,
  }) async {
    emit(GetAllRowsLoading());

    try {
      final token = _getAccessToken();

      if (token == null) {
        emit(GetAllRowsError("User not logged in"));
        return;
      }

      final response = await _dataSource.getListPostgresRows(
        token,
        projectId,
        tableName,
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
  }) async {
    emit(InsertRowLoading());

    try {
      final token = _getAccessToken();

      if (token == null) {
        emit(InsertRowError("User not logged in"));
        return;
      }

      final request = InsertRowRequest(values: values);

      final response = await _dataSource.insertRow(
        token,
        projectId,
        tableName,
        request,
      );

      emit(InsertRowSuccess(response));

      await getAllRows(
        projectId: projectId,
        tableName: tableName,
      );
    } catch (e) {
      emit(InsertRowError(e.toString()));
    }
  }


  Future<void> updateRows({
    required String projectId,
    required String tableName,
    Map<String, dynamic>? filter,
    required Map<String, dynamic> update,
  }) async {
    emit(UpdateRowsLoading());

    try {
      final token = _getAccessToken();

      if (token == null) {
        emit(UpdateRowsError("User not logged in"));
        return;
      }

      final request = UpdateRowsRequest(
        filter: filter,
        update: update,
      );

      await _dataSource.updateRows(
        token,
        projectId,
        tableName,
        request,
      );

      emit(UpdateRowsSuccess());

      await getAllRows(
        projectId: projectId,
        tableName: tableName,
      );
    } catch (e) {
      emit(UpdateRowsError(e.toString()));
    }
  }

 
  Future<void> deleteRows({
    required String projectId,
    required String tableName,
    Map<String, dynamic>? filter,
  }) async {
    emit(DeleteRowsLoading());

    try {
      final token = _getAccessToken();

      if (token == null) {
        emit(DeleteRowsError("User not logged in"));
        return;
      }

      await _dataSource.deleteRows(
        token,
        projectId,
        tableName,
        filter: filter,
      );

      emit(DeleteRowsSuccess());

      await getAllRows(
        projectId: projectId,
        tableName: tableName,
      );
    } catch (e) {
      emit(DeleteRowsError(e.toString()));
    }
  }


  Future<void> insertColumn({
    required String projectId,
    required String tableName,
    required String name,
    required String type,
    dynamic defaultValue,
  }) async {
    emit(InsertColumnLoading());

    try {
      final token = _getAccessToken();

      if (token == null) {
        emit(InsertColumnError("User not logged in"));
        return;
      }

      final request = InsertColumnRequest(
        name: name,
        type: type,
        defaultValue: defaultValue,
      );

      final response = await _dataSource.addColumn(
        token,
        projectId,
        tableName,
        request,
      );

      emit(InsertColumnSuccess(response));

      await getAllRows(
        projectId: projectId,
        tableName: tableName,
      );
    } catch (e) {
      emit(InsertColumnError(e.toString()));
    }
  }


  Future<void> deleteColumn({
    required String projectId,
    required String tableName,
    required String columnName,
  }) async {
    emit(DeleteColumnLoading());

    try {
      final token = _getAccessToken();

      if (token == null) {
        emit(DeleteColumnError("User not logged in"));
        return;
      }

      await _dataSource.deleteColumn(
        token,
        projectId,
        tableName,
        columnName,
      );

      emit(DeleteColumnSuccess());

      await getAllRows(
        projectId: projectId,
        tableName: tableName,
      );
    } catch (e) {
      emit(DeleteColumnError(e.toString()));
    }
  }
}