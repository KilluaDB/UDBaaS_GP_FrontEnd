
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SettingsProvider with ChangeNotifier {
  ThemeMode currentMode = ThemeMode.light;
  bool pushNotifications = false;
  bool queryAlerts = true;
  bool schemaChanges = false;
  SettingsProvider();



  static Future<SettingsProvider> init() async {
    final provider = SettingsProvider();
    final prefs = await SharedPreferences.getInstance();

    final theme = prefs.getString('currentMode');
    provider.currentMode = (theme == 'light' || theme==null) ? ThemeMode.light : ThemeMode.dark;

    provider.pushNotifications = prefs.getBool('Push Notification') ?? false;
    provider.queryAlerts = prefs.getBool('Query Notification') ?? true;
    provider.schemaChanges = prefs.getBool('schemaChanges Notification') ?? false;

    return provider;
  }





  Future<void> changeThemeMode(ThemeMode mode) async {
    if (currentMode == mode) return;
    currentMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentMode', mode == ThemeMode.dark ? 'dark' : 'light');
    notifyListeners();
  }

  Future<void> setPushNotifications(bool value) async {
    if (pushNotifications == value) return;
    pushNotifications = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Push Notification', value);
    notifyListeners();
  }

  Future<void> setQueryAlerts(bool value) async {
    if (queryAlerts == value) return;
    queryAlerts = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Query Notification', value);
    notifyListeners();
  }

  Future<void> setSchemaChanges(bool value) async {
    if (schemaChanges == value) return;
    schemaChanges = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('schemaChanges Notification', value);
    notifyListeners();
  }

  bool get isDark => currentMode == ThemeMode.dark;
}