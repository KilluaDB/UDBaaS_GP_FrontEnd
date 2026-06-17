import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:dbaas_project/core/constants/api_constants.dart';
import 'package:dbaas_project/features/no_sql_projects/collections/data/models/mongo_collection_model.dart';

class MongoCollectionsApiService {
  Future<List<MongoCollectionModel>> getCollections({
    required String projectId,
    required String accessToken,
  }) async {
    final uri = Uri.parse(
      '${ApiConstants.baseURL}'
      '${ApiConstants.projectEndPoint}'
      '$projectId/mongodb/collections',
    );

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );


      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        final List<dynamic> collectionsList =
            json['data']['collections'] ?? [];

        return collectionsList
            .map((e) => MongoCollectionModel.fromJson(e))
            .toList();
      } else {
        final errorJson = jsonDecode(response.body);
        throw Exception(
          errorJson['message'] ?? 'Failed to load collections',
        );
      }
    } catch (e) {
      throw Exception('Get Collections Error: $e');
    }
  }

  Future<MongoCollectionModel> createCollection({
    required String projectId,
    required String accessToken,
    required CreateMongoCollectionRequest request,
  }) async {
    final uri = Uri.parse(
      '${ApiConstants.baseURL}'
      '${ApiConstants.projectEndPoint}'
      '$projectId/mongodb/collections',
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

   

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);

        return MongoCollectionModel.fromJson(
          json['data'],
        );
      } else {
        final errorJson = jsonDecode(response.body);
        throw Exception(
          errorJson['message'] ?? 'Failed to create collection',
        );
      }
    } catch (e) {
      throw Exception('Create Collection Error: $e');
    }
  }

  Future<MongoCollectionModel> deleteCollection({
    required String projectId,
    required String accessToken,
    required String collectionName,
  }) async {
    final uri = Uri.parse(
      '${ApiConstants.baseURL}'
      '${ApiConstants.projectEndPoint}'
      '$projectId/mongodb/collections/$collectionName',
    );

    try {
      final response = await http.delete(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );


      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        return MongoCollectionModel.fromJson(
          json['data'],
        );
      } else {
        final errorJson = jsonDecode(response.body);
        throw Exception(
          errorJson['message'] ?? 'Failed to delete collection',
        );
      }
    } catch (e) {
      throw Exception('Delete Collection Error: $e');
    }
  }
}