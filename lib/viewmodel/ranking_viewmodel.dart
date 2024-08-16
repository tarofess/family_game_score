import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/result.dart';
import 'package:family_game_score/model/entity/session.dart';
import 'package:family_game_score/view/widget/list_card/result_list_card.dart';
import 'package:family_game_score/view/widget/sakura_animation.dart';
import 'package:family_game_score/viewmodel/provider/player_provider.dart';
import 'package:family_game_score/viewmodel/provider/result_provider.dart';
import 'package:family_game_score/viewmodel/provider/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';

class RankingViewModel {
  final Ref ref;

  RankingViewModel(this.ref);

  AsyncValue<List<Player>> get activePlayers => ref.watch(playerProvider);
  AsyncValue<List<Result>> get results => ref.watch(resultProvider);
  AsyncValue<Session?> get session => ref.watch(sessionProvider);

  bool isFinishedGame() {
    return session.value?.endTime == null ? false : true;
  }

  Future<bool> shouldShowInAppReview(InAppReview inAppReview) async {
    return session.value?.id == 3 &&
            session.value?.endTime != null &&
            await inAppReview.isAvailable()
        ? true
        : false;
  }

  Widget getAppBarTitle() {
    return isFinishedGame() ? const Text('結果発表') : const Text('現在の順位');
  }

  Widget getIconButton(VoidCallback onIconButtonPressed) {
    return isFinishedGame()
        ? IconButton(
            icon: const Icon(Icons.home),
            onPressed: onIconButtonPressed,
          )
        : const SizedBox();
  }

  Widget getSakuraAnimation() {
    return isFinishedGame()
        ? const Positioned.fill(
            child: IgnorePointer(
              child: SakuraAnimation(),
            ),
          )
        : const SizedBox();
  }

  Widget getResultListCard(
      int index, List<Result> results, List<Player> players) {
    final result = results[index];
    final player = players.firstWhere((p) => p.id == result.playerId);
    return ResultListCard(player: player, result: result);
  }
}

final rankingViewModelProvider = Provider((ref) => RankingViewModel(ref));
