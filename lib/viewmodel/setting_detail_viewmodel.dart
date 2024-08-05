import 'dart:io';

import 'package:family_game_score/main.dart';
import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/result_history.dart';
import 'package:family_game_score/service/camera_service.dart';
import 'package:family_game_score/viewmodel/provider/player_provider.dart';
import 'package:family_game_score/viewmodel/provider/result_history_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingDetailViewModel {
  Ref ref;
  final CameraService cameraService = getIt<CameraService>();
  String? imagePath;

  SettingDetailViewModel(this.ref);

  AsyncValue<List<ResultHistory>> get resultHistories =>
      ref.watch(resultHistoryProvider);

  bool isEmptyBothImageAndName(String playerName, FileImage? playerImage) {
    return playerName.isEmpty && playerImage == null ? true : false;
  }

  bool isImageAlreadySet(FileImage? playerImage) {
    return playerImage == null ? false : true;
  }

  bool hasImage(FileImage? playerImage) {
    return playerImage != null ? true : false;
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
      String name, FileImage? playerImage, WidgetRef ref) async {
    try {
      if (formKey.currentState!.validate()) {
        final fileName = await saveImage(player, name, playerImage, ref);
        await saveName(player, name, fileName, ref);
        ref.invalidate(resultHistoryProvider);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> saveImage(Player? player, String name, FileImage? playerImage,
      WidgetRef ref) async {
    if (playerImage == null || imagePath == null) {
      return player?.image ?? '';
    }

    try {
      return await cameraService.saveImage(File(playerImage.file.path));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveName(
      Player? player, String name, String? fileName, WidgetRef ref) async {
    try {
      if (player == null) {
        await ref.read(playerProvider.notifier).addPlayer(name, fileName ?? '');
      } else {
        await ref
            .read(playerProvider.notifier)
            .updatePlayer(player.copyWith(name: name, image: fileName ?? ''));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> takePicture(ValueNotifier<FileImage?> playerImage) async {
    try {
      final String? path = await cameraService.takePicture();
      if (path != null) {
        imagePath = path;
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
        imagePath = path;
        playerImage.value = FileImage(File(path));
      }
    } catch (e) {
      rethrow;
    }
  }

  void deleteImage(ValueNotifier<FileImage?> playerImage) {
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
