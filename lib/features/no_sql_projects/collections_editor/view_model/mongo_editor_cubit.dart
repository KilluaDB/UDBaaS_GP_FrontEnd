import 'package:dbaas_project/features/no_sql_projects/collections_editor/data/api_service/mongo_editor_api.dart';
import 'package:dbaas_project/features/no_sql_projects/collections_editor/view_model/mongo_edior_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dbaas_project/features/settings/viewModel/user_provider.dart';
import 'package:dbaas_project/features/no_sql_projects/collections_editor/data/models/mongo_editor_models.dart';

class MongoCollectionEditorCubit extends Cubit<MongoEditorStates> {
  final MongoEditorApiService _dataSource;
  final UserProvider userProvider;

  MongoGetDocumentsResponse? cachedDocuments;
  int? cachedCount;

  MongoCollectionEditorCubit({
    required this.userProvider,
    MongoEditorApiService? dataSource,
  }) : _dataSource = dataSource ?? MongoEditorApiService(),
       super(MongoEditorInit());

  String? get _token => userProvider.currentUser?.data?.accessToken;
String? editingDocId;

void startEditing(String docId) {
  editingDocId = docId;
  emit(EditModeChanged());
}

void cancelEditing() {
  editingDocId = null;
  emit(EditModeChanged());
}
  Future<void> getDocuments({
    required String projectId,
    required String collectionName,
    int limit = 20,
    int page = 1,
    bool showLoading = true,
  }) async {
    try {
      if (showLoading) emit(GetDocumentsLoading());

      if (_token == null) {
        emit(GetDocumentsError("User not logged in"));
        return;
      }

      final response = await _dataSource.getDocuments(
        _token!,
        projectId,
        collectionName,
        limit: limit,
        page: page,
      );

      cachedDocuments = response;

      emit(GetDocumentsSuccess(response));
    } catch (e) {
      emit(GetDocumentsError(e.toString()));
    }
  }

  Future<void> countDocuments({
    required String projectId,
    required String collectionName,
    Map<String, dynamic>? filter,
  }) async {
    try {
      emit(CountDocumentsLoading());

      if (_token == null) {
        emit(CountDocumentsError("User not logged in"));
        return;
      }

      final response = await _dataSource.countDocuments(
        _token!,
        projectId,
        collectionName,
        MongoCountDocumentsRequest(
          filter: filter,
        ),
      );

      cachedCount = response.count;

      emit(CountDocumentsSuccess(response));
    } catch (e) {
      emit(CountDocumentsError(e.toString()));
    }
  }

  Future<void> insertDocuments({
    required String projectId,
    required String collectionName,
    required List<Map<String, dynamic>> documents,
  }) async {
    try {
      emit(InsertDocumentsLoading());

      if (_token == null) {
        emit(InsertDocumentsError("User not logged in"));
        return;
      }

      final response = await _dataSource.insertDocuments(
        _token!,
        projectId,
        collectionName,
        MongoInsertDocumentsRequest(
          documents: documents,
        ),
      );

      emit(InsertDocumentsSuccess(response));

      await getDocuments(
        projectId: projectId,
        collectionName: collectionName,
        showLoading: false,
      );
          await countDocuments(
      projectId: projectId,
      collectionName: collectionName,
    );
    } catch (e) {
      emit(InsertDocumentsError(e.toString()));
    }
  }

  Future<void> updateDocuments({
    required String projectId,
    required String collectionName,
    Map<String, dynamic>? filter,
    required Map<String, dynamic> update,
    bool? upsert,
  }) async {
    try {
      emit(UpdateDocumentsLoading());

      if (_token == null) {
        emit(UpdateDocumentsError("User not logged in"));
        return;
      }

      final response = await _dataSource.updateDocuments(
        _token!,
        projectId,
        collectionName,
        MongoUpdateDocumentsRequest(
          filter: filter,
          update: update,
          upsert: upsert,
        ),
      );

      emit(UpdateDocumentsSuccess(response));

      await getDocuments(
        projectId: projectId,
        collectionName: collectionName,
        showLoading: false,
      );
    } catch (e) {
      emit(UpdateDocumentsError(e.toString()));
    }
  }

  Future<void> deleteDocuments({
    required String projectId,
    required String collectionName,
    Map<String, dynamic>? filter,
    bool? deleteOne,
  }) async {
    try {
      emit(DeleteDocumentsLoading());

      if (_token == null) {
        emit(DeleteDocumentsError("User not logged in"));
        return;
      }

      final response = await _dataSource.deleteDocuments(
        _token!,
        projectId,
        collectionName,
        MongoDeleteDocumentsRequest(
          filter: filter,
          deleteOne: deleteOne,
        ),
      );

      emit(DeleteDocumentsSuccess(response));

      await getDocuments(
        projectId: projectId,
        collectionName: collectionName,
        showLoading: false,
      );
                await countDocuments(
      projectId: projectId,
      collectionName: collectionName,
    );
    } catch (e) {
      emit(DeleteDocumentsError(e.toString()));
    }
  }

  Future<void> getDocument({
    required String projectId,
    required String collectionName,
    required String docId,
  }) async {
    try {
      emit(GetDocumentLoading());

      if (_token == null) {
        emit(GetDocumentError("User not logged in"));
        return;
      }

      final response = await _dataSource.getDocument(
        _token!,
        projectId,
        collectionName,
        docId,
      );

      emit(GetDocumentSuccess(response));
    } catch (e) {
      emit(GetDocumentError(e.toString()));
    }
  }

  Future<void> addField({
    required String projectId,
    required String collectionName,
    required String docId,
    required String field,
    required String type,
    dynamic value,
  }) async {
    try {
      emit(AddFieldLoading());

      if (_token == null) {
        emit(AddFieldError("User not logged in"));
        return;
      }

      final message = await _dataSource.addField(
        _token!,
        projectId,
        collectionName,
        docId,
        MongoAddDocumentFieldRequest(
          field: field,
          value: value,
          type: type,
        ),
      );

      emit(AddFieldSuccess(message));

      await getDocuments(
        projectId: projectId,
        collectionName: collectionName,
        showLoading: false,
      );
    } catch (e) {
      emit(AddFieldError(e.toString()));
    }
  }

  Future<void> updateField({
    required String projectId,
    required String collectionName,
    required String docId,
    required String field,
    required dynamic value,
    String? type,
  }) async {
    try {
      emit(UpdateFieldLoading());

      if (_token == null) {
        emit(UpdateFieldError("User not logged in"));
        return;
      }

      final message = await _dataSource.updateField(
        _token!,
        projectId,
        collectionName,
        docId,
        field,
        MongoUpdateFieldRequest(
          value: value,
          type: type,
        ),
      );

      emit(UpdateFieldSuccess(message));

      await getDocuments(
        projectId: projectId,
        collectionName: collectionName,
        showLoading: false,
      );
    } catch (e) {
      emit(UpdateFieldError(e.toString()));
    }
  }

  Future<void> deleteField({
    required String projectId,
    required String collectionName,
    required String docId,
    required String field,
  }) async {
    try {
      emit(DeleteFieldLoading());

      if (_token == null) {
        emit(DeleteFieldError("User not logged in"));
        return;
      }

      final message = await _dataSource.deleteField(
        _token!,
        projectId,
        collectionName,
        docId,
        field,
      );

      emit(DeleteFieldSuccess(message));

      await getDocuments(
        projectId: projectId,
        collectionName: collectionName,
        showLoading: false,
      );
    } catch (e) {
      emit(DeleteFieldError(e.toString()));
    }
  }

  Future<void> deleteDocument({
    required String projectId,
    required String collectionName,
    required String docId,
  }) async {
    try {
      emit(DeleteDocumentLoading());

      if (_token == null) {
        emit(DeleteDocumentError("User not logged in"));
        return;
      }

      final message = await _dataSource.deleteDocument(
        _token!,
        projectId,
        collectionName,
        docId,
      );

      emit(DeleteDocumentSuccess(message));

      await getDocuments(
        projectId: projectId,
        collectionName: collectionName,
        showLoading: false,
      );
                await countDocuments(
      projectId: projectId,
      collectionName: collectionName,
    );
    } catch (e) {
      emit(DeleteDocumentError(e.toString()));
    }
  }
}