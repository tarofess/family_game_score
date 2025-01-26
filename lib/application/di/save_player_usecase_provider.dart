import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:family_game_score/application/state/player_notifier.dart';
import 'package:family_game_score/application/usecase/save_player_usecase.dart';
import 'package:family_game_score/infrastructure/service/file_service.dart';

final savePlayerUsecaseProvider = Provider(
  (ref) => SavePlayerUsecase(
    ref.watch(playerNotifierProvider.notifier),
    FileService(),
  ),
);
