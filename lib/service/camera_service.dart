import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class CameraService {
  final ImagePicker _picker = ImagePicker();

  Future<String?> takePictureAndSave() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      return photo?.path;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> pickImageFromGalleryAndSave() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      return image?.path;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveImage(File imageFile) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String filePath = path.join(appDir.path, fileName);
      await imageFile.copy(filePath);
    } catch (e) {
      rethrow;
    }
  }

  Future<Image?> getImageFromPath(String imagePath) async {
    try {
      final File file = File(imagePath);
      if (await file.exists()) {
        return Image.file(file);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}