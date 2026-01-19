
import 'package:dbaas_project/core/models/user/user.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
   User? currentUser;
  Future<void>  updateUser(User user) async {
    currentUser = user;
    notifyListeners();
  }
}
