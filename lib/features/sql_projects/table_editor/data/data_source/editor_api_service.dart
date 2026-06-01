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
    final encodedTable = Uri.encodeComponent(tableName);

    return '${ApiConstants.baseURL}'
        '${ApiConstants.projectEndPoint}'
        '$projectId/postgres/tables/$encodedTable/rows';
  }

  String _columnsPath(String projectId, String tableName) {
    final encodedTable = Uri.encodeComponent(tableName);

    return '${ApiConstants.baseURL}'
        '${ApiConstants.projectEndPoint}'
        '$projectId/postgres/tables/$encodedTable/columns';
  }

  dynamic _decodeBody(http.Response response) {
    if (response.body.isEmpty) return null;
    return jsonDecode(response.body);
  }


  Future<GetRowsResponse> getListPostgresRows(
    String accessToken,
    String projectId,
    String tableName, {
    int limit = 50,
    int offset = 0,
    String schema = 'public',
  }) async {
    final uri = Uri.parse(_basePath(projectId, tableName)).replace(
      queryParameters: {
        'limit': '$limit',
        'offset': '$offset',
        'schema': schema,
      },
    );

    final response = await http.get(
      uri,
      headers: _headers(accessToken),
    );

    final json = _decodeBody(response);

    if (response.statusCode == 200) {
      return GetRowsResponse.fromJson(json['data']);
    }

    throw ApiException(
      json?['message'] ?? 'Failed to fetch rows',
      statusCode: response.statusCode,
    );
  }


  Future<InsertRowResponse> insertRow(
    String accessToken,
    String projectId,
    String tableName,
    InsertRowRequest request, {
    String schema = 'public',
  }) async {
    final uri = Uri.parse(_basePath(projectId, tableName)).replace(
      queryParameters: {'schema': schema},
    );

    final response = await http.post(
      uri,
      headers: _headers(accessToken),
      body: jsonEncode(request.toJson()),
    );

    final json = _decodeBody(response);

    if (response.statusCode == 201) {
      return InsertRowResponse.fromJson(json['data']);
    }

    throw ApiException(
      json?['message'] ?? 'Insert failed',
      statusCode: response.statusCode,
    );
  }


  Future<void> updateRows(
    String accessToken,
    String projectId,
    String tableName,
    UpdateRowsRequest request, {
    String schema = 'public',
  }) async {
    final uri = Uri.parse(_basePath(projectId, tableName)).replace(
      queryParameters: {'schema': schema},
    );

    final response = await http.patch(
      uri,
      headers: _headers(accessToken),
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200) {
      final json = _decodeBody(response);

      throw ApiException(
        json?['message'] ?? 'Update failed',
        statusCode: response.statusCode,
      );
    }
  }


  Future<void> deleteRows(
    String accessToken,
    String projectId,
    String tableName, {
    Map<String, dynamic>? filter,
    String schema = 'public',
  }) async {
    final uri = Uri.parse(_basePath(projectId, tableName)).replace(
      queryParameters: {'schema': schema},
    );

    final response = await http.delete(
      uri,
      headers: _headers(accessToken),
      body: filter != null
          ? jsonEncode({'filter': filter})
          : null,
    );

    if (response.statusCode != 204) {
      final json = _decodeBody(response);

      throw ApiException(
        json?['message'] ?? 'Delete failed',
        statusCode: response.statusCode,
      );
    }
  }


  Future<InsertColumnResponse> addColumn(
    String accessToken,
    String projectId,
    String tableName,
    InsertColumnRequest request, {
    String schema = 'public',
  }) async {
    final uri = Uri.parse(_columnsPath(projectId, tableName)).replace(
      queryParameters: {'schema': schema},
    );

    final response = await http.post(
      uri,
      headers: _headers(accessToken),
      body: jsonEncode(request.toJson()),
    );

    final json = _decodeBody(response);

    if (response.statusCode == 200) {
      return InsertColumnResponse.fromJson(json['data']);
    }

    throw ApiException(
      json?['message'] ?? 'Add column failed',
      statusCode: response.statusCode,
    );
  }


  Future<void> deleteColumn(
    String accessToken,
    String projectId,
    String tableName,
    String columnName, {
    String schema = 'public',
  }) async {
    final encodedColumn = Uri.encodeComponent(columnName);

    final uri = Uri.parse(
      '${_columnsPath(projectId, tableName)}/$encodedColumn',
    ).replace(
      queryParameters: {'schema': schema},
    );

    final response = await http.delete(
      uri,
      headers: _headers(accessToken),
    );

    if (response.statusCode != 204) {
      final json = _decodeBody(response);

      throw ApiException(
        json?['message'] ?? 'Delete column failed',
        statusCode: response.statusCode,
      );
    }
  }
}