import 'package:dbaas_project/features/settings/viewModel/user_provider.dart';
import 'package:dbaas_project/features/sql_projects/query/data/data_source/query_api_service.dart';
import 'package:dbaas_project/features/sql_projects/query/view_model/query_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QueryCubit extends Cubit<QueryStates> {
  final QueryApiService _dataSource;
  final UserProvider userProvider;

  QueryCubit( {required this.userProvider, QueryApiService? dataSource})
    : _dataSource = dataSource ?? QueryApiService(),
      super(QueryInit());
  Future<void>executeQuery(String query,String projectId  ) async
  {
 emit(QueryExecutionLoading());
     try {
      final accessToken = userProvider.currentUser?.data?.accessToken;
      if (accessToken == null || accessToken.isEmpty) {
        emit(QueryExecutionError("User not logged in"));
        return;
      }

      final response =
          await _dataSource.executeQuery(query: query,projectId: projectId,accessToken: accessToken);

      emit(QueryExecutionSuccess(response)); 
    } catch (e) {
      emit(QueryExecutionError(e.toString()));
    }
  }
}
