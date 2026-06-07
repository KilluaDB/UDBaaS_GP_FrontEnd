import 'package:dbaas_project/features/no_sql_projects/collections_editor/data/api_service/mongo_editor_api.dart';
import 'package:dbaas_project/features/no_sql_projects/collections_editor/view_model/mongo_edior_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dbaas_project/features/settings/viewModel/user_provider.dart';
import 'package:dbaas_project/features/no_sql_projects/collections_editor/data/models/mongo_editor_models.dart';

class MongoEditorCubit extends Cubit<MongoEditorState> {
  final MongoEditorApiService _dataSource;
  final UserProvider userProvider;

  MongoGetDocumentsResult? cachedDocuments;

  MongoEditorCubit({
    required this.userProvider,
    MongoEditorApiService? dataSource,
  })  : _dataSource = dataSource ?? MongoEditorApiService(),
        super(MongoEditorInit());

  String? get _token => userProvider.currentUser?.data?.accessToken;

  Future getDocuments({
    required String projectId,
    required String collection,
    int limit = 20,
    int page = 1,
    bool showLoading = true,
  }) async {
    try {
      if (showLoading) emit(MongoDocumentsLoading());

      if (_token == null) {
        emit(MongoDocumentsError("User not logged in"));
        return;
      }

      final response = await _dataSource.getDocuments(
        _token!,
        projectId,
        collection,
        limit: limit,
        page: page,
      );

      cachedDocuments = response;

      emit(MongoDocumentsSuccess(response));
    } catch (e) {
      emit(MongoDocumentsError(e.toString()));
    }
  }

  Future insertDocuments({
    required String projectId,
    required String collection,
    required List<Map<String, dynamic>> documents,
  }) async {
    try {
      emit(MongoInsertDocumentsLoading());

      if (_token == null) {
        emit(MongoInsertDocumentsError("User not logged in"));
        return;
      }

      final response = await _dataSource.insertDocuments(
        _token!,
        projectId,
        collection,
        MongoInsertDocumentsRequest(
          documents: documents,
        ),
      );

      emit(MongoInsertDocumentsSuccess(response));

      await _refreshDocuments(
        projectId,
        collection,
      );
    } catch (e) {
      emit(MongoInsertDocumentsError(e.toString()));
    }
  }

  Future updateDocuments({
    required String projectId,
    required String collection,
    required Map<String, dynamic> filter,
    required Map<String, dynamic> update,
    bool? upsert,
    bool? updateOne,
  }) async {
    try {
      emit(MongoUpdateDocumentsLoading());

      if (_token == null) {
        emit(MongoUpdateDocumentsError("User not logged in"));
        return;
      }

      final response = await _dataSource.updateDocuments(
        _token!,
        projectId,
        collection,
        MongoUpdateDocumentsRequest(
          filter: filter,
          update: update,
          upsert: upsert,
          updateOne: updateOne,
        ),
      );

      emit(MongoUpdateDocumentsSuccess(response));

      await _refreshDocuments(
        projectId,
        collection,
      );
    } catch (e) {
      emit(MongoUpdateDocumentsError(e.toString()));
    }
  }

  Future deleteDocuments({
    required String projectId,
    required String collection,
    required Map<String, dynamic> filter,
    bool? deleteOne,
  }) async {
    try {
      emit(MongoDeleteDocumentsLoading());

      if (_token == null) {
        emit(MongoDeleteDocumentsError("User not logged in"));
        return;
      }

      final response = await _dataSource.deleteDocuments(
        _token!,
        projectId,
        collection,
        MongoDeleteDocumentsRequest(
          filter: filter,
          deleteOne: deleteOne,
        ),
      );

      emit(MongoDeleteDocumentsSuccess(response));

      await _refreshDocuments(
        projectId,
        collection,
      );
    } catch (e) {
      emit(MongoDeleteDocumentsError(e.toString()));
    }
  }

  Future countDocuments({
    required String projectId,
    required String collection,
    Map<String, dynamic>? filter,
  }) async {
    try {
      emit(MongoCountDocumentsLoading());

      if (_token == null) {
        emit(MongoCountDocumentsError("User not logged in"));
        return;
      }

      final response = await _dataSource.countDocuments(
        _token!,
        projectId,
        collection,
        MongoCountDocumentsRequest(
          filter: filter,
        ),
      );

      emit(MongoCountDocumentsSuccess(response));
    } catch (e) {
      emit(MongoCountDocumentsError(e.toString()));
    }
  }

  Future getDocumentById({
    required String projectId,
    required String collection,
    required String docId,
  }) async {
    try {
      emit(MongoGetDocumentLoading());

      if (_token == null) {
        emit(MongoGetDocumentError("User not logged in"));
        return;
      }

      final response = await _dataSource.getDocumentById(
        _token!,
        projectId,
        collection,
        docId,
      );

      emit(MongoGetDocumentSuccess(response));
    } catch (e) {
      emit(MongoGetDocumentError(e.toString()));
    }
  }

  Future deleteDocumentById({
    required String projectId,
    required String collection,
    required String docId,
  }) async {
    try {
      emit(MongoDeleteDocumentLoading());

      if (_token == null) {
        emit(MongoDeleteDocumentError("User not logged in"));
        return;
      }

      await _dataSource.deleteDocumentById(
        _token!,
        projectId,
        collection,
        docId,
      );

      emit(MongoDeleteDocumentSuccess());

      await _refreshDocuments(
        projectId,
        collection,
      );
    } catch (e) {
      emit(MongoDeleteDocumentError(e.toString()));
    }
  }

  Future addField({
    required String projectId,
    required String collection,
    required String field,
    dynamic defaultValue,
    bool? updateExisting,
  }) async {
    try {
      emit(MongoAddFieldLoading());

      if (_token == null) {
        emit(MongoAddFieldError("User not logged in"));
        return;
      }

      await _dataSource.addField(
        _token!,
        projectId,
        collection,
        MongoAddFieldRequest(
          field: field,
          defaultValue: defaultValue,
          updateExisting: updateExisting,
        ),
      );

      emit(MongoAddFieldSuccess());

      await _refreshDocuments(
        projectId,
        collection,
      );
    } catch (e) {
      emit(MongoAddFieldError(e.toString()));
    }
  }

  Future removeField({
    required String projectId,
    required String collection,
    required String field,
  }) async {
    try {
      emit(MongoRemoveFieldLoading());

      if (_token == null) {
        emit(MongoRemoveFieldError("User not logged in"));
        return;
      }

      await _dataSource.removeField(
        _token!,
        projectId,
        collection,
        field,
      );

      emit(MongoRemoveFieldSuccess());

      await _refreshDocuments(
        projectId,
        collection,
      );
    } catch (e) {
      emit(MongoRemoveFieldError(e.toString()));
    }
  }

  Future updateDocumentField({
    required String projectId,
    required String collection,
    required String docId,
    required String field,
    required dynamic value,
  }) async {
    try {
      emit(MongoUpdateDocumentFieldLoading());

      if (_token == null) {
        emit(MongoUpdateDocumentFieldError("User not logged in"));
        return;
      }

      await _dataSource.updateDocumentField(
        _token!,
        projectId,
        collection,
        docId,
        field,
        MongoUpdateFieldRequest(
          value: value,
        ),
      );

      emit(MongoUpdateDocumentFieldSuccess());

      await _refreshDocuments(
        projectId,
        collection,
      );
    } catch (e) {
      emit(MongoUpdateDocumentFieldError(e.toString()));
    }
  }

  Future deleteDocumentField({
    required String projectId,
    required String collection,
    required String docId,
    required String field,
  }) async {
    try {
      emit(MongoDeleteDocumentFieldLoading());

      if (_token == null) {
        emit(MongoDeleteDocumentFieldError("User not logged in"));
        return;
      }

      await _dataSource.deleteDocumentField(
        _token!,
        projectId,
        collection,
        docId,
        field,
      );

      emit(MongoDeleteDocumentFieldSuccess());

      await _refreshDocuments(
        projectId,
        collection,
      );
    } catch (e) {
      emit(MongoDeleteDocumentFieldError(e.toString()));
    }
  }

  Future _refreshDocuments(
    String projectId,
    String collection,
  ) async {
    try {
      final response = await _dataSource.getDocuments(
        _token!,
        projectId,
        collection,
      );

      cachedDocuments = response;

      emit(MongoDocumentsSuccess(response));
    } catch (e) {
      emit(MongoDocumentsError(e.toString()));
    }
  }
}