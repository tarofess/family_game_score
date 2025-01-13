import 'package:family_game_score/application/state/result_history_notifier.dart';
import 'package:family_game_score/application/usecase/update_game_type_usecase.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final updateGameTypeUsecaseProvider = Provider(
  (ref) => UpdateGameTypeUsecase(
    ref.watch(resultHistoryNotifierProvider.notifier),
  ),
);
