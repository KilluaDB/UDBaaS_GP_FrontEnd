import 'dart:convert';

import 'package:dbaas_project/core/constants/api_constants.dart';
import 'package:dbaas_project/features/sql_projects/schema_generation/data/models/schema_generation_models.dart';
import 'package:http/http.dart' as http;

class SchemaGenerationApiService {
  Future<PostgresSchemaGenerationResponse> generateSchema({
    required String projectId,
    required String accessToken,
    required GenerateSchemaRequest request,
  }) async {
    final response = await http.post(
      Uri.parse(
        '${ApiConstants.baseURL}${ApiConstants.projectEndPoint}$projectId/postgres/schema/from-text',
      ),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
      body: jsonEncode(request.toJson()),
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    final json = jsonDecode(response.body);

    if (response.statusCode == 200 &&
        json["status"] == "success") {
      return PostgresSchemaGenerationResponse.fromJson(json);
    } else {
      throw Exception(
        json["message"] ?? "Failed to generate schema",
      );
    }
  }

  Future<ApproveSchemaResponse> approveSchema({
    required String projectId,
    required String accessToken,
  }) async {
    final response = await http.post(
      Uri.parse(
        '${ApiConstants.baseURL}${ApiConstants.projectEndPoint}$projectId/postgres/schema/approve',
      ),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    final json = jsonDecode(response.body);

    if ((response.statusCode == 200 ||
            response.statusCode == 201) &&
        json["status"] == "success") {
      return ApproveSchemaResponse.fromJson(json);
    } else {
      throw Exception(
        json["message"] ?? "Failed to approve schema",
      );
    }
  }
}