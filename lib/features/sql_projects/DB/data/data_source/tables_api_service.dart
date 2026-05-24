import 'dart:convert';
import 'package:dbaas_project/core/constants/api_constants.dart';
import 'package:dbaas_project/core/helper/api_error_handler.dart';
import 'package:dbaas_project/features/sql_projects/DB/data/models/delete_table_request_body.dart';
import 'package:dbaas_project/features/sql_projects/DB/data/models/postgres_table_meta_response.dart';
import 'package:dbaas_project/features/sql_projects/DB/data/models/update_table_request_body.dart';
import 'package:http/http.dart' as http;

import '../models/postgres_list_tables_response.dart';
import '../models/create_table_request_body.dart';
import '../models/postgres_table_op_response.dart';


class PostgresTablesApiService {
Future<PostgresListTablesResponse> getListPostgresTables(
  String accessToken,
  String projectId,
  String schema,
) async {
  final uri = Uri.parse(
    '${ApiConstants.baseURL}'
    '${ApiConstants.projectEndPoint}'
    '$projectId/postgres/tables?schema=$schema',
  );

  final response = await http.get(
    uri,
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },
  );

  final json = jsonDecode(response.body);

  switch (response.statusCode) {
    case 200:
      return PostgresListTablesResponse.fromJson(json);

    case 400:
      throw ApiException('Invalid project ID or schema name', statusCode: 400);

    case 401:
      throw ApiException('Unauthorized', statusCode: 401);

    case 404:
      throw ApiException('Project not accessible or DB not ready', statusCode: 404);

    default:
      throw ApiException('Unexpected error: ${response.body}', statusCode: response.statusCode);
  }
}
Future<PostgresTableOpResponse> createPostgresTable(
  String accessToken,
  String projectId,
  CreateTableRequestBody body,
) async {
  final uri = Uri.parse(
    '${ApiConstants.baseURL}'
    '${ApiConstants.projectEndPoint}'
    '$projectId/postgres/tables',
  );

  final response = await http.post(
    uri,
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(body.toJson()),
  );

  final json = jsonDecode(response.body);

  switch (response.statusCode) {
    case 201:
      return PostgresTableOpResponse.fromJson(json);

    case 400:
      throw ApiException('Invalid request body or project ID', statusCode: 400);

    case 401:
      throw ApiException('Unauthorized', statusCode: 401);

    case 404:
      throw ApiException('Project or DB not ready', statusCode: 404);

    case 409:
      throw ApiException('Table already exists', statusCode: 409);

    default:
      throw ApiException('Failed: ${response.body}', statusCode: response.statusCode);
  }
}

Future<PostgresTableMetadata> getPostgresTable(
  String accessToken,
  String projectId,
 
  String table,
   String schema,
) async {
  final uri = Uri.parse(
    '${ApiConstants.baseURL}'
    '${ApiConstants.projectEndPoint}'
    '$projectId/postgres/tables/$table',
  );

  final response = await http.get(
    uri,
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },
  );

  final json = jsonDecode(response.body);

  switch (response.statusCode) {
    case 200:
      return PostgresTableMetadata.fromJson(json['data']);

    case 400:
      throw ApiException('Invalid project/schema/table', statusCode: 400);

    case 401:
      throw ApiException('Unauthorized', statusCode: 401);

    case 404:
      throw ApiException('Table not found or DB not ready', statusCode: 404);

    default:
      throw ApiException('Error: ${response.body}', statusCode: response.statusCode);
  }
}
Future<PostgresTableOpResponse> updatePostgresTable(
  String accessToken,
  String projectId,
  String schema,
  String table,
  UpdateTableRequestBody body,
) async {
  final uri = Uri.parse(
    '${ApiConstants.baseURL}'
    '${ApiConstants.projectEndPoint}'
    '$projectId/postgres/tables/$table',
  );

  final response = await http.patch(
    uri,
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(body.toJson()),
  );

  final json = jsonDecode(response.body);

  switch (response.statusCode) {
    case 200:
      return PostgresTableOpResponse.fromJson(json);

    case 400:
      throw ApiException('Invalid update or no changes detected', statusCode: 400);

    case 401:
      throw ApiException('Unauthorized', statusCode: 401);

    case 404:
      throw ApiException('Table not found', statusCode: 404);

    default:
      throw ApiException('Update failed: ${response.body}', statusCode: response.statusCode);
  }
}
Future<PostgresTableOpResponse> deletePostgresTable(
  String accessToken,
  String projectId,
  String table,
  DeleteTableRequestBody body,
) async {
  final uri = Uri.parse(
    '${ApiConstants.baseURL}'
    '${ApiConstants.projectEndPoint}'
    '$projectId/postgres/tables/$table',
  );

  final response = await http.delete(
    uri,
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(body.toJson()),
  );

  final json = jsonDecode(response.body);

  switch (response.statusCode) {
    case 200:
      return PostgresTableOpResponse.fromJson(json);

    case 400:
      throw ApiException('Invalid project or table name', statusCode: 400);

    case 401:
      throw ApiException('Unauthorized', statusCode: 401);

    case 404:
      throw ApiException('Table or project not found', statusCode: 404);

    default:
      throw ApiException('Delete failed: ${response.body}', statusCode: response.statusCode);
  }
}
}