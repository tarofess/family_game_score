import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class FileService {
  Future<void> saveImage(File imageFile, String fileName) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String filePath = path.join(appDir.path, fileName);

      // Androidの場合同じファイルパスに保存しようとすると画像が0KBで保存されるため
      // 既に同じファイルパスに画像が保存されている場合は保存処理をスキップする
      if (filePath == imageFile.path) {
        return;
      }

      await imageFile.copy(filePath);
    } catch (e) {
      throw Exception('写真の保存中にエラーが発生しました。');
    }
  }

  Future<void> deleteImage(String? fileName) async {
    try {
      if (await isImageExists(fileName)) {
        final File file = await getImageFromDocumentsDirectory(fileName);
        await file.delete();
      }
    } catch (e) {
      throw Exception('写真の削除中にエラーが発生しました。');
    }
  }

  Future<FileImage?> getFileImageFromPath(String fileName) async {
    try {
      final File file = await getImageFromDocumentsDirectory(fileName);
      if (await file.exists()) {
        return FileImage(File(file.path));
      }
      return null;
    } catch (e) {
      throw Exception('写真の取得中にエラーが発生しました。');
    }
  }

  Future<bool> isImageExists(String? fileName) async {
    final File file = await getImageFromDocumentsDirectory(fileName);
    return await file.exists();
  }

  Future<File> getImageFromDocumentsDirectory(String? fileName) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String filePath = path.join(appDir.path, fileName);
      final File file = File(filePath);
      return file;
    } catch (e) {
      throw Exception('写真の取得中にエラーが発生しました。');
    }
  }

  Future<String> getFullPathOfImage(String fileName) async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String filePath = path.join(appDir.path, fileName);
    return filePath;
  }

  Future<void> clearCache(String fileName) async {
    try {
      final filePath = await getFullPathOfImage(fileName);
      final image = FileImage(File(filePath));
      imageCache.evict(image);
    } catch (e) {
      throw Exception('キャッシュのクリア中にエラーが発生しました。');
    }
  }
}
