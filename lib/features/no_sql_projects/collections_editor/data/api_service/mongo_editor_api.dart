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

  String _documentsPath(String projectId, String collectionName) {
    final encodedCollection = Uri.encodeComponent(collectionName);

    return '${ApiConstants.baseURL}'
        '${ApiConstants.projectEndPoint}'
        '$projectId/mongodb/collections/$encodedCollection/documents';
  }

  dynamic _decodeBody(http.Response response) {
    if (response.body.isEmpty) return null;
    return jsonDecode(response.body);
  }

  Future<MongoGetDocumentsResponse> getDocuments(
    String accessToken,
    String projectId,
    String collectionName, {
    int limit = 20,
    int page = 1,
  }) async {
    final uri = Uri.parse(
      _documentsPath(projectId, collectionName),
    ).replace(queryParameters: {'limit': '$limit', 'page': '$page'});

    final response = await http.get(uri, headers: _headers(accessToken));

    final json = _decodeBody(response);

    if (response.statusCode == 200) {
      return MongoGetDocumentsResponse.fromJson(json['data']);
    }

    throw ApiException(
      json?['message'] ?? 'Failed to get documents',
      statusCode: response.statusCode,
    );
  }

  Future<MongoInsertDocumentsResponse> insertDocuments(
    String accessToken,
    String projectId,
    String collectionName,
    MongoInsertDocumentsRequest request,
  ) async {
    final response = await http.post(
      Uri.parse(_documentsPath(projectId, collectionName)),
      headers: _headers(accessToken),
      body: jsonEncode(request.toJson()),
    );

    final json = _decodeBody(response);

    if (response.statusCode == 201) {
      return MongoInsertDocumentsResponse.fromJson(json['data']);
    }

    throw ApiException(
      json?['message'] ?? 'Insert failed',
      statusCode: response.statusCode,
    );
  }

  Future<MongoUpdateDocumentsResponse> updateDocuments(
    String accessToken,
    String projectId,
    String collectionName,
    MongoUpdateDocumentsRequest request,
  ) async {
    final body = {
      "filter": request.filter,
      "update": request.update,
      if (request.upsert != null) "upsert": request.upsert,
    };

    final response = await http.patch(
      Uri.parse(_documentsPath(projectId, collectionName)),
      headers: _headers(accessToken),
      body: jsonEncode(body),
    );

    final json = _decodeBody(response);

    if (response.statusCode == 200) {
      return MongoUpdateDocumentsResponse.fromJson(json['data']);
    }

    throw ApiException(
      json?['error'] ?? 'Update failed',
      statusCode: response.statusCode,
    );
  }

  Future<MongoDeleteDocumentsResponse> deleteDocuments(
    String accessToken,
    String projectId,
    String collectionName,
    MongoDeleteDocumentsRequest request,
  ) async {
    final response = await http.delete(
      Uri.parse(_documentsPath(projectId, collectionName)),
      headers: _headers(accessToken),
      body: jsonEncode(request.toJson()),
    );

    final json = _decodeBody(response);

    if (response.statusCode == 200) {
      return MongoDeleteDocumentsResponse.fromJson(json['data']);
    }

    throw ApiException(
      json?['message'] ?? 'Delete failed',
      statusCode: response.statusCode,
    );
  }

  Future<MongoCountDocumentsResponse> countDocuments(
    String accessToken,
    String projectId,
    String collectionName,
    MongoCountDocumentsRequest request,
  ) async {
    final response = await http.post(
      Uri.parse('${_documentsPath(projectId, collectionName)}/count'),
      headers: _headers(accessToken),
      body: jsonEncode(request.toJson()),
    );

    final json = _decodeBody(response);

    if (response.statusCode == 200) {
      return MongoCountDocumentsResponse.fromJson(json['data']);
    }

    throw ApiException(
      json?['message'] ?? 'Count failed',
      statusCode: response.statusCode,
    );
  }

  Future<MongoDocumentResponse> getDocument(
    String accessToken,
    String projectId,
    String collectionName,
    String docId,
  ) async {
    final response = await http.get(
      Uri.parse('${_documentsPath(projectId, collectionName)}/$docId'),
      headers: _headers(accessToken),
    );

    final json = _decodeBody(response);

    if (response.statusCode == 200) {
      return MongoDocumentResponse.fromJson(json['data']);
    }

    throw ApiException(
      json?['message'] ?? 'Failed to get document',
      statusCode: response.statusCode,
    );
  }

  Future<String> deleteDocument(
    String accessToken,
    String projectId,
    String collectionName,
    String docId,
  ) async {
    final response = await http.delete(
      Uri.parse('${_documentsPath(projectId, collectionName)}/$docId'),
      headers: _headers(accessToken),
    );

    final json = _decodeBody(response);

    if (response.statusCode == 200) {
      return json?['message'] ?? 'Document deleted successfully';
    }

    throw ApiException(
      json?['message'] ?? 'Delete document failed',
      statusCode: response.statusCode,
    );
  }

  Future<String> addField(
    String accessToken,
    String projectId,
    String collectionName,
    String docId,
    MongoAddDocumentFieldRequest request,
  ) async {
    final response = await http.post(
      Uri.parse('${_documentsPath(projectId, collectionName)}/$docId/fields'),
      headers: _headers(accessToken),
      body: jsonEncode(request.toJson()),
    );

    final json = _decodeBody(response);

    if (response.statusCode == 200) {
      return json?['message'] ?? 'Field added successfully';
    }

    throw ApiException(
      json?['message'] ?? 'Add field failed',
      statusCode: response.statusCode,
    );
  }

  Future<String> updateField(
    String accessToken,
    String projectId,
    String collectionName,
    String docId,
    String field,
    MongoUpdateFieldRequest request,
  ) async {
    final encodedField = Uri.encodeComponent(field);
final body = jsonEncode(request.toJson());



    final response = await http.patch(
      Uri.parse(
        '${_documentsPath(projectId, collectionName)}/$docId/fields/$encodedField',
      ),
      headers: _headers(accessToken),
      body: jsonEncode(request.toJson()),
    );

    final json = _decodeBody(response);
  
    if (response.statusCode == 200) {
      return json?['message'] ?? 'Field updated successfully';
    }

    throw ApiException(
      json?['message'] ?? 'Update field failed',
      statusCode: response.statusCode,
    );
  }

  Future<String> deleteField(
    String accessToken,
    String projectId,
    String collectionName,
    String docId,
    String field,
  ) async {
    final encodedField = Uri.encodeComponent(field);

    final response = await http.delete(
      Uri.parse(
        '${_documentsPath(projectId, collectionName)}/$docId/fields/$encodedField',
      ),
      headers: _headers(accessToken),
    );

    final json = _decodeBody(response);

    if (response.statusCode == 200) {
      return json?['message'] ?? 'Field deleted successfully';
    }

    throw ApiException(
      json?['message'] ?? 'Delete field failed',
      statusCode: response.statusCode,
    );
  }
}
