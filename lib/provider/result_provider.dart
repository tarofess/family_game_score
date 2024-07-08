import 'package:family_game_score/model/entity/result.dart';
import 'package:family_game_score/model/repository/result_repository.dart';
import 'package:family_game_score/provider/player_provider.dart';
import 'package:family_game_score/provider/session_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResultNotifier extends AsyncNotifier<List<Result>> {
  @override
  Future<List<Result>> build() async {
    try {
      final session = ref.read(sessionProvider);

      if (session.value == null) {
        state = const AsyncData([]);
        return [];
      } else {
        final resultRepository = ResultRepository();
        final results = await resultRepository.getResult(session.value!);
        state = AsyncData(results);
        return results;
      }
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> addResult() async {
    final session = ref.read(sessionProvider);
    final players = ref.read(playerProvider);

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final resultRepository = ResultRepository();
      await resultRepository.addResult(players.value!, session.value!);
      await resultRepository.updateRank(session.value!);
      final results = await resultRepository.getResult(session.value!);
      return results;
    });
  }

  Future<void> updateResult() async {
    final session = ref.read(sessionProvider);
    final players = ref.read(playerProvider);

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final resultRepository = ResultRepository();
      await resultRepository.updateResult(players.value!, session.value!);
      await resultRepository.updateRank(session.value!);
      final results = await resultRepository.getResult(session.value!);
      return results;
    });
  }
}

final resultProvider = AsyncNotifierProvider<ResultNotifier, List<Result>>(() {
  return ResultNotifier();
});
