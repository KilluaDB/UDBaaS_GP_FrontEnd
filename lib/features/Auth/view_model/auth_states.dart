import 'package:dbaas_project/features/Auth/data/models/login_response/login_response.dart';
import 'package:dbaas_project/features/Auth/data/models/register_response/register_response.dart';

abstract class AuthState {}

class AuthInit extends AuthState {}

class RegisterLoading extends AuthState {}

class RegisterSuccess extends AuthState {
  final RegisterResponse registerResponse;

  RegisterSuccess(this.registerResponse);
}

class RegisterError extends AuthState {
  final String message;

  RegisterError(this.message);
}

class LoginLoading extends AuthState {}

class LoginSuccess extends AuthState {
  final LoginResponse loginResponse;

  LoginSuccess(this.loginResponse);
}

class LoginError extends AuthState {
  final String message;

  LoginError(this.message);
}
