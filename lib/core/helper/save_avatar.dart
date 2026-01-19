import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveAvatar {
  static Future<void> saveAvatar({File? file, Uint8List? bytes}) async {
    final prefs = await SharedPreferences.getInstance();
    if (kIsWeb && bytes != null) {
      final stringList = bytes.map((e) => e.toString()).toList();
      await prefs.setStringList('web_avatar_bytes', stringList);
    } else if (!kIsWeb && file != null) {
      await prefs.setString('avatar_path', file.path);
    }
  }
}
