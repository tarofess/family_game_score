import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:family_game_score/application/state/session_notifier.dart';
import 'package:family_game_score/application/usecase/finish_game_usecase.dart';

final finishGameUsecaseProvider = Provider(
  (ref) => FinishGameUsecase(ref.watch(sessionNotifierProvider.notifier)),
);
