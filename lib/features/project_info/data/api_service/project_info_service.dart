import 'dart:convert';
import 'package:dbaas_project/features/project_info/data/models/project_info_model.dart';
import 'package:http/http.dart' as http;

import 'package:dbaas_project/core/constants/api_constants.dart';
import 'package:dbaas_project/core/helper/api_error_handler.dart';

class ProjectAccessApiService {
  Map<String, String> _headers(String accessToken) => {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };

  dynamic _decodeBody(http.Response response) {
    if (response.body.isEmpty) return null;
    return jsonDecode(response.body);
  }

  String _path(String projectId) {
    return '${ApiConstants.baseURL}'
        '${ApiConstants.projectEndPoint}'
        '$projectId/access';
  }

  Future<ProjectAccessModel> getProjectAccess(
    String accessToken,
    String projectId,
  ) async {
    final response = await http.get(
      Uri.parse(_path(projectId)),
      headers: _headers(accessToken),
    );

    final json = _decodeBody(response);

    if (response.statusCode == 200) {
      return ProjectAccessModel.fromJson(json['data']);
    }

    throw ApiException(
      json?['message'] ?? 'Failed to load project access',
      statusCode: response.statusCode,
    );
  }
}