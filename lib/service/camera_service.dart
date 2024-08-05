import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class CameraService {
  final ImagePicker picker = ImagePicker();

  Future<String?> takePicture() async {
    try {
      final XFile? photo = await picker.pickImage(source: ImageSource.camera);
      return photo?.path;
    } catch (e) {
      throw Exception('画像の撮影中にエラーが発生しました');
    }
  }

  Future<String?> pickImageFromGallery() async {
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      return image?.path;
    } catch (e) {
      throw Exception('画像の選択中にエラーが発生しました');
    }
  }

  Future<String> saveImage(File imageFile) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String filePath = path.join(appDir.path, fileName);
      await imageFile.copy(filePath);
      return fileName;
    } catch (e) {
      throw Exception('画像の保存中にエラーが発生しました');
    }
  }

  Future<Image?> getImageFromPath(String fileName) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String filePath = path.join(appDir.path, fileName);
      final File file = File(filePath);

      if (await file.exists()) {
        return Image.file(file);
      }
      return null;
    } catch (e) {
      throw Exception('画像の取得中にエラーが発生しました');
    }
  }
}
