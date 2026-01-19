import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dbaas_project/core/models/user/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;
  String _displayName = 'User';

  User? get currentUser => _currentUser;
  String get displayName => _displayName;

  UserProvider() {
    _loadDisplayName();
  }

  Future<void> _loadDisplayName() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString('display_name');
    if (savedName != null && savedName.isNotEmpty) {
      _displayName = savedName;
      notifyListeners();
    }
  }

  void setUser(User user) {
    _currentUser = user;

    final name = user.data?.name;
    if (name != null && name.isNotEmpty) {
      _displayName = name;
    } else {
      final email = user.data?.email;
      if (email != null && email.contains('@')) {
        _displayName = email.split('@').first;
      } else {
        _displayName = 'User';
      }
    }

    _saveDisplayName();

    notifyListeners();
  }

  Future<void> loadFromSP() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString('display_name');
    if (savedName != null && savedName.isNotEmpty) {
      _displayName = savedName;
      notifyListeners();
    }
  }

  Future<void> updateUserName(String newName) async {
    if (newName.isEmpty || newName == _displayName) return;

    _displayName = newName;

    await _saveDisplayName();

    notifyListeners();
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
          if (kIsWeb) {
        await prefs.remove('web_avatar_bytes');
      } else {
        await prefs.remove('avatar_path');
      }

    notifyListeners();
  }
}
