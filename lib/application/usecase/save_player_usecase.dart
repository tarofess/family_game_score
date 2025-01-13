import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:family_game_score/application/interface/file_service.dart';
import 'package:family_game_score/application/state/player_notifier.dart';
import 'package:family_game_score/application/state/result_history_notifier.dart';
import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/domain/result.dart';

class SavePlayerUsecase {
  final PlayerNotifier _playerNotifier;
  final IFileService _fileService;

  SavePlayerUsecase(this._playerNotifier, this._fileService);

  Future<Result> execute(
    WidgetRef ref,
    Player? player,
    String playerName,
    FileImage? playerImage,
  ) async {
    try {
      await savePlayer(ref, player, playerName, playerImage);
      return const Success(null);
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }

  Future<void> savePlayer(
    WidgetRef ref,
    Player? player,
    String playerName,
    FileImage? playerImage,
  ) async {
    final fileName = await saveName(player, playerName, playerImage);
    try {
      await saveImage(player, fileName, playerImage);
    } catch (e) {
      rethrow;
    }
    ref.invalidate(resultHistoryNotifierProvider);
  }

  Future<String> saveName(
    Player? player,
    String playerName,
    FileImage? playerImage,
  ) async {
    final fileName = await getFileName(player, playerImage);
    player == null
        ? await _playerNotifier.addPlayer(playerName, fileName)
        : await _playerNotifier.updatePlayer(
            player.copyWith(name: playerName, image: fileName),
          );

    return fileName;
  }

  Future<String> getFileName(Player? player, FileImage? playerImage) async {
    if (playerImage == null) {
      return '';
    }

    if (player == null) {
      final playerMaxId = await _playerNotifier.getPlayersMaxID() + 1;
      return '$playerMaxId.jpg';
    } else {
      return '${player.id}.jpg';
    }
  }

  Future<void> saveImage(
    Player? player,
    String fileName,
    FileImage? playerImage,
  ) async {
    if (playerImage == null) {
      await _fileService.deleteImage(player?.image);
      return;
    }

    await _fileService.saveImage(File(playerImage.file.path), fileName);
    await _fileService.clearCache(fileName);
  }
}
