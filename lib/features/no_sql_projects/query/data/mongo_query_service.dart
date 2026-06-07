import 'dart:convert';
import 'package:dbaas_project/core/models/API/api_response.dart';
import 'package:dbaas_project/features/no_sql_projects/query/data/mongo_query_models.dart';
import 'package:http/http.dart' as http;

class MongoQueryApiService {
  final String baseUrl;

  MongoQueryApiService({required this.baseUrl});

  Future<MongoQueryDocumentsResult> queryMongoDocuments({
    required String projectId,
    required String collection,
    required String accessToken,
    required MongoQueryDocumentsRequest request,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/api/v1/projects/$projectId/mongodb/collections/$collection/documents/query',
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

      print("Status Code: ${response.statusCode}");
      print("Body: ${response.body}");

      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final result = APIResponse<MongoQueryDocumentsResult>.fromJson(
          json,
          (data) => MongoQueryDocumentsResult.fromJson(data),
        );

        return result.data!;
      } else {
        String message = json['message'] ?? 'Unknown error';

        throw Exception(message);
      }
    } catch (e) {
      throw Exception("Query Mongo Documents failed: $e");
    }
  }
}