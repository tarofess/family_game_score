import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:family_game_score/presentation/dialog/confirmation_dialog.dart';
import 'package:family_game_score/presentation/dialog/message_dialog.dart';

class PermissionHandlerService {
  static Future<bool> requestCameraPermission(BuildContext context) async {
    final status = await Permission.camera.request();
    switch (status) {
      case PermissionStatus.granted:
        return true;
      case PermissionStatus.denied:
        if (context.mounted) {
          await showMessageDialog(
            context,
            'カメラ撮影が許可されていないので写真を撮影できません。',
          );
        }
        return false;
      case PermissionStatus.permanentlyDenied:
        if (context.mounted) {
          final result = await showConfimationDialog(
            context: context,
            title: '権限エラー',
            content: 'カメラ撮影が拒否されているため写真を撮影できません。\n設定画面でカメラ撮影を許可しますか？',
          );
          if (result) {
            openAppSettings();
          }
        }
        return false;
      default:
        return false;
    }
  }

  static Future<bool> requestStoragePermission(BuildContext context) async {
    final status = Platform.isIOS
        ? await Permission.photos.request()
        : await Permission.storage.request();
    switch (status) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
        return true;
      case PermissionStatus.denied:
        if (context.mounted) {
          await showMessageDialog(
            context,
            'カメラ撮影が許可されていないので写真を撮影できません。',
          );
        }
        return false;
      case PermissionStatus.permanentlyDenied:
        if (context.mounted) {
          final result = await showConfimationDialog(
            context: context,
            title: '権限エラー',
            content: 'カメラ撮影が拒否されているため写真を撮影できません。\n設定画面でカメラ撮影を許可しますか？',
          );
          if (result) {
            openAppSettings();
          }
        }
        return false;
      case PermissionStatus.restricted:
        if (context.mounted) {
          await showMessageDialog(
            context,
            'カメラ撮影が制限されているので写真を撮影できません。',
          );
        }
        return false;
      default:
        return false;
    }
  }
}
