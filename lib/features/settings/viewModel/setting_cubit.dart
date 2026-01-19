import 'package:dbaas_project/features/settings/data/data_source/setting_api_service.dart';
import 'package:dbaas_project/features/settings/viewModel/settings_states.dart';
import 'package:dbaas_project/features/settings/viewModel/user_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingCubit extends Cubit<SettingsStates> {
  final SettingApiService _dataSource;
  final UserProvider userProvider;

  SettingCubit({required this.userProvider, SettingApiService? dataSource})
    : _dataSource = dataSource ?? SettingApiService(),
      super(SettingsInit());

  Future<void> logout() async {
    emit(LogoutLoading());
    try {
      final accessToken = userProvider.currentUser?.data?.accessToken;

      if (accessToken == null) {
        throw Exception("No access token found");
      }

      final response = await _dataSource.logout(accessToken);

      userProvider.clearUser();
      emit(LogoutSuccess(response));
    } catch (e) {
      emit(LogoutError(e.toString()));
    }
  }

  Future<void> delete(String userId) async {
    emit(DeleteLoading());
    try {
      final accessToken = userProvider.currentUser?.data?.accessToken;

      if (accessToken == null || accessToken.isEmpty) {
        emit(DeleteError("User not logged in"));
        return;
      }

      final response = await _dataSource.delete(accessToken, userId);

      userProvider.clearUser();
      emit(DeleteSuccess(response));
    } catch (e) {
      emit(DeleteError(e.toString()));
    }
  }
}
