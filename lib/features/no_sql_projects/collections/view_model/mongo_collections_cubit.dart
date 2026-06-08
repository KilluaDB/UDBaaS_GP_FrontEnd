import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/api_service/mongo_collections_api_service.dart';
import '../data/models/mongo_collection_model.dart';
import 'mongo_collections_states.dart';

import '../../../settings/viewModel/user_provider.dart';

class MongoCollectionsCubit extends Cubit<MongoCollectionsStates> {
  final MongoCollectionsApiService _dataSource;
  final UserProvider userProvider;

  List<MongoCollectionModel> cachedCollections = [];

  MongoCollectionsCubit({
    required this.userProvider,
    MongoCollectionsApiService? dataSource,
  })  : _dataSource = dataSource ?? MongoCollectionsApiService(),
        super(MongoCollectionsInit());

  String? _getAccessToken() {
    return userProvider.currentUser?.data?.accessToken;
  }

  Future<void> getCollections(
    String? projectId, {
    bool isSilentRefresh = false,
  }) async {
    if (projectId == null || projectId.isEmpty) {
      emit(GetMongoCollectionsError("Invalid Project ID"));
      return;
    }

    if (!isSilentRefresh) {
      emit(GetMongoCollectionsLoading());
    }

    try {
      final token = _getAccessToken();

      if (token == null || token.isEmpty) {
        emit(GetMongoCollectionsError("User session expired. Please login again."));
        return;
      }

      final response = await _dataSource.getCollections(
        projectId: projectId,
        accessToken: token,
      );

      cachedCollections = response;

      emit(GetMongoCollectionsSuccess(response));
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> createCollection({
    required String? projectId,
    required String name,
  }) async {
    if (projectId == null || projectId.isEmpty) {
      emit(CreateMongoCollectionError("Invalid Project ID"));
      return;
    }

    emit(CreateMongoCollectionLoading());

    try {
      final token = _getAccessToken();

      if (token == null || token.isEmpty) {
        emit(CreateMongoCollectionError("User session expired. Please login again."));
        return;
      }

      final request = CreateMongoCollectionRequest(name: name);

      final response = await _dataSource.createCollection(
        projectId: projectId,
        accessToken: token,
        request: request,
      );

      cachedCollections.add(response);

      emit(CreateMongoCollectionSuccess(response));

      await getCollections(projectId, isSilentRefresh: true);
    } catch (e) {
      _handleCreateError(e);
    }
  }

  Future<void> deleteCollection({
    required String? projectId,
    required String collectionName,
  }) async {
    if (projectId == null || projectId.isEmpty) {
      emit(DeleteMongoCollectionError("Invalid Project ID"));
      return;
    }

    emit(DeleteMongoCollectionLoading());

    try {
      final token = _getAccessToken();

      if (token == null || token.isEmpty) {
        emit(DeleteMongoCollectionError("User session expired. Please login again."));
        return;
      }

      final response = await _dataSource.deleteCollection(
        projectId: projectId,
        accessToken: token,
        collectionName: collectionName,
      );

      cachedCollections.removeWhere(
        (c) => c.name == response.name,
      );

      emit(DeleteMongoCollectionSuccess(response));

      await getCollections(projectId, isSilentRefresh: true);
    } catch (e) {
      _handleDeleteError(e);
    }
  }

  void _handleError(Object e) {
    String message = e.toString();

    if (message.contains("Exception:")) {
      message = message.replaceAll("Exception:", "").trim();
    }

    emit(GetMongoCollectionsError(message));
  }

  void _handleCreateError(Object e) {
    String message = e.toString();

    if (message.contains("Exception:")) {
      message = message.replaceAll("Exception:", "").trim();
    }

    emit(CreateMongoCollectionError(message));
  }

  void _handleDeleteError(Object e) {
    String message = e.toString();

    if (message.contains("Exception:")) {
      message = message.replaceAll("Exception:", "").trim();
    }

    emit(DeleteMongoCollectionError(message));
  }
}