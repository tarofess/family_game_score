import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:family_game_score/application/state/player_notifier.dart';
import 'package:family_game_score/application/usecase/start_game_usecase.dart';

final startGameUsecaseProvider = Provider(
  (ref) => StartGameUsecase(ref.watch(playerNotifierProvider.notifier)),
);
