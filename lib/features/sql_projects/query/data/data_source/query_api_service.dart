import 'dart:convert';

import 'package:dbaas_project/core/constants/api_constants.dart';
import 'package:dbaas_project/features/sql_projects/query/data/models/execute_query_response.dart';
import 'package:http/http.dart' as http;

class QueryApiService {
  Future<ExecuteQueryResponse> executeQuery(
  {    required String  query,
    required String projectId,
   required String accessToken,}

  ) async {
    final uri = Uri.parse(
      '${ApiConstants.baseURL}${ApiConstants.projectEndPoint}${projectId}/postgres/query/execute',
    );
    try {
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'query': query,
        
        }),
      );

if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return ExecuteQueryResponse.fromJson(json);
      } else if (response.statusCode == 400) {
        throw Exception('Invalid input (missing query or invalid project ID)');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else if (response.statusCode == 500) {
        throw Exception('Server Error: Failed to execute query');
      } else {
        throw Exception('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error Executing   Query: $e');
    }
  }
}
