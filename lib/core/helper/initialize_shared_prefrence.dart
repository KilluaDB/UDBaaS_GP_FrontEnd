import 'package:dbaas_project/core/provider/settings_provider.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class InitializeSharedPrefrence {

   static initSharedPrefrence(SettingsProvider provider) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? theme = prefs.getString('currentMode');
    if (theme == 'dark') {
      provider.changeThemeMode(ThemeMode.dark);
    } else if (theme == 'light') {
      provider.changeThemeMode(ThemeMode.light);
    }
  }
}