import 'package:flutter/foundation.dart'; // لـ debugPrint
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dbaas_project/core/models/user/data.dart';
import 'package:dbaas_project/core/models/user/user.dart';
import 'package:dbaas_project/features/settings/viewModel/user_provider.dart';
import 'package:dbaas_project/features/Auth/data/data_source/api_service.dart';
import 'auth_states.dart';

class AuthViewModel extends Cubit<AuthState> {
  final AuthAPIService dataSource = AuthAPIService();
  final UserProvider userProvider;

  AuthViewModel({required this.userProvider}) : super(AuthInit());

  Future<void> register(String email, String password) async {
    emit(RegisterLoading());
    try {
      final response = await dataSource.register(email, password);

      User user = User(
        message: response.message,
        status: "success",
        data: Data(
          email: email,
          accessToken: response.data?.accessToken,
          id: response.data?.user_id,
        ),
      );

      userProvider.setUser(user);
      emit(RegisterSuccess(response));
    } catch (e) {
      String errorMessage = e.toString().replaceFirst(RegExp(r'^Exception: '), '');
      emit(RegisterError(errorMessage));
    }
  }

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    try {
      final response = await dataSource.login(email, password);

      if (response.data != null) {
        User user = User(
          message: response.message,
          status: "success",
          data: Data(
            email: email,
            accessToken: response.data?.accessToken,
            id: response.data?.user_id,
          ),
        );

        userProvider.setUser(user);
        emit(LoginSuccess(response));
      } else {
        emit(LoginError("Login failed: Unexpected server response"));
      }
    } catch (e) {
      debugPrint("Login failed error: $e");
      
      String errorMessage = e.toString().replaceFirst(RegExp(r'^Exception: '), '');
      emit(LoginError(errorMessage));
    }
  }
}