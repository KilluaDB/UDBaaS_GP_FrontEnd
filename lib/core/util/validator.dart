class Validator {
  static String? validateEmail(String? val) {
    final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    if (val == null) {
      return 'this field is required';
    } else if (val.trim().isEmpty) {
      return 'this field is required';
    } else if (emailRegex.hasMatch(val) == false) {
      return 'Enter a valid E-mail';
    } else {
      return null;
    }
  }

static String? validatePassword(String? val) {
  if (val == null || val.trim().isEmpty) {
    return 'This field is required';
  }

  if (val.length < 12) {
    return 'Password must be at least 12 characters';
  }

  if (!RegExp(r'[A-Z]').hasMatch(val)) {
    return 'Password must contain at least one uppercase letter';
  }

  if (!RegExp(r'[a-z]').hasMatch(val)) {
    return 'Password must contain at least one lowercase letter';
  }

  if (!RegExp(r'[0-9]').hasMatch(val)) {
    return 'Password must contain at least one digit';
  }

  if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(val)) {
    return 'Password must contain at least one special character';
  }

  return null;
}

  static String? validateProjectName(String? val) {
    final RegExp nameRegex = RegExp(r'^[a-zA-Z0-9 ]+$');
    if (val == null || val.trim().isEmpty) {
      return 'This field is required';
    } else if (!nameRegex.hasMatch(val.trim())) {
      return 'This field is required(Only Spaces is allowed no Specail characters)';
    } else {
      return null;
    }
  }
  static String? validateColumnName(String? val) {
  final RegExp columnRegex = RegExp(r'^[a-zA-Z_][a-zA-Z0-9_$]*$');

  if (val == null || val.trim().isEmpty) {
    return 'Column name is required';
  }

  if (!columnRegex.hasMatch(val.trim())) {
    return 'Must start with letter/_ and contain only letters, numbers, _ or \$';
  }

  return null;
}
static String? validateTableName(String? val) {
  final RegExp tableRegex = RegExp(r'^[a-zA-Z_][a-zA-Z0-9_$]*$');

  if (val == null || val.trim().isEmpty) {
    return 'Table name is required';
  }

  if (!tableRegex.hasMatch(val.trim())) {
    return 'Must start with letter/_ and contain only letters, numbers, _ or \$';
  }

  return null;
}
}
