import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {

  ThemeMode currentMode = ThemeMode.light;

  bool pushNotifications = false;
  bool queryAlerts = true;
  bool schemaChanges = false;

  Future<void> changeThemeMode(ThemeMode mode) async {
    if (currentMode == mode) return;
    currentMode = mode;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'currentMode',
      currentMode == ThemeMode.dark ? 'dark' : 'light',
    );
    notifyListeners();
  }

  bool get isDark => currentMode == ThemeMode.dark;


  Future<void> setPushNotifications(bool value) async {
            if (pushNotifications == value) return;

    pushNotifications == value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Push Notification', pushNotifications);
    pushNotifications = value;
    notifyListeners();
  }

  Future<void> setQueryAlerts(bool value) async {
               if (queryAlerts == value) return;

    queryAlerts == value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Query Notification', queryAlerts);
    queryAlerts = value;
    notifyListeners();
  }

  Future<void> setSchemaChanges(bool value) async {
                   if (schemaChanges == value) return;

    schemaChanges == value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('schemaChanges Notification', schemaChanges);
    schemaChanges = value;
    notifyListeners();
  }
    File? _avatarFile;
  File? get avatarFile => _avatarFile;

  void setAvatar(File file) {
    _avatarFile = file;
    notifyListeners();
  }

}
