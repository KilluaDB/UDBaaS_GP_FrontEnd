import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/api_service/mongo_collections_api_service.dart';
import '../data/models/mongo_collection_model.dart';
import 'mongo_collections_states.dart';

import '../../../settings/viewModel/user_provider.dart';

class MongoCollectionsCubit extends Cubit<MongoCollectionsStates> {
  final MongoCollectionsApiService _dataSource;
  final UserProvider userProvider;

  List<MongoCollectionModel> cachedCollections = [];
  Map<String, MongoCollectionModel> cachedCollectionsMap = {};

  MongoCollectionsCubit({
    required this.userProvider,
    MongoCollectionsApiService? dataSource,
  })  : _dataSource = dataSource ?? MongoCollectionsApiService(),
        super(MongoCollectionsInit());

  String? _getAccessToken() {
    return userProvider.currentUser?.data?.accessToken;
  }

  /// GET ALL COLLECTIONS
  Future getCollections(
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
      cachedCollectionsMap.clear();

      for (final col in response) {
        cachedCollectionsMap[col.name] = col;
      }

      emit(GetMongoCollectionsSuccess(response));
    } catch (e) {
      String errorMessage = e.toString();

      if (errorMessage.contains("Exception:")) {
        errorMessage = errorMessage.replaceAll("Exception:", "").trim();
      }

      emit(GetMongoCollectionsError(errorMessage));
    }
  }

  /// CREATE COLLECTION
  Future createCollection({
    required String? projectId,
    required String name,
  }) async {
    if (projectId == null || projectId.isEmpty) {
      emit(GetMongoCollectionsError("Invalid Project ID"));
      return;
    }

    emit(GetMongoCollectionsLoading());

    try {
      final token = _getAccessToken();

      if (token == null || token.isEmpty) {
        emit(GetMongoCollectionsError("User session expired. Please login again."));
        return;
      }

      final request = CreateMongoCollectionRequest(name: name);

      final response = await _dataSource.createCollection(
        projectId: projectId,
        accessToken: token,
        request: request,
      );

      cachedCollections.add(response);
      cachedCollectionsMap[response.name] = response;

      emit(GetMongoCollectionsSuccess(cachedCollections));

      await getCollections(
        projectId,
        isSilentRefresh: true,
      );
    } catch (e) {
      String errorMessage = e.toString();

      if (errorMessage.contains("Exception:")) {
        errorMessage = errorMessage.replaceAll("Exception:", "").trim();
      }

      emit(GetMongoCollectionsError(errorMessage));
    }
  }

  /// DELETE COLLECTION
  Future deleteCollection({
    required String? projectId,
    required String collectionName,
  }) async {
    if (projectId == null || projectId.isEmpty) {
      emit(GetMongoCollectionsError("Invalid Project ID"));
      return;
    }

    emit(GetMongoCollectionsLoading());

    try {
      final token = _getAccessToken();

      if (token == null || token.isEmpty) {
        emit(GetMongoCollectionsError("User session expired. Please login again."));
        return;
      }

      final response = await _dataSource.deleteCollection(
        projectId: projectId,
        accessToken: token,
        collectionName: collectionName,
      );

      cachedCollections.removeWhere((c) => c.name == response.name);
      cachedCollectionsMap.remove(response.name);

      emit(GetMongoCollectionsSuccess(cachedCollections));

      await getCollections(
        projectId,
        isSilentRefresh: true,
      );
    } catch (e) {
      String errorMessage = e.toString();

      if (errorMessage.contains("Exception:")) {
        errorMessage = errorMessage.replaceAll("Exception:", "").trim();
      }

      emit(GetMongoCollectionsError(errorMessage));
    }
  }
}