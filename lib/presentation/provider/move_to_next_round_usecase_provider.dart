import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:family_game_score/application/state/result_notifier.dart';
import 'package:family_game_score/application/state/session_notifier.dart';
import 'package:family_game_score/application/usecase/move_to_next_round_usecase.dart';

final moveToNextRoundUsecaseProvider = Provider(
  (ref) => MoveToNextRoundUsecase(
    ref.watch(sessionNotifierProvider.notifier),
    ref.watch(resultNotifierProvider.notifier),
  ),
);
