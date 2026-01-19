import 'dart:convert';

import 'package:dbaas_project/core/constants/api_constants.dart';
import 'package:dbaas_project/features/Auth/data/models/login_response/login_response.dart';
import 'package:dbaas_project/features/Auth/data/models/logout_response.dart';
import 'package:dbaas_project/features/Auth/data/models/register_response/register_response.dart';
import 'package:http/http.dart' as http;

class AuthAPIService {
  Future<RegisterResponse> register(String email, String password) async {
    final uri = Uri.parse(
      '${ApiConstants.baseURL}${ApiConstants.registerEndPoint}',
    );

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final json = jsonDecode(response.body);
    return RegisterResponse.fromJson(json);
  }

  Future<LoginResponse> login(String email, String password) async {
    final uri = Uri.parse(
      '${ApiConstants.baseURL}${ApiConstants.loginEndPoint}',
    );

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final json = jsonDecode(response.body);
    return LoginResponse.fromJson(json);
  }

  Future<LogoutResponse> logout(String accessToken) async {
    final uri = Uri.parse(
      '${ApiConstants.baseURL}${ApiConstants.logoutEndPoint}',
    );

    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    final json = jsonDecode(response.body);
    return LogoutResponse.fromJson(json);
  }
}
