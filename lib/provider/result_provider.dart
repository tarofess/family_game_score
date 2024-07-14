import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/result.dart';
import 'package:family_game_score/model/entity/session.dart';
import 'package:family_game_score/model/repository/database_helper.dart';
import 'package:family_game_score/model/repository/result_repository.dart';
import 'package:family_game_score/provider/session_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

class ResultNotifier extends AsyncNotifier<List<Result>> {
  late ResultRepository resultRepository;
  Database database;

  ResultNotifier(this.database);

  @override
  Future<List<Result>> build() async {
    try {
      resultRepository = ResultRepository(database);
      final session = ref.read(sessionProvider);

      if (session.value == null) {
        state = const AsyncData([]);
        return [];
      } else {
        final results = await resultRepository.getResult(session.value!);
        state = AsyncData(results);
        return results;
      }
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> addResult(List<Player> players, Session session) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await resultRepository.addResult(players, session);
      await resultRepository.updateRank(session);
      final results = await resultRepository.getResult(session);
      return results;
    });
  }

  Future<void> updateResult(List<Player> players, Session session) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await resultRepository.updateResult(players, session);
      await resultRepository.updateRank(session);
      final results = await resultRepository.getResult(session);
      return results;
    });
  }
}

final resultProvider = AsyncNotifierProvider<ResultNotifier, List<Result>>(() {
  return ResultNotifier(DatabaseHelper.instance.database);
});
