import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:dbaas_project/core/constants/api_constants.dart';
import 'package:dbaas_project/core/models/API/api_response.dart';
import 'package:dbaas_project/features/no_sql_projects/query/data/mongo_query_models.dart';

class MongoQueryApiService {
  Future<MongoQueryDocumentsResult> queryMongoDocuments({
    required String projectId,
    required String collection,
    required String accessToken,
    required MongoQueryDocumentsRequest request,
  }) async {
    final encodedCollection = Uri.encodeComponent(collection);

    final uri = Uri.parse(
      '${ApiConstants.baseURL}'
      '${ApiConstants.projectEndPoint}'
      '$projectId/mongodb/collections/'
      '$encodedCollection/documents/query',
    );

    try {
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      print('Status Code: ${response.statusCode}');
      print('Body: ${response.body}');

      Map<String, dynamic> json;

      try {
        json = jsonDecode(response.body);
      } catch (_) {
        throw Exception(
          'Invalid server response: ${response.body}',
        );
      }

      if (response.statusCode == 200) {
        final result =
            APIResponse<MongoQueryDocumentsResult>.fromJson(
          json,
          (data) => MongoQueryDocumentsResult.fromJson(data),
        );

        if (result.data == null) {
          throw Exception('No data returned from server');
        }

        return result.data!;
      }

      throw Exception(
        json['message'] ??
            json['error'] ??
            'Unknown error occurred',
      );
    } catch (e) {
      throw Exception(
        'Query Mongo Documents failed: $e',
      );
    }
  }
}