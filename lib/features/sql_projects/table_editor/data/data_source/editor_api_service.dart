import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:dbaas_project/core/constants/api_constants.dart';
import 'package:dbaas_project/core/helper/api_error_handler.dart';
import 'package:dbaas_project/features/sql_projects/table_editor/data/models/table_editor_models.dart';

class EditorApiService {
  Map<String, String> _headers(String accessToken) => {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };

  String _basePath(String projectId, String tableName) {
    return '${ApiConstants.baseURL}'
        '${ApiConstants.projectEndPoint}'
        '$projectId/postgres/tables/$tableName/rows';
  }
String _columnsPath(String projectId, String tableName) {
  return '${ApiConstants.baseURL}'
      '${ApiConstants.projectEndPoint}'
      '$projectId/postgres/tables/$tableName/columns';
}
Future<GetRowsResponse> getListPostgresRows(
  String accessToken,
  String projectId,
  String tableName, {
  int limit = 50,
  int offset = 0,
}) async {
  final uri = Uri.parse(
    '${_basePath(projectId, tableName)}'
    '?limit=$limit&offset=$offset',
  );

  final response = await http.get(
    uri,
    headers: _headers(accessToken),
  );

  final json = jsonDecode(response.body);

  switch (response.statusCode) {
    case 200:
      return GetRowsResponse.fromJson(json['data']);

    case 400:
      throw ApiException(
        'Invalid project ID, table name, limit, or offset',
        statusCode: 400,
      );

    case 401:
      throw ApiException('Unauthorized', statusCode: 401);

    case 404:
      throw ApiException(
        'Project not accessible or DB not ready',
        statusCode: 404,
      );

    default:
      throw ApiException(
        'Unexpected error: ${response.body}',
        statusCode: response.statusCode,
      );
  }
}
  Future<InsertRowResponse> insertRow(
    String accessToken,
    String projectId,
    String tableName,
    InsertRowRequest request,
  ) async {
    final uri = Uri.parse(_basePath(projectId, tableName));

    final response = await http.post(
      uri,
      headers: _headers(accessToken),
      body: jsonEncode(request.toJson()),
    );

    final json = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return InsertRowResponse.fromJson(json['data']);
    }

    throw ApiException(
      json['message'] ?? 'Insert failed',
      statusCode: response.statusCode,
    );
  }


  Future<void> updateRows(
    String accessToken,
    String projectId,
    String tableName,
    UpdateRowsRequest request,
  ) async {
    final uri = Uri.parse(_basePath(projectId, tableName));

    final response = await http.patch(
      uri,
      headers: _headers(accessToken),
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200) {
      final json = jsonDecode(response.body);

      throw ApiException(
        json['message'] ?? 'Update failed',
        statusCode: response.statusCode,
      );
    }
  }

 
  Future<void> deleteRows(
    String accessToken,
    String projectId,
    String tableName, {
    Map<String, dynamic>? filter,
  }) async {
    final uri = Uri.parse(_basePath(projectId, tableName));

    final response = await http.delete(
      uri,
      headers: _headers(accessToken),
      body: filter != null
          ? jsonEncode({'filter': filter})
          : null,
    );

    if (response.statusCode != 204) {
      final json = jsonDecode(response.body);

      throw ApiException(
        json['message'] ?? 'Delete failed',
        statusCode: response.statusCode,
      );
    }
  }
  Future<InsertColumnResponse> addColumn(
  String accessToken,
  String projectId,
  String tableName,
  InsertColumnRequest request,
) async {
  final uri = Uri.parse(_columnsPath(projectId, tableName));

  final response = await http.post(
    uri,
    headers: _headers(accessToken),
    body: jsonEncode(request.toJson()),
  );

  final json = jsonDecode(response.body);

  if (response.statusCode == 200) {
    return InsertColumnResponse.fromJson(json['data']);
  }

  throw ApiException(
    json['message'] ?? 'Add column failed',
    statusCode: response.statusCode,
  );
}
Future<void> deleteColumn(
  String accessToken,
  String projectId,
  String tableName,
  String columnName,
) async {
  final uri = Uri.parse(
    '${_columnsPath(projectId, tableName)}/$columnName',
  );

  final response = await http.delete(
    uri,
    headers: _headers(accessToken),
  );

  if (response.statusCode != 204) {
    final json = jsonDecode(response.body);

    throw ApiException(
      json['message'] ?? 'Delete column failed',
      statusCode: response.statusCode,
    );
  }
}
}