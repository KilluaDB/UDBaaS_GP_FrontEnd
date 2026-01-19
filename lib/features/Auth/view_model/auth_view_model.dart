import 'package:dbaas_project/core/models/user/data.dart';
import 'package:dbaas_project/core/models/user/user.dart';
import 'package:dbaas_project/core/provider/user_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

      User user = User.fromJson({
        'message': response.message,
        'data': Data(email: email),
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', response.data!.accessToken ?? '');
      userProvider.updateUser(user);
      emit(RegisterSuccess(response));
    } catch (e) {
      emit(RegisterError(e.toString()));
    }
  }

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    try {
      final response = await dataSource.login(email, password);

      User user = User.fromJson({
        'message': response.message,
        'data': Data(email: email),
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', response.data!.accessToken ?? '');
    userProvider.updateUser(user);
      emit(LoginSuccess(response));
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }

  Future<void> logout() async {
    emit(LogoutLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');

      if (accessToken == null) throw Exception("No access token found");

      final response = await dataSource.logout(accessToken);

      await prefs.remove('access_token');
      await prefs.remove('refresh_token');

      emit(LogoutSuccess(response));
    } catch (e) {
      emit(logoutError(e.toString()));
    }
  }
}
