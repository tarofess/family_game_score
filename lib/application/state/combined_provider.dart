import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:family_game_score/application/state/player_notifier.dart';
import 'package:family_game_score/application/state/result_notifier.dart';
import 'package:family_game_score/application/state/session_notifier.dart';

final combinedProvider = FutureProvider.autoDispose((ref) async {
  final session = await ref.watch(sessionNotifierProvider.future);
  final players = await ref.watch(playerNotifierProvider.future);
  final results = await ref.watch(resultNotifierProvider.future);
  return (session, players, results);
});
