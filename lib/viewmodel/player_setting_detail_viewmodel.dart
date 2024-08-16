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

class PlayerSettingDetailViewModel {
  Ref ref;
  final CameraService cameraService = getIt<CameraService>();
  final FileService fileService = getIt<FileService>();

  PlayerSettingDetailViewModel(this.ref);

  AsyncValue<List<ResultHistory>> get resultHistories =>
      ref.watch(resultHistoryProvider);

  bool isPlayerNull(Player? player) {
    return player == null ? true : false;
  }

  bool isEmptyBothImageAndName(String playerName, FileImage? playerImage) {
    return playerName.isEmpty && playerImage == null ? true : false;
  }

  bool hasAlreadyImage(FileImage? playerImage) {
    return playerImage == null ? false : true;
  }

  String getAppBarTitle(Player? player) {
    return isPlayerNull(player) ? 'プレイヤーの追加' : 'プレイヤーの詳細';
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
    if (formKey.currentState!.validate()) {
      final fileName = await saveName(player, playerName, playerImage, ref);
      try {
        await saveImage(player, fileName, playerImage);
      } catch (e) {
        rollbackSaveName(player, ref);
        rethrow;
      }
      ref.invalidate(resultHistoryProvider);
      return true;
    }

    return false;
  }

  Future<String> saveName(Player? player, String playerName,
      FileImage? playerImage, WidgetRef ref) async {
    final fileName = await getFileName(player, playerImage);
    player == null
        ? await ref.read(playerProvider.notifier).addPlayer(
              playerName,
              fileName,
            )
        : await ref.read(playerProvider.notifier).updatePlayer(
              player.copyWith(name: playerName, image: fileName),
            );

    return fileName;
  }

  Future<String> getFileName(Player? player, FileImage? playerImage) async {
    if (playerImage == null) {
      return '';
    }

    if (player == null) {
      final playerMaxId =
          await ref.read(playerProvider.notifier).getPlayersMaxID() + 1;
      return '$playerMaxId.jpg';
    } else {
      return '${player.id}.jpg';
    }
  }

  Future<void> saveImage(
      Player? player, String fileName, FileImage? playerImage) async {
    if (playerImage == null) {
      await fileService.deleteImage(player?.image);
      return;
    }

    await fileService.saveImage(File(playerImage.file.path), fileName);
    await fileService.clearCache(fileName);
  }

  Future<void> rollbackSaveName(Player? player, WidgetRef ref) async {
    player == null
        ? await ref
            .read(playerProvider.notifier)
            .deletePlayer(ref.read(playerProvider).value!.last)
        : await ref.read(playerProvider.notifier).updatePlayer(player);
  }

  Future<void> handleCameraAction(
    ValueNotifier<FileImage?> playerImage,
    Function(String) showPermissionDeniedDialog,
    Function(String) showPermissionPermanentlyDeniedDialog,
    VoidCallback closeDialog,
  ) async {
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
            'カメラ権限が永久に拒否されたため写真を撮影できません\n設定からカメラ権限を許可してください');
        closeDialog();
        break;
      default:
        break;
    }
  }

  Future<void> handleGalleryAction(
    ValueNotifier<FileImage?> playerImage,
    Function(String) showPermissionDeniedDialog,
    Function(String, VoidCallback) showPermissionPermanentlyDeniedDialog,
    VoidCallback closeDialog,
  ) async {
    final status = await Permission.photos.request();
    switch (status) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
        await pickImageFromGallery(playerImage);
        closeDialog();
        break;
      case PermissionStatus.denied:
        await showPermissionDeniedDialog('フォトライブラリへのアクセスが許可されていないので写真を選択できません');
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
        await showPermissionDeniedDialog('フォトライブラリへのアクセスが制限されているので写真を選択できません');
        closeDialog();
        break;
      default:
        break;
    }
  }

  Future<void> takePicture(ValueNotifier<FileImage?> playerImage) async {
    final String? path = await cameraService.takePicture();
    if (path != null) {
      playerImage.value = FileImage(File(path));
    }
  }

  Future<void> pickImageFromGallery(
      ValueNotifier<FileImage?> playerImage) async {
    final String? path = await cameraService.pickImageFromGallery();
    if (path != null) {
      playerImage.value = FileImage(File(path));
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

  void setPlayerImagePath(
      Player? player, ValueNotifier<FileImage?> playerImage) async {
    if (player?.image != null && player!.image.isNotEmpty) {
      final fullPath = await fileService.getFullPathOfImage(player.image);
      playerImage.value = FileImage(File(fullPath));
    } else {
      playerImage.value = null;
    }
  }
}

final playerDetailViewmodelProvider =
    Provider<PlayerSettingDetailViewModel>((ref) {
  return PlayerSettingDetailViewModel(ref);
});
