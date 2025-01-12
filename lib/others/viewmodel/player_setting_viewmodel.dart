import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/domain/entity/session.dart';
import 'package:family_game_score/application/state/player_provider.dart';
import 'package:family_game_score/application/state/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PlayerSettingViewModel {
  final Ref ref;

  PlayerSettingViewModel(this.ref);

  AsyncValue<List<Player>> get players => ref.watch(playerProvider);
  AsyncValue<Session?> get session => ref.watch(sessionProvider);

  bool isSessionNull() {
    return session.value == null;
  }

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
