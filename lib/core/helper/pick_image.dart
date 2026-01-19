import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class PickImageResult {
  final File? file;
  final Uint8List? bytes;

  PickImageResult({this.file, this.bytes});
}

class PickImage {
  static final ImagePicker _picker = ImagePicker();

  static Future<PickImageResult?> pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return null;

    if (kIsWeb) {
      final bytes = await image.readAsBytes();
      return PickImageResult(bytes: bytes);
    } else {
      return PickImageResult(file: File(image.path));
    }
  }
}
