import 'dart:convert';

import 'package:dbaas_project/core/constants/api_constants.dart';
import 'package:dbaas_project/core/helper/api_error_handler.dart';
import 'package:dbaas_project/features/Auth/data/models/login_response/login_response.dart';
import 'package:dbaas_project/features/Auth/data/models/register_response/register_response.dart';
import 'package:http/http.dart' as http;

class AuthAPIService {
Future<RegisterResponse> register(String email, String password) async {
  final uri = Uri.parse('${ApiConstants.baseURL}${ApiConstants.registerEndPoint}');

  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );

  final json = jsonDecode(response.body);

  if (response.statusCode == 201) {
final json = jsonDecode(response.body);
  return RegisterResponse.fromJson(json);
  } else if (response.statusCode == 400) {
    throw ApiException('Please provide your email and password correctly', statusCode: 400);
  } else if (response.statusCode == 409) {
    throw ApiException('An account with this email already exists', statusCode: 409);
  } else {
    throw ApiException('Something went wrong: ${response.statusCode}', statusCode: response.statusCode);
  }
}
Future<LoginResponse> login(String email, String password) async {
  final uri = Uri.parse('${ApiConstants.baseURL}${ApiConstants.loginEndPoint}');

  try {
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
print("Raw Response Body: ${response.body}");
    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
   final json = jsonDecode(response.body);
  return LoginResponse.fromJson(json);
    } 
    else if (response.statusCode == 400) {
      throw ApiException('Invalid input (e.g. invalid email or password format)', statusCode: 400);
    } 
    else if (response.statusCode == 401) {
      throw ApiException('Invalid email or password', statusCode: 401);
    } 
    else {
      throw ApiException('Server error: ${response.statusCode}', statusCode: response.statusCode);
    }
  } catch (e) {
    if (e is ApiException) rethrow;
    throw ApiException('Unexpected error: $e', statusCode: 500);
  }
}



}
