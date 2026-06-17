import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dbaas_project/features/settings/viewModel/user_provider.dart';

import 'package:dbaas_project/features/sql_projects/index_tab/data/api_service/index_api_service.dart';
import 'package:dbaas_project/features/sql_projects/index_tab/data/models/index_models.dart';
import 'package:dbaas_project/features/sql_projects/index_tab/view_model/index_states.dart';

class IndexCubit extends Cubit<IndexStates> {
  final IndexApiService _dataSource;
  final UserProvider userProvider;

  PostgresIndexesListData? cachedIndexes;

  IndexCubit({required this.userProvider, IndexApiService? dataSource})
    : _dataSource = dataSource ?? IndexApiService(),
      super(IndexInit());

  String? get _token => userProvider.currentUser?.data?.accessToken;

  Future<void> getIndexes({
    required String projectId,
    required String tableName,
    String schema = 'public',
    bool showLoading = true,
  }) async {
    try {
      if (showLoading) {
        emit(GetIndexesLoading());
      }

      if (_token == null) {
        emit(GetIndexesError("User not logged in"));
        return;
      }

      final response = await _dataSource.getIndexes(
        _token!,
        projectId,
        tableName,
        schema: schema,
      );

      cachedIndexes = response;

      emit(GetIndexesSuccess(response));
    } catch (e) {
      emit(GetIndexesError(e.toString()));
    }
  }

  Future<void> createIndex({
    required String projectId,
    required String tableName,
    required String name,
    required List<String> columns,
    bool unique = false,
    String? method,
    String schema = 'public',
  }) async {
    try {
      emit(CreateIndexLoading());

      if (_token == null) {
        emit(CreateIndexError("User not logged in"));
        return;
      }

      final response = await _dataSource.createIndex(
        _token!,
        projectId,
        tableName,
        CreateIndexRequest(
          name: name,
          columns: columns,
          unique: unique,
          method: method,
        ),
        schema: schema,
      );
  
      emit(CreateIndexSuccess(response));

      await _refreshIndexes(projectId, tableName, schema);
    } catch (e) {
      emit(CreateIndexError(e.toString()));
    }
  }

  Future<void> deleteIndex({
    required String projectId,
    required String tableName,
    required String indexName,
    String schema = 'public',
  }) async {
    try {
      emit(DeleteIndexLoading());

      if (_token == null) {
        emit(DeleteIndexError("User not logged in"));
        return;
      }

      await _dataSource.deleteIndex(
        _token!,
        projectId,
        tableName,
        indexName,
        schema: schema,
      );
   
      emit(DeleteIndexSuccess());

      await _refreshIndexes(projectId, tableName, schema);
    } catch (e) {
      emit(DeleteIndexError(e.toString()));
    }
  }

  Future<void> _refreshIndexes(
    String projectId,
    String tableName,
    String schema,
  ) async {
    try {
      final response = await _dataSource.getIndexes(
        _token!,
        projectId,
        tableName,
        schema: schema,
      );

      cachedIndexes = response;

      emit(GetIndexesSuccess(response));
    } catch (e) {
      emit(GetIndexesError(e.toString()));
    }
  }
}
