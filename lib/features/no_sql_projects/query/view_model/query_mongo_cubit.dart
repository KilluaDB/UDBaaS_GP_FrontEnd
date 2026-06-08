
import 'package:dbaas_project/features/no_sql_projects/query/data/mongo_query_models.dart';
import 'package:dbaas_project/features/no_sql_projects/query/data/mongo_query_service.dart';
import 'package:dbaas_project/features/no_sql_projects/query/view_model/query_mongo_states.dart';
import 'package:dbaas_project/features/settings/viewModel/user_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MongoQueryCubit extends Cubit<MongoQueryState> {
  final MongoQueryApiService _apiService;
  final UserProvider userProvider;

  MongoQueryDocumentsResult? cachedResult;

  MongoQueryCubit({
    required this.userProvider,
    MongoQueryApiService? apiService,
  })  : _apiService = apiService ?? MongoQueryApiService(),
        super(MongoQueryInitial());

  Future<void> queryDocuments({
    required String projectId,
    required String collection,
    Map<String, dynamic>? filter,
    Map<String, dynamic>? sort,
    int? page,
    int? limit,
  }) async {
    emit(MongoQueryLoading());

    try {
      final token = userProvider.currentUser?.data?.accessToken;

      if (token == null || token.isEmpty) {
        emit(MongoQueryError("User session expired. Please login again."));
        return;
      }

      final request = MongoQueryDocumentsRequest(
        filter: filter,
        sort: sort,
        page: page,
        limit: limit,
      );

      final result = await _apiService.queryMongoDocuments(
        projectId: projectId,
        collection: collection,
        accessToken: token,
        request: request,
      );

      cachedResult = result;

      emit(MongoQuerySuccess(result));
    } catch (e) {
      String message = e.toString().replaceAll("Exception:", "").trim();

      emit(MongoQueryError(message));
    }
  }
}