import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:family_game_score/application/state/player_notifier.dart';
import 'package:family_game_score/application/state/result_history_notifier.dart';
import 'package:family_game_score/application/state/result_notifier.dart';
import 'package:family_game_score/application/state/session_notifier.dart';
import 'package:family_game_score/domain/result.dart';

class ResetGameUsecase {
  final Ref _ref;

  ResetGameUsecase(this._ref);

  Result execute() {
    try {
      _ref.invalidate(resultNotifierProvider);
      _ref.invalidate(resultHistoryNotifierProvider);
      _ref.invalidate(playerNotifierProvider);
      _ref.read(sessionNotifierProvider.notifier).disposeSession();
      return const Success();
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
