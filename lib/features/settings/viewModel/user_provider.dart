import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dbaas_project/core/models/user/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;
  String _displayName = 'User';
   File? _avatarFile;
   Uint8List? _webAvatarBytes;

  User? get currentUser => _currentUser;
  String get displayName => _displayName;
  File? get avatarFile => _avatarFile;
  Uint8List? get webAvatarBytes => _webAvatarBytes;
  String? get _userId => _currentUser?.data?.id?.toString();
  String _key(String base) => _userId != null ? '${base}_$_userId' : base;





  static Future<UserProvider> init() async {
    final prefs = await SharedPreferences.getInstance();
    UserProvider userProvider = UserProvider();

    final userJson = prefs.getString('user_data');
    if (userJson != null) {
      userProvider._currentUser = User.fromJson(jsonDecode(userJson));

      userProvider._displayName =
        prefs.getString('display_name') ??
          (userProvider._currentUser?.data?.email?.split('@').first ?? 'User');
    }
    await userProvider.loadAvatar();
    return userProvider;
  }
void setUser(User user) async {
  _currentUser = user;
  final prefs = await SharedPreferences.getInstance();

  String? savedName = prefs.getString('display_name');

  String? incomingName = user.data?.name;

  if (incomingName == null || incomingName.isEmpty) {
    if (savedName != null && savedName.isNotEmpty) {
      _displayName = savedName;
      _currentUser!.data!.name = savedName; 
    } else {
      _displayName = user.data?.email?.split('@').first ?? 'User';
    }
  } else {
    _displayName = incomingName;
  }

  await _saveUserToPrefs(_currentUser!);
  await _saveDisplayName(); 
  await loadAvatar(); 
  
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
    await prefs.setString('user_data', jsonEncode(user.toJsonShowen()));
  }

  Future<void> _saveDisplayName() async {

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('display_name', _displayName);
  }

  Future<void> clearUser() async {
    _currentUser = null;
    _displayName = 'User';
    _avatarFile = null;
    _webAvatarBytes = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('display_name');
    await prefs.remove('user_data');

    notifyListeners();
  }



Future<void> loadAvatar() async {
    if (_userId == null) return;
    final prefs = await SharedPreferences.getInstance();

    if (kIsWeb) {
      final base64String = prefs.getString(_key('web_avatar'));
      _webAvatarBytes = base64String != null ? base64Decode(base64String) : null;
    } else {
      final path = prefs.getString(_key('avatar_path'));
      if (path != null && File(path).existsSync()) {
        _avatarFile = File(path);
      } else {
        _avatarFile = null;
      }
    }
    notifyListeners();
  }
Future<void> updateAvatar({File? file, Uint8List? bytes}) async {
    if (_userId == null) return;
    final prefs = await SharedPreferences.getInstance();

    if (!kIsWeb && file != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = file.uri.pathSegments.last;
   
      final newFile = await file.copy('${appDir.path}/avatar_${_userId}_$fileName');
      
      _avatarFile = newFile;
      await prefs.setString(_key('avatar_path'), newFile.path);
    }

    if (kIsWeb && bytes != null) {
      _webAvatarBytes = bytes;
      await prefs.setString(_key('web_avatar'), base64Encode(bytes));
    }

    notifyListeners();
  }
}
