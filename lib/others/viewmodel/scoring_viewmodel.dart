import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/domain/entity/result.dart';
import 'package:family_game_score/domain/entity/session.dart';
import 'package:family_game_score/application/state/player_provider.dart';
import 'package:family_game_score/application/state/result_provider.dart';
import 'package:family_game_score/application/state/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ScoringViewModel {
  final Ref ref;

  ScoringViewModel(this.ref);

  AsyncValue<List<Player>> get activePlayers => ref.watch(playerProvider);
  AsyncValue<Session?> get session => ref.watch(sessionProvider);
  AsyncValue<List<Result>> get results => ref.watch(resultProvider);

  String getAppBarTitle() {
    return '${session.value == null ? '1' : session.value!.round.toString()}回戦';
  }

  VoidCallback? getExitButtonCallback(VoidCallback onShowFinishGameDialog) {
    if (results.hasValue && session.value != null) {
      return onShowFinishGameDialog;
    }
    return null;
  }

  VoidCallback? getCheckButtonCallback(
      VoidCallback onShowMoveToNextRoundDialog) {
    if (results.hasValue) {
      return onShowMoveToNextRoundDialog;
    }
    return null;
  }

  VoidCallback? getFloatingActionButtonCallback(
      VoidCallback onShowRankingView) {
    if (session.value != null) {
      return onShowRankingView;
    }
    return null;
  }

  Color? getFloatingActionButtonColor() {
    return session.value == null ? Colors.grey[300] : null;
  }
}

final scoringViewModelProvider = Provider((ref) => ScoringViewModel(ref));