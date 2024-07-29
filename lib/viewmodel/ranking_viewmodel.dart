import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/result.dart';
import 'package:family_game_score/model/entity/session.dart';
import 'package:family_game_score/viewmodel/provider/player_provider.dart';
import 'package:family_game_score/viewmodel/provider/result_provider.dart';
import 'package:family_game_score/viewmodel/provider/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RankingViewModel {
  final Ref ref;

  RankingViewModel(this.ref);

  AsyncValue<List<Result>> get results => ref.watch(resultProvider);
  AsyncValue<List<Player>> get players => ref.watch(playerProvider);
  AsyncValue<Session?> get session => ref.watch(sessionProvider);

  Widget getAppBarTitle() {
    return session.value == null ? const Text('結果発表') : const Text('現在の順位');
  }

  Widget getIconButton(VoidCallback onIconButtonPressed) {
    return session.value == null
        ? IconButton(
            icon: const Icon(Icons.check),
            onPressed: onIconButtonPressed,
          )
        : const SizedBox();
  }
}

final rankingViewModelProvider = Provider((ref) => RankingViewModel(ref));
