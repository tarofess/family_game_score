import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:family_game_score/application/state/player_notifier.dart';
import 'package:family_game_score/application/state/result_history_notifier.dart';
import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/domain/result.dart';

class DeletePlayerUsecase {
  final Ref _ref;
  final PlayerNotifier _playerNotifier;

  DeletePlayerUsecase(this._ref, this._playerNotifier);

  Future<Result> execute(Player player) async {
    try {
      await _playerNotifier.deletePlayer(player);
      _ref.invalidate(resultHistoryNotifierProvider);
      return const Success(null);
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
