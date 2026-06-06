import 'dart:convert';

import 'package:dbaas_project/core/constants/api_constants.dart';
import 'package:dbaas_project/core/helper/api_error_handler.dart';
import 'package:dbaas_project/features/sql_projects/query/data/models/execute_query_response.dart';
import 'package:dbaas_project/features/sql_projects/query/data/models/text_to_sql_response.dart';
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

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return ExecuteQueryResponse.fromJson(json);
  }

  try {
    final errorJson = jsonDecode(response.body);
    throw ApiException(
      errorJson['message'] ?? 'Error ${response.statusCode}: Failed to execute query.',
      statusCode: response.statusCode,
    );
  } catch (e) {
    throw ApiException(
      'Server error: Unable to process the request. Please try again later.',
      statusCode: response.statusCode,
    );
  }
}

Future<TextToSQLResponse> executetextToSQL({
  required String question,
  required String projectId,
  required String accessToken,
}) async {
  final uri = Uri.parse(
    '${ApiConstants.baseURL}${ApiConstants.textToSQLEndPoint}$projectId/postgres/text-to-sql',
  );

  final response = await http.post(
    uri,
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    body: jsonEncode({
      'question': question,
    }),
  );
  print("STATUS: ${response.statusCode}");
print("BODY: ${response.body}");

  if (response.statusCode == 200) {
 
    final json = jsonDecode(response.body);
    return TextToSQLResponse.fromJson(json);
  }

  try {
    final errorJson = jsonDecode(response.body);
  
    throw ApiException(
      errorJson['message'] ?? 'Error ${response.statusCode}',
      statusCode: response.statusCode,
    );
  } catch (_) {
    throw ApiException(
      'Server error: AI service is currently busy. Please try again in a few seconds ',
      statusCode: response.statusCode,
    );
  }
}

}
    
    
    
    