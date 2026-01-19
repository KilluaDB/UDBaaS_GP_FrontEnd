import 'dart:convert';

import 'package:dbaas_project/core/constants/api_constants.dart';
import 'package:dbaas_project/features/settings/data/models/delete_response/delete_response.dart';
import 'package:dbaas_project/features/settings/data/models/logout_response.dart';
import 'package:http/http.dart' as http;

class SettingApiService {
  Future<LogoutResponse> logout(String accessToken) async {
    final uri = Uri.parse(
      '${ApiConstants.baseURL}${ApiConstants.logoutEndPoint}',
    );

    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to logout: ${response.body}');
    }

    final json = jsonDecode(response.body);
    return LogoutResponse.fromJson(json);
  }

  Future<DeleteResponse> delete(String accessToken, String userId) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseURL}${ApiConstants.usersEndPoint}$userId',
      );

      final response = await http.delete(
        uri,
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 204 || response.body.isEmpty) {
        return DeleteResponse(message: 'User deleted successfully');
      }

      final json = jsonDecode(response.body);
      return DeleteResponse.fromJson(json);
    } catch (e) {
      return DeleteResponse(message: 'Failed to delete user: ${e.toString()}');
    }
  }
}
