import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:family_game_score/application/state/result_history_notifier.dart';
import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/domain/entity/result_history.dart';

class GetTotalScoreUsecase {
  final Ref _ref;

  GetTotalScoreUsecase(this._ref);

  int execute(Player? player) {
    final resultHistories = _ref.watch(resultHistoryNotifierProvider).value;

    int totalScore = 0;

    if (player == null) return totalScore;

    for (ResultHistory resultHistory in resultHistories ?? []) {
      if (resultHistory.player.id == player.id) {
        totalScore += resultHistory.result.score;
      }
    }

    return totalScore;
  }
}
