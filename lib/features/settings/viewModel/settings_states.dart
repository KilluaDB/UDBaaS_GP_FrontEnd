import 'package:dbaas_project/features/settings/data/models/delete_response/delete_response.dart';
import 'package:dbaas_project/features/settings/data/models/logout_response.dart';

abstract class SettingsStates {}

class SettingsInit extends SettingsStates {}

class LogoutLoading extends SettingsStates {}

class LogoutSuccess extends SettingsStates {
  final LogoutResponse logoutResponse;

  LogoutSuccess(this.logoutResponse);
}

class LogoutError extends SettingsStates {
  final String message;

  LogoutError(this.message);
}

class DeleteLoading extends SettingsStates {}

class DeleteSuccess extends SettingsStates {
  final DeleteResponse deleteResponse;

  DeleteSuccess(this.deleteResponse);
}

class DeleteError extends SettingsStates {
  final String message;

  DeleteError(this.message);
}
