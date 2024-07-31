import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/result_history.dart';
import 'package:family_game_score/viewmodel/provider/result_history_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PlayerDetailViewmodel {
  Ref ref;

  PlayerDetailViewmodel(this.ref);

  AsyncValue<List<ResultHistory>> get resultHistories =>
      ref.watch(resultHistoryProvider);

  bool isEmptyBothImageAndName(String playerName, String? imagePath) {
    return playerName.isEmpty && imagePath == null ? true : false;
  }

  bool isImageAlreadySet(Player? player) {
    return player == null || player.image.isEmpty ? false : true;
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
}

final playerDetailViewmodelProvider = Provider<PlayerDetailViewmodel>((ref) {
  return PlayerDetailViewmodel(ref);
});
