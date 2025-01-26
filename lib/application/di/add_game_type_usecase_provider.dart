import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:family_game_score/application/state/session_notifier.dart';
import 'package:family_game_score/application/usecase/add_game_type_usecase.dart';

final addGameTypeUsecaseProvider = Provider(
  (ref) => AddGameTypeUsecase(ref.watch(sessionNotifierProvider.notifier)),
);
