import 'package:dbaas_project/features/settings/viewModel/user_provider.dart';
import 'package:dbaas_project/features/sql_projects/query/data/data_source/query_api_service.dart';
import 'package:dbaas_project/features/sql_projects/query/view_model/query_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QueryCubit extends Cubit<QueryStates> {
  final QueryApiService _dataSource;
  final UserProvider userProvider;

  QueryCubit({required this.userProvider, QueryApiService? dataSource})
      : _dataSource = dataSource ?? QueryApiService(),
        super(QueryInit());

  Future<void> executeQuery(String query, String? projectId) async {
    // 1. التحقق من المدخلات قبل بدء أي شيء
    if (query.trim().isEmpty) {
      emit(QueryExecutionError("Please enter a SQL query first."));
      return;
    }

    if (projectId == null || projectId.isEmpty) {
      emit(QueryExecutionError("Invalid Project ID. Please try re-opening the project."));
      return;
    }

    emit(QueryExecutionLoading());
    
    try {
      final accessToken = userProvider.currentUser?.data?.accessToken;
      
      if (accessToken == null || accessToken.isEmpty) {
        emit(QueryExecutionError("User session expired. Please login again."));
        return;
      }

      // 2. إرسال الطلب للسيرفر
      final response = await _dataSource.executeQuery(
        query: query.trim(), // تنظيف الفراغات الزائدة
        projectId: projectId,
        accessToken: accessToken,
      );

      // 3. النجاح
      emit(QueryExecutionSuccess(response));
      
    } catch (e) {
      // 4. معالجة الخطأ بشكل احترافي
      String errorMessage = e.toString();
      if (errorMessage.contains("Exception:")) {
        errorMessage = errorMessage.replaceAll("Exception:", "").trim();
      }
      emit(QueryExecutionError(errorMessage));
    }
  }
}