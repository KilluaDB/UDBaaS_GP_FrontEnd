abstract class AppException implements Exception {
  final String message;

  AppException(this.message);
}

class RegisterException extends AppException {
  RegisterException(super.message);
}

class LoginException extends AppException {
  LoginException(super.message);
}

class LogoutException extends AppException {
  LogoutException(super.message);
}

class DeleteException extends AppException {
  DeleteException(super.message);
}
