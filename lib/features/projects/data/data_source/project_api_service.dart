import 'dart:convert';
import 'package:dbaas_project/core/constants/api_constants.dart';
import 'package:dbaas_project/features/projects/data/models/delete_project_response.dart';
import 'package:dbaas_project/features/projects/data/models/get_projects_response.dart';
import 'package:dbaas_project/features/projects/data/models/project_create_response.dart';
import 'package:http/http.dart' as http;

class ProjectApiService {
  Future<ProjectCreateResponse> createProject(
    String accessToken,
    String name,
    String dbType,

  ) async {
    final uri = Uri.parse(
      '${ApiConstants.baseURL}${ApiConstants.allProjectsEndPoint}',
    );
    try {
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'db_type': dbType,
        
        }),
      );

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return ProjectCreateResponse.fromJson(json);
      } else if (response.statusCode == 400) {
        throw Exception('Invalid project data. Please check your inputs.');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please check your access token.');
      } else {
        throw Exception('Failed to create project: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating project: $e');
    }
  }

  Future<GetProjectsResponse> getAllProjects(String accessToken) async {
    final uri = Uri.parse(
      '${ApiConstants.baseURL}${ApiConstants.allProjectsEndPoint}',
    );
    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return GetProjectsResponse.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please check your access token.');
      } else {
        throw Exception('Failed to Get All Projects: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error Getting projects: $e');
    }
  }

  Future<ProjectCreateResponse> getProject(
    String accessToken,
    String projectId,
  ) async {
    final uri = Uri.parse(
      '${ApiConstants.baseURL}${ApiConstants.projectEndPoint}$projectId',
    );
    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return ProjectCreateResponse.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please check your access token.');
      } else {
        throw Exception('Failed to Get  Project: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error Getting project: $e');
    }
  }

  Future<DeleteProjectResponse> deleteProject(
    String accessToken,
    String projectId,
  ) async {
    final uri = Uri.parse(
      '${ApiConstants.baseURL}${ApiConstants.projectEndPoint}$projectId',
    );
    try {
      final response = await http.delete(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return DeleteProjectResponse.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please check your access token.');
      }  else if (response.statusCode == 404) {
        throw Exception('Not found or access denied');
      } 
      else {
        throw Exception('Failed to Delete  Project: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error Deleting projects: $e');
    }
  }


}
