import 'package:family_game_score/application/interface/file_service.dart';
import 'package:flutter/material.dart';

class FileImageGetUsecase {
  final IFileService _fileService;

  FileImageGetUsecase(this._fileService);

  Future<FileImage?> execute(String? fileName) async {
    try {
      if (fileName == null) return null;

      final fileImage = _fileService.getFileImageFromPath(fileName);
      return fileImage;
    } catch (e) {
      throw Exception('写真の取得中にエラーが発生しました。');
    }
  }
}
