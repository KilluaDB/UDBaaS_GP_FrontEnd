import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dbaas_project/core/models/user/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;
  String _displayName = 'User';

  User? get currentUser => _currentUser;
  String get displayName => _displayName;

  static Future<UserProvider> init() async {
    final prefs = await SharedPreferences.getInstance();
    UserProvider userProvider = UserProvider();

    final userJson = prefs.getString('user_data');
    if (userJson != null) {
      userProvider._currentUser = User.fromJson(jsonDecode(userJson));

      userProvider._displayName =
        
                userProvider._currentUser?.data?.name ?? (  userProvider._currentUser?.data?.email?.split('@').first ?? 'User');
    }
    return userProvider;
  }

  void setUser(User user) {
    _currentUser = user;
    _saveUserToPrefs(user);



    _saveDisplayName();
    notifyListeners();
  }

  Future<void> updateUserName(String newName) async {
    if (newName.isEmpty || newName == _displayName) return;

    _displayName = newName;

    if (_currentUser != null && _currentUser!.data != null) {
      _currentUser!.data!.name = newName;
      await _saveUserToPrefs(_currentUser!);
    }

    await _saveDisplayName();
    notifyListeners();
  }

  Future<void> _saveUserToPrefs(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(user.toJson()));
  }

  Future<void> _saveDisplayName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('display_name', _displayName);
  }

  Future<void> clearUser() async {
    _currentUser = null;
    _displayName = 'User';
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('display_name');
    await prefs.remove('user_data');
    notifyListeners();
  }
}
