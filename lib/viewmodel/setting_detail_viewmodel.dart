import 'dart:io';

import 'package:family_game_score/main.dart';
import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/result_history.dart';
import 'package:family_game_score/service/camera_service.dart';
import 'package:family_game_score/service/file_service.dart';
import 'package:family_game_score/viewmodel/provider/player_provider.dart';
import 'package:family_game_score/viewmodel/provider/result_history_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingDetailViewModel {
  Ref ref;
  final CameraService cameraService = getIt<CameraService>();
  final FileService fileService = getIt<FileService>();

  SettingDetailViewModel(this.ref);

  AsyncValue<List<ResultHistory>> get resultHistories =>
      ref.watch(resultHistoryProvider);

  bool isEmptyBothImageAndName(String playerName, FileImage? playerImage) {
    return playerName.isEmpty && playerImage == null ? true : false;
  }

  bool hasAlreadyImage(FileImage? playerImage) {
    return playerImage == null ? false : true;
  }

  int getTotalScore(Player? player) {
    int totalScore = 0;

    if (player == null) return totalScore;

    for (ResultHistory resultHistory in resultHistories.value ?? []) {
      if (resultHistory.player.id == player.id) {
        totalScore += resultHistory.result.score;
      }
    }

    return totalScore;
  }

  Future<bool> savePlayer(GlobalKey<FormState> formKey, Player? player,
      String playerName, FileImage? playerImage, WidgetRef ref) async {
    try {
      if (formKey.currentState!.validate()) {
        final fileName = await saveImage(player, playerImage);
        await saveName(player, playerName, fileName, ref);
        ref.invalidate(resultHistoryProvider);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> saveImage(Player? player, FileImage? playerImage) async {
    if (playerImage == null) {
      await fileService.deleteImage(player?.image);
      return '';
    }

    try {
      return await fileService.saveImage(File(playerImage.file.path), player);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveName(Player? player, String playerName, String? fileName,
      WidgetRef ref) async {
    try {
      if (player == null) {
        await ref
            .read(playerProvider.notifier)
            .addPlayer(playerName, fileName ?? '');
      } else {
        await ref.read(playerProvider.notifier).updatePlayer(
            player.copyWith(name: playerName, image: fileName ?? ''));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> handleCameraAction(
    ValueNotifier<FileImage?> playerImage,
    Function(String) showPermissionDeniedDialog,
    Function(String, VoidCallback) showPermissionPermanentlyDeniedDialog,
    Function(dynamic) showErrorDialog,
    VoidCallback closeDialog,
  ) async {
    try {
      final status = await Permission.camera.request();
      switch (status) {
        case PermissionStatus.granted:
          await takePicture(playerImage);
          closeDialog();
          break;
        case PermissionStatus.denied:
          await showPermissionDeniedDialog('カメラ権限が許可されていないので写真を撮影できません');
          closeDialog();
          break;
        case PermissionStatus.permanentlyDenied:
          await showPermissionPermanentlyDeniedDialog(
            'カメラ権限が永久に拒否されたため写真を撮影できません\n設定からカメラ権限を許可してください',
            openAppSettings,
          );
          closeDialog();
          break;
        default:
          break;
      }
    } catch (e) {
      throw Exception('写真の撮影で予期せぬエラーが発生しました');
    }
  }

  Future<void> handleGalleryAction(
    ValueNotifier<FileImage?> playerImage,
    Function(String) showPermissionDeniedDialog,
    Function(String, VoidCallback) showPermissionPermanentlyDeniedDialog,
    Function(dynamic) showErrorDialog,
    VoidCallback closeDialog,
  ) async {
    try {
      final status = await Permission.photos.request();
      switch (status) {
        case PermissionStatus.granted:
        case PermissionStatus.limited:
          await pickImageFromGallery(playerImage);
          closeDialog();
          break;
        case PermissionStatus.denied:
          await showPermissionDeniedDialog(
              'フォトライブラリへのアクセスが許可されていないので写真を選択できません');
          closeDialog();
          break;
        case PermissionStatus.permanentlyDenied:
          await showPermissionPermanentlyDeniedDialog(
            'フォトライブラリへのアクセスが永久に拒否されたため写真を選択できません\n設定からアクセス権限を許可してください',
            openAppSettings,
          );
          closeDialog();
          break;
        case PermissionStatus.restricted:
          await showPermissionDeniedDialog(
              'フォトライブラリへのアクセスが制限されているので写真を選択できません');
          closeDialog();
          break;
        default:
          break;
      }
    } catch (e) {
      throw Exception('写真の選択で予期せぬエラーが発生しました');
    }
  }

  Future<void> takePicture(ValueNotifier<FileImage?> playerImage) async {
    try {
      final String? path = await cameraService.takePicture();
      if (path != null) {
        playerImage.value = FileImage(File(path));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> pickImageFromGallery(
      ValueNotifier<FileImage?> playerImage) async {
    try {
      final String? path = await cameraService.pickImageFromGallery();
      if (path != null) {
        playerImage.value = FileImage(File(path));
      }
    } catch (e) {
      rethrow;
    }
  }

  void deleteImageFromImageCircle(ValueNotifier<FileImage?> playerImage) {
    playerImage.value = null;
  }

  String? handleNameValidation(String? value) {
    if (value == null || value.isEmpty) {
      return '名前を入力してください';
    }
    return null;
  }
}

final playerDetailViewmodelProvider = Provider<SettingDetailViewModel>((ref) {
  return SettingDetailViewModel(ref);
});
