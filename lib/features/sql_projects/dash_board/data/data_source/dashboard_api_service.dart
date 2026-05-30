import 'dart:convert';

import 'package:dbaas_project/core/constants/api_constants.dart';
import 'package:dbaas_project/features/sql_projects/dash_board/data/models/dash_metrics.dart';
import 'package:dbaas_project/features/sql_projects/dash_board/data/models/dash_overview_model.dart';
import 'package:dbaas_project/features/sql_projects/dash_board/data/models/query_history.dart';
import 'package:http/http.dart' as http;
class DashboardApiService {
  Future<PostgresDashboardOverview> getDashboardOverview({
    required String projectId,
    required String accessToken,
  }) async {
   
    final uri = Uri.parse(
      '${ApiConstants.baseURL}${ApiConstants.projectEndPoint}$projectId/postgres/dashboard/overview',
    );

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',

        },
  
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return PostgresDashboardOverview.fromJson(json['data']);
  
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


  Future<PostgresDashboardMetrics> getDashboardMetrics({
    required String projectId,
    required String accessToken,
  }) async {
   
    final uri = Uri.parse(
      '${ApiConstants.baseURL}${ApiConstants.projectEndPoint}$projectId/postgres/dashboard/metrics',
    );

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
         
        
        },
  
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return PostgresDashboardMetrics.fromJson(json['data']);
  
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
Future<List<QueryHistoryItem>> getQueryHistory({
  required String projectId,
  required String accessToken,
}) async {
final uri = Uri.parse(
  '${ApiConstants.baseURL}${ApiConstants.projectEndPoint}$projectId/postgres/query/history',
).replace(queryParameters: {
  'limit': '10',
});

  try {
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> data = json['data'] ?? [];

      return data
          .map((item) => QueryHistoryItem.fromJson(item))
          .toList();
    } else {
      throw Exception(
        json['message'] ?? 'Error: ${response.statusCode}',
      );
    }
  } catch (e) {
    throw Exception('Failed to fetch query history: $e');
  }
}
   
   
   
    }