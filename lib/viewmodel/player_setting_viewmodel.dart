import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/session.dart';
import 'package:family_game_score/viewmodel/provider/player_provider.dart';
import 'package:family_game_score/viewmodel/provider/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PlayerSettingViewModel {
  final Ref ref;

  PlayerSettingViewModel(this.ref);

  AsyncValue<List<Player>> get players => ref.watch(playerProvider);
  AsyncValue<Session?> get session => ref.watch(sessionProvider);

  VoidCallback? getFloatingActionButtonCallback(
      WidgetRef ref, VoidCallback onShowAddPlayerDialog) {
    if (players.hasValue && session.hasValue && session.value == null) {
      return onShowAddPlayerDialog;
    }
    return null;
  }

  Color? getFloatingActionButtonColor() {
    return players.hasValue && session.hasValue && session.value == null
        ? null
        : Colors.grey[300];
  }
}

final settingViewModelProvider = Provider((ref) => PlayerSettingViewModel(ref));
