import 'dart:io';
import 'package:family_game_score/model/entity/player.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class FileService {
  Future<String> saveImage(File imageFile, Player? player) async {
    try {
      if (await isImageExists(player?.image)) {
        return player!.image;
      }

      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String filePath = path.join(appDir.path, fileName);
      await imageFile.copy(filePath);
      return fileName;
    } catch (e) {
      throw Exception('画像の保存中にエラーが発生しました');
    }
  }

  Future<void> deleteImage(String? fileName) async {
    try {
      if (await isImageExists(fileName)) {
        final File file = await getImageFileFromDocumentsDirectory(fileName);
        await file.delete();
      }
    } catch (e) {
      throw Exception('画像の削除中にエラーが発生しました');
    }
  }

  Future<Image?> getImageFromPath(String fileName) async {
    try {
      final File file = await getImageFileFromDocumentsDirectory(fileName);
      if (await file.exists()) {
        return Image.file(file);
      }
      return null;
    } catch (e) {
      throw Exception('画像の取得中にエラーが発生しました');
    }
  }

  Future<bool> isImageExists(String? fileName) async {
    try {
      final File file = await getImageFileFromDocumentsDirectory(fileName);
      return await file.exists();
    } catch (e) {
      throw Exception('画像の存在確認中にエラーが発生しました');
    }
  }

  Future<File> getImageFileFromDocumentsDirectory(String? fileName) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String filePath = path.join(appDir.path, fileName);
      final File file = File(filePath);
      return file;
    } catch (e) {
      throw Exception('画像の取得中にエラーが発生しました');
    }
  }
}
