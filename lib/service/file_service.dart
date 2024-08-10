import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class FileService {
  Future<void> saveImage(File imageFile, String fileName) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String filePath = path.join(appDir.path, fileName);
      await imageFile.copy(filePath);
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

  Future<Uint8List?> getImageFromPath(String fileName) async {
    try {
      final File file = await getImageFileFromDocumentsDirectory(fileName);
      if (await file.exists()) {
        return await file.readAsBytes();
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

  Future<String> getFullPathOfImage(String fileName) async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String filePath = path.join(appDir.path, fileName);
    return filePath;
  }
}
