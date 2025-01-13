import 'package:family_game_score/application/state/player_notifier.dart';
import 'package:family_game_score/application/usecase/delete_player_usecase.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final deletePlayerUsecaseProvider = Provider(
  (ref) => DeletePlayerUsecase(ref, ref.watch(playerNotifierProvider.notifier)),
);
