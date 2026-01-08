import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  String languageMode = 'en';
  ThemeMode currentMode = ThemeMode.light;
  bool emailNotifications = true;
  bool pushNotifications = true;
  bool queryAlerts = true;
  bool schemaChanges = true;
  Future<void> changeLanguageMode(String lang) async {
    if (languageMode == lang) return;

    languageMode = lang;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', languageMode);
    notifyListeners();
  }

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


  Future<void> setEmailNotifications(bool value) async {
        if (emailNotifications == value) return;

    emailNotifications == value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Email Notification', emailNotifications);
    emailNotifications = value;
    notifyListeners();
  }

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
  bool get isDark => currentMode == ThemeMode.dark;
}
