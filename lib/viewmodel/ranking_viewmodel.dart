import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/result.dart';
import 'package:family_game_score/model/entity/session.dart';
import 'package:family_game_score/view/widget/sakura_animation.dart';
import 'package:family_game_score/viewmodel/provider/player_provider.dart';
import 'package:family_game_score/viewmodel/provider/result_provider.dart';
import 'package:family_game_score/viewmodel/provider/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RankingViewModel {
  final Ref ref;

  RankingViewModel(this.ref);

  AsyncValue<List<Player>> get activePlayers => ref.watch(playerProvider);
  AsyncValue<List<Result>> get results => ref.watch(resultProvider);
  AsyncValue<Session?> get session => ref.watch(sessionProvider);

  Widget getAppBarTitle() {
    return session.value?.endTime == null
        ? const Text('現在の順位')
        : const Text('結果発表');
  }

  Widget getIconButton(VoidCallback onIconButtonPressed) {
    return session.value?.endTime == null
        ? const SizedBox()
        : IconButton(
            icon: const Icon(Icons.home),
            onPressed: onIconButtonPressed,
          );
  }

  Widget getSakuraAnimation() {
    return session.value?.endTime == null
        ? const SizedBox()
        : const Positioned.fill(
            child: IgnorePointer(
              child: SakuraAnimation(),
            ),
          );
  }
}

final rankingViewModelProvider = Provider((ref) => RankingViewModel(ref));
