import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  String languageMode = 'en';
  ThemeMode currentMode = ThemeMode.light;
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
    await prefs.setString('currentMode', currentMode==ThemeMode.dark?'dark':'light');
    notifyListeners();
  }

  bool get isDark => currentMode == ThemeMode.dark;
}
