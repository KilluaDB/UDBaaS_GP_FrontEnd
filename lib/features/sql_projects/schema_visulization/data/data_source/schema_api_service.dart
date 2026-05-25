import 'dart:convert';

import 'package:dbaas_project/core/constants/api_constants.dart';
import 'package:dbaas_project/features/sql_projects/schema_visulization/data/models/schema_response.dart';
import 'package:http/http.dart' as http;
class SchemaApiService {
  
Future<PostgresSchemaVisualizeResponse> visualizePostgresSchema({
  required String projectId,
  String schema = "public",
    required String accessToken,
}) async {

  final response = await http.get(
    Uri.parse(
      '${ApiConstants.baseURL}${ApiConstants.projectEndPoint}$projectId/postgres/schema/visualize',
    ),
    headers: {
      "Authorization": "Bearer $accessToken",
      "Content-Type": "application/json",
    },
  );

  print("STATUS: ${response.statusCode}");
  print("BODY: ${response.body}");

  final json = jsonDecode(response.body);

  if (response.statusCode == 200 &&
      json["status"] == "success") {
    return PostgresSchemaVisualizeResponse.fromJson(json);
  } else {
    throw Exception(
      json["message"] ?? "Failed to visualize schema",
    );
  }
}
}