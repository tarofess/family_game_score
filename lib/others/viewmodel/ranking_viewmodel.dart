import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/domain/entity/result.dart';
import 'package:family_game_score/domain/entity/session.dart';
import 'package:family_game_score/presentation/widget/list_card/result_list_card.dart';
import 'package:family_game_score/presentation/widget/sakura_animation.dart';
import 'package:family_game_score/application/state/player_provider.dart';
import 'package:family_game_score/application/state/result_provider.dart';
import 'package:family_game_score/application/state/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  String getAppBarTitle() {
    return isFinishedGame() ? '結果発表' : '現在の順位';
  }

  Widget getIconButton(VoidCallback onIconButtonPressed) {
    return isFinishedGame()
        ? IconButton(
            icon: Icon(Icons.home, size: 24.r),
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
    return ResultListCard(
      key: ValueKey(player.id),
      player: player,
      result: result,
    );
  }
}

final rankingViewModelProvider = Provider((ref) => RankingViewModel(ref));
