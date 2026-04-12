import 'dart:convert';

import 'package:dbaas_project/core/constants/api_constants.dart';
import 'package:dbaas_project/features/sql_projects/query/data/models/execute_query_response.dart';
import 'package:http/http.dart' as http;
class QueryApiService {
  Future<ExecuteQueryResponse> executeQuery({
    required String query,
    required String projectId,
    required String accessToken,
  }) async {
   
    final uri = Uri.parse(
      '${ApiConstants.baseURL}${ApiConstants.projectEndPoint}$projectId/postgres/query/execute',
    );

    try {
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json', 
        },
        body: jsonEncode({
          'query': query,
          'projectId': projectId, 
        }),
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return ExecuteQueryResponse.fromJson(json);
  
} else {
  try {
    final errorJson = jsonDecode(response.body);
    String message = errorJson['message'] ?? 'Error: ${response.statusCode}';
    throw Exception(message);
  } catch (e) {
    throw Exception('Server returned non-JSON response: ${response.body}');
  }
}
    } catch (e) {
      throw Exception('$e');
    }
  }
}