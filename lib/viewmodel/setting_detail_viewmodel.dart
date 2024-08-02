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

  SettingDetailViewModel(this.ref);

  AsyncValue<List<ResultHistory>> get resultHistories =>
      ref.watch(resultHistoryProvider);

  bool isEmptyBothImageAndName(String playerName, String? imagePath) {
    return playerName.isEmpty && imagePath == null ? true : false;
  }

  bool isImageAlreadySet(String? imagePath) {
    return imagePath == null || imagePath.isEmpty ? false : true;
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

  Future<bool> savePlayer(Player? player, GlobalKey<FormState> formKey,
      String name, String? imagePath, WidgetRef ref) async {
    try {
      if (formKey.currentState!.validate()) {
        await saveImage(player, name, imagePath, ref);
        await saveName(player, name, imagePath, ref);
        ref.invalidate(resultHistoryProvider);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveImage(
      Player? player, String name, String? imagePath, WidgetRef ref) async {
    if (imagePath == null) {
      return;
    }

    if (player?.image == imagePath) {
      return;
    }

    try {
      await cameraService.saveImage(File(imagePath));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveName(
      Player? player, String name, String? imagePath, WidgetRef ref) async {
    try {
      if (player == null) {
        await ref
            .read(playerProvider.notifier)
            .addPlayer(name, imagePath ?? '');
      } else {
        await ref
            .read(playerProvider.notifier)
            .updatePlayer(player.copyWith(name: name, image: imagePath ?? ''));
      }
    } catch (e) {
      rethrow;
    }
  }

  void deleteImage(ValueNotifier<String?> imagePath) {
    imagePath.value = null;
  }

  Future<void> takePicture(ValueNotifier<String?> imagePath) async {
    try {
      final String? path = await cameraService.takePictureAndSave();
      if (path != null) {
        imagePath.value = path;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> pickImageFromGallery(ValueNotifier<String?> imagePath) async {
    try {
      final String? path = await cameraService.pickImageFromGalleryAndSave();
      if (path != null) {
        imagePath.value = path;
      }
    } catch (e) {
      rethrow;
    }
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
