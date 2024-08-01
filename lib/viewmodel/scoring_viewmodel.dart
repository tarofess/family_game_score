import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/result.dart';
import 'package:family_game_score/model/entity/session.dart';
import 'package:family_game_score/viewmodel/provider/player_provider.dart';
import 'package:family_game_score/viewmodel/provider/result_provider.dart';
import 'package:family_game_score/viewmodel/provider/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ScoringViewModel {
  final Ref ref;

  ScoringViewModel(this.ref);

  AsyncValue<List<Player>> get players => ref.watch(playerProvider);
  AsyncValue<Session?> get session => ref.watch(sessionProvider);
  AsyncValue<List<Result>> get results => ref.watch(resultProvider);

  Widget getAppBarTitle() {
    return Text(
        '${session.value == null ? '1' : session.value!.round.toString()}回戦');
  }

  VoidCallback? getExitButtonCallback(VoidCallback onShowFinishGameDialog) {
    if (results.hasValue && session.value != null) {
      try {
        return onShowFinishGameDialog;
      } catch (e) {
        throw Exception('予期せぬエラーがは発生しました');
      }
    }
    return null;
  }

  VoidCallback? getCheckButtonCallback(
      VoidCallback onShowMoveToNextRoundDialog) {
    if (results.hasValue) {
      try {
        return onShowMoveToNextRoundDialog;
      } catch (e) {
        throw Exception('予期せぬエラーがは発生しました');
      }
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
