import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:dbaas_project/core/constants/api_constants.dart';
import 'package:dbaas_project/core/helper/api_error_handler.dart';
import 'package:dbaas_project/features/no_sql_projects/collections_editor/data/models/mongo_editor_models.dart';

class MongoEditorApiService {
  Map<String, String> _headers(String accessToken) => {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };

  String _basePath(String projectId, String collection) {
    final encodedCollection = Uri.encodeComponent(collection);

    return '${ApiConstants.baseURL}'
        '${ApiConstants.projectEndPoint}'
        '$projectId/mongodb/collections/$encodedCollection';
  }

  String _documentsPath(String projectId, String collection) {
    return '${_basePath(projectId, collection)}/documents';
  }

  String _fieldsPath(String projectId, String collection) {
    return '${_basePath(projectId, collection)}/fields';
  }

  dynamic _decodeBody(http.Response response) {
    if (response.body.isEmpty) return null;
    return jsonDecode(response.body);
  }

  Future getDocuments(
    String accessToken,
    String projectId,
    String collection, {
    int limit = 20,
    int page = 1,
  }) async {
    final uri = Uri.parse(
      _documentsPath(projectId, collection),
    ).replace(
      queryParameters: {
        'limit': '$limit',
        'page': '$page',
      },
    );

    final response = await http.get(
      uri,
      headers: _headers(accessToken),
    );

    final json = _decodeBody(response);

    if (response.statusCode == 200) {
      return MongoGetDocumentsResult.fromJson(json['data']);
    }

    throw ApiException(
      json?['message'] ?? 'Failed to fetch documents',
      statusCode: response.statusCode,
    );
  }

  Future insertDocuments(
    String accessToken,
    String projectId,
    String collection,
    MongoInsertDocumentsRequest request,
  ) async {
    final uri = Uri.parse(
      _documentsPath(projectId, collection),
    );

    final response = await http.post(
      uri,
      headers: _headers(accessToken),
      body: jsonEncode(request.toJson()),
    );

    final json = _decodeBody(response);

    if (response.statusCode == 201) {
      return MongoInsertDocumentsResult.fromJson(json['data']);
    }

    throw ApiException(
      json?['message'] ?? 'Insert failed',
      statusCode: response.statusCode,
    );
  }

  Future updateDocuments(
    String accessToken,
    String projectId,
    String collection,
    MongoUpdateDocumentsRequest request,
  ) async {
    final uri = Uri.parse(
      _documentsPath(projectId, collection),
    );

    final response = await http.patch(
      uri,
      headers: _headers(accessToken),
      body: jsonEncode(request.toJson()),
    );

    final json = _decodeBody(response);

    if (response.statusCode == 200) {
      return MongoUpdateDocumentsResult.fromJson(json['data']);
    }

    throw ApiException(
      json?['message'] ?? 'Update failed',
      statusCode: response.statusCode,
    );
  }

  Future deleteDocuments(
    String accessToken,
    String projectId,
    String collection,
    MongoDeleteDocumentsRequest request,
  ) async {
    final uri = Uri.parse(
      _documentsPath(projectId, collection),
    );

    final response = await http.delete(
      uri,
      headers: _headers(accessToken),
      body: jsonEncode(request.toJson()),
    );

    final json = _decodeBody(response);

    if (response.statusCode == 200) {
      return MongoDeleteDocumentsResult.fromJson(json['data']);
    }

    throw ApiException(
      json?['message'] ?? 'Delete failed',
      statusCode: response.statusCode,
    );
  }

  Future getDocumentById(
    String accessToken,
    String projectId,
    String collection,
    String docId,
  ) async {
    final uri = Uri.parse(
      '${_documentsPath(projectId, collection)}/$docId',
    );

    final response = await http.get(
      uri,
      headers: _headers(accessToken),
    );

    final json = _decodeBody(response);

    if (response.statusCode == 200) {
      return json['data'] as Map<String, dynamic>;
    }

    throw ApiException(
      json?['message'] ?? 'Failed to get document',
      statusCode: response.statusCode,
    );
  }

  Future countDocuments(
    String accessToken,
    String projectId,
    String collection,
    MongoCountDocumentsRequest request,
  ) async {
    final uri = Uri.parse(
      '${_documentsPath(projectId, collection)}/count',
    );

    final response = await http.post(
      uri,
      headers: _headers(accessToken),
      body: jsonEncode(request.toJson()),
    );

    final json = _decodeBody(response);

    if (response.statusCode == 200) {
      return MongoCountDocumentsResult.fromJson(json['data']);
    }

    throw ApiException(
      json?['message'] ?? 'Count failed',
      statusCode: response.statusCode,
    );
  }

  Future deleteDocumentById(
    String accessToken,
    String projectId,
    String collection,
    String docId,
  ) async {
    final uri = Uri.parse(
      '${_documentsPath(projectId, collection)}/$docId',
    );

    final response = await http.delete(
      uri,
      headers: _headers(accessToken),
    );

    if (response.statusCode != 200) {
      final json = _decodeBody(response);

      throw ApiException(
        json?['message'] ?? 'Delete document failed',
        statusCode: response.statusCode,
      );
    }
  }

  Future addField(
    String accessToken,
    String projectId,
    String collection,
    MongoAddFieldRequest request,
  ) async {
    final uri = Uri.parse(
      _fieldsPath(projectId, collection),
    );

    final response = await http.post(
      uri,
      headers: _headers(accessToken),
      body: jsonEncode(request.toJson()),
    );

    final json = _decodeBody(response);

    if (response.statusCode != 200) {
      throw ApiException(
        json?['message'] ?? 'Add field failed',
        statusCode: response.statusCode,
      );
    }
  }

  Future removeField(
    String accessToken,
    String projectId,
    String collection,
    String field,
  ) async {
    final encodedField = Uri.encodeComponent(field);

    final uri = Uri.parse(
      '${_fieldsPath(projectId, collection)}/$encodedField',
    );

    final response = await http.delete(
      uri,
      headers: _headers(accessToken),
    );

    if (response.statusCode != 200) {
      final json = _decodeBody(response);

      throw ApiException(
        json?['message'] ?? 'Remove field failed',
        statusCode: response.statusCode,
      );
    }
  }

  Future updateDocumentField(
    String accessToken,
    String projectId,
    String collection,
    String docId,
    String field,
    MongoUpdateFieldRequest request,
  ) async {
    final encodedField = Uri.encodeComponent(field);

    final uri = Uri.parse(
      '${_documentsPath(projectId, collection)}/$docId/fields/$encodedField',
    );

    final response = await http.patch(
      uri,
      headers: _headers(accessToken),
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200) {
      final json = _decodeBody(response);

      throw ApiException(
        json?['message'] ?? 'Update field failed',
        statusCode: response.statusCode,
      );
    }
  }

  Future deleteDocumentField(
    String accessToken,
    String projectId,
    String collection,
    String docId,
    String field,
  ) async {
    final encodedField = Uri.encodeComponent(field);

    final uri = Uri.parse(
      '${_documentsPath(projectId, collection)}/$docId/fields/$encodedField',
    );

    final response = await http.delete(
      uri,
      headers: _headers(accessToken),
    );

    if (response.statusCode != 200) {
      final json = _decodeBody(response);

      throw ApiException(
        json?['message'] ?? 'Delete field failed',
        statusCode: response.statusCode,
      );
    }
  }
}