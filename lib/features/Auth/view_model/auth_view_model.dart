
import 'package:dbaas_project/core/models/user/data.dart';
import 'package:dbaas_project/core/models/user/user.dart';
import 'package:dbaas_project/features/settings/viewModel/user_provider.dart';
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
        'data': Data(email: email,accessToken:response.data?.accessToken),
      });

      userProvider.setUser(user);
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
        'data': Data(email: email,accessToken:response.data?.accessToken),
      });
      userProvider.setUser(user);
      emit(LoginSuccess(response));
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}
