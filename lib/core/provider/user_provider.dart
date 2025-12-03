import 'package:dbaas_project/core/models/user.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  User? currentUser;
  void updateUser(User user) {
    currentUser = user;
    notifyListeners();
  }
}
