import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; // getApplicationDocumentsDirectory
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  ThemeMode currentMode = ThemeMode.dark;
  File? avatarFile;
  Uint8List? webAvatarBytes;
  bool pushNotifications = false;
  bool queryAlerts = true;
  bool schemaChanges = false;
  SettingsProvider();
  static Future<SettingsProvider> init() async {
    final provider = SettingsProvider();
    final prefs = await SharedPreferences.getInstance();

    final theme = prefs.getString('currentMode');
    if (theme == 'dark')
      provider.currentMode = ThemeMode.dark;
    else
      provider.currentMode = ThemeMode.light;

    provider.pushNotifications = prefs.getBool('Push Notification') ?? false;
    provider.queryAlerts = prefs.getBool('Query Notification') ?? true;
    provider.schemaChanges =
        prefs.getBool('schemaChanges Notification') ?? false;

    return provider;
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

  bool get isDark => currentMode == ThemeMode.dark;

  Future<void> updateAvatar({File? file, Uint8List? bytes}) async {
    if (file == null && bytes == null) return;

    if (!kIsWeb && file != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final newFile = await file.copy(
        '${appDir.path}/${file.uri.pathSegments.last}',
      );
      avatarFile = newFile;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('avatar_path', newFile.path);
    }

    if (kIsWeb && bytes != null) {
      webAvatarBytes = bytes;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('web_avatar', base64Encode(bytes));
    }

    notifyListeners();
  }

  Future<void> loadAvatar() async {
    final prefs = await SharedPreferences.getInstance();

    if (kIsWeb) {
      final base64String = prefs.getString('web_avatar');
      if (base64String != null) {
        webAvatarBytes = base64Decode(base64String);
      }
    } else {
      final path = prefs.getString('avatar_path');
      if (path != null) {
        avatarFile = File(path);
      }
    }

    notifyListeners();
  }

  Future<void> loadSavedAvatar() async {
    final prefs = await SharedPreferences.getInstance();

    if (kIsWeb) {
      final bytes = prefs.getStringList('web_avatar_bytes');
      if (bytes != null && bytes.isNotEmpty) {
        webAvatarBytes = Uint8List.fromList(bytes.map(int.parse).toList());
      }
    } else {
      final path = prefs.getString('avatar_path');
      if (path != null && File(path).existsSync()) {
        avatarFile = File(path);
      }
    }

    notifyListeners();
  }

  Future<void> setPushNotifications(bool value) async {
    if (pushNotifications == value) return;
    pushNotifications = value;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Push Notification', pushNotifications);

    notifyListeners();
  }

  Future<void> setQueryAlerts(bool value) async {
    if (queryAlerts == value) return;

    queryAlerts = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Query Notification', queryAlerts);

    notifyListeners();
  }

  Future<void> setSchemaChanges(bool value) async {
    if (schemaChanges == value) return;

    schemaChanges = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('schemaChanges Notification', schemaChanges);

    notifyListeners();
  }
}
