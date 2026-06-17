import 'dart:convert';

import 'package:dbaas_project/core/constants/api_constants.dart';
import 'package:dbaas_project/features/no_sql_projects/dash_board/data/models/dashboard_model.dart';
import 'package:http/http.dart' as http;

class MongoDashboardApiService {
  Future<MongoDashboardMetrics> getDashboardMetrics({
    required String projectId,
    required String accessToken,
  }) async {
    final uri = Uri.parse(
      '${ApiConstants.baseURL}${ApiConstants.projectEndPoint}$projectId/mongodb/dashboard/metrics',
    );

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );



      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        return MongoDashboardMetrics.fromJson(
          json['data'],
        );
      } else {
        try {
          final errorJson = jsonDecode(response.body);

          String message =
              errorJson['message'] ??
              'Error: ${response.statusCode}';

          throw Exception(message);
        } catch (e) {
          throw Exception(
            'Server returned non-JSON response: ${response.body}',
          );
        }
      }
    } catch (e) {
      throw Exception('$e');
    }
  }
}