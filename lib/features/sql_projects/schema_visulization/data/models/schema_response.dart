import 'package:dbaas_project/features/sql_projects/schema_visulization/data/models/schema_visualize.dart';

class PostgresSchemaVisualizeResponse {
  final String status;
  final String message;
  final PostgresSchemaVisualizeData data;

  PostgresSchemaVisualizeResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PostgresSchemaVisualizeResponse.fromJson(
      Map<String, dynamic> json) {
    return PostgresSchemaVisualizeResponse(
      status: json['status'],
      message: json['message'],
      data: PostgresSchemaVisualizeData.fromJson(json['data']),
    );
  }
}