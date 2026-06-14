import 'dart:convert';
import 'package:dbaas_project/features/sql_projects/index_tab/data/models/index_models.dart';
import 'package:http/http.dart' as http;

import 'package:dbaas_project/core/constants/api_constants.dart';
import 'package:dbaas_project/core/helper/api_error_handler.dart';

class IndexApiService {
  Map<String, String> _headers(String accessToken) => {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };

  String _indexesPath(
    String projectId,
    String tableName,
  ) {
    final encodedTable = Uri.encodeComponent(tableName);

    return '${ApiConstants.baseURL}'
        '${ApiConstants.projectEndPoint}'
        '$projectId/postgres/tables/$encodedTable/indexes';
  }

  dynamic _decodeBody(http.Response response) {
    if (response.body.isEmpty) return null;
    return jsonDecode(response.body);
  }


  Future<PostgresIndexesListData> getIndexes(
    String accessToken,
    String projectId,
    String tableName, {
    String schema = 'public',
  }) async {
    final uri = Uri.parse(
      _indexesPath(projectId, tableName),
    ).replace(
      queryParameters: {
        'schema': schema,
      },
    );

    final response = await http.get(
      uri,
      headers: _headers(accessToken),
    );

    final json = _decodeBody(response);

    if (response.statusCode == 200) {
  return PostgresIndexesListData.fromJson(
  json['data'] as List,
);
    }

    throw ApiException(
      json?['message'] ?? 'Failed to fetch indexes',
      statusCode: response.statusCode,
    );
  }

 
  Future<CreatedIndexData> createIndex(
    String accessToken,
    String projectId,
    String tableName,
    CreateIndexRequest request, {
    String schema = 'public',
  }) async {
    final uri = Uri.parse(
      _indexesPath(projectId, tableName),
    ).replace(
      queryParameters: {
        'schema': schema,
      },
    );

    final response = await http.post(
      uri,
      headers: _headers(accessToken),
      body: jsonEncode(
        request.toJson(),
      ),
    );

    final json = _decodeBody(response);

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return CreatedIndexData.fromJson(
        json['data'],
      );
    }

    throw ApiException(
      json?['message'] ?? 'Create index failed',
      statusCode: response.statusCode,
    );
  }


  Future<void> deleteIndex(
    String accessToken,
    String projectId,
    String tableName,
    String indexName, {
    String schema = 'public',
  }) async {
    final encodedIndex =
        Uri.encodeComponent(indexName);

    final uri = Uri.parse(
      '${_indexesPath(projectId, tableName)}/$encodedIndex',
    ).replace(
      queryParameters: {
        'schema': schema,
      },
    );

    final response = await http.delete(
      uri,
      headers: _headers(accessToken),
    );

    if (response.statusCode == 204) {
      return;
    }

    final json = _decodeBody(response);

    throw ApiException(
      json?['message'] ?? 'Delete index failed',
      statusCode: response.statusCode,
    );
  }
}