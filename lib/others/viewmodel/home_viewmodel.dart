import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/domain/entity/session.dart';
import 'package:family_game_score/application/state/player_provider.dart';
import 'package:family_game_score/application/state/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeViewModel {
  final Ref ref;

  HomeViewModel(this.ref);

  AsyncValue<List<Player>> get players => ref.watch(playerProvider);
  AsyncValue<Session?> get session => ref.watch(sessionProvider);

  VoidCallback handleButtonPress(
      {required VoidCallback onStartGame,
      required VoidCallback onShowSnackbar}) {
    return canStartGame() ? onStartGame : onShowSnackbar;
  }

  bool canStartGame() =>
      players.value!.where((player) => player.status == 1).length >= 2;

  String getButtonText() {
    return session.value == null ? 'ゲームスタート！' : 'ゲーム再開！';
  }

  List<Color> getGradientColors() {
    return canStartGame()
        ? const [
            Color.fromARGB(255, 255, 194, 102),
            Color.fromARGB(255, 255, 101, 90)
          ]
        : const [
            Color.fromARGB(255, 223, 223, 223),
            Color.fromARGB(255, 109, 109, 109)
          ];
  }
}

final homeViewModelProvider = Provider((ref) => HomeViewModel(ref));
