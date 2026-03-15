import 'dart:convert';

import 'package:dbaas_project/core/constants/api_constants.dart';
import 'package:dbaas_project/features/settings/data/models/delete_response.dart';
import 'package:dbaas_project/features/settings/data/models/logout_response.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart'; // سطر الاستيراد الجديد

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

Future<DeleteResponse> delete(String accessToken) async {
  try {
  
    Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
    

    final String? userIdFromToken = decodedToken['user_id']?.toString();

    print("DEBUG: Extracted User ID: $userIdFromToken");
    

    if (userIdFromToken == null) {
      return DeleteResponse(message: 'User ID key not found in token');
    }


    final String url = '${ApiConstants.baseURL}${ApiConstants.usersEndPoint}$userIdFromToken';
    print("DEBUG: Requesting URL: $url");

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );


    if (response.statusCode == 204 || response.statusCode == 200) {
      return DeleteResponse(message: 'User deleted successfully');
    }

    return DeleteResponse(message: 'Server Error: ${response.statusCode}');
  } catch (e) {
    print("CATCH ERROR: $e");
    return DeleteResponse(message: 'Error: ${e.toString()}');
  }
}

}
