import 'dart:io';
import 'package:flutter/material.dart';

abstract class IFileService {
  Future<void> saveImage(File imageFile, String fileName);
  Future<FileImage?> getFileImageFromPath(String fileName);
  Future<File> getFileFromDocumentsDirectory(String? fileName);
  Future<String> getFullPathOfImage(String fileName);
  Future<void> deleteImage(String? fileName);
  Future<bool> isImageExists(String? fileName);
  Future<void> clearCache(String fileName);
}
