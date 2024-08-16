import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/result.dart';
import 'package:family_game_score/model/entity/session.dart';
import 'package:family_game_score/model/repository/database_helper.dart';
import 'package:family_game_score/model/repository/result_repository.dart';
import 'package:family_game_score/viewmodel/provider/player_provider.dart';
import 'package:family_game_score/viewmodel/provider/session_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqflite/sqflite.dart';

class ResultNotifier extends AsyncNotifier<List<Result>> {
  late ResultRepository resultRepository;
  Database database;

  ResultNotifier(this.database);

  @override
  Future<List<Result>> build() async {
    resultRepository = ResultRepository(database);
    final session = ref.read(sessionProvider).valueOrNull;

    if (session == null) {
      state = const AsyncData([]);
      return [];
    } else {
      final results = await resultRepository.getResult(session, null);
      state = AsyncData(results);
      return results;
    }
  }

  Future<void> addOrUpdateResult(Transaction txc) async {
    final players = ref.read(playerProvider).valueOrNull;
    final session = ref.read(sessionProvider).valueOrNull;

    if (players == null || session == null) {
      throw Exception('プレイヤーまたはセッションが取得できませんでした');
    }

    if (state.value?.isEmpty ?? true) {
      await addResult(players, session, txc);
    } else {
      await updateResult(players, session, txc);
    }

    final results = await resultRepository.getResult(session, txc);
    state = AsyncData(results);
  }

  Future<void> addResult(
      List<Player> players, Session session, Transaction txc) async {
    await resultRepository.addResult(players, session, txc);
    await resultRepository.updateRank(session, txc);
  }

  Future<void> updateResult(
      List<Player> players, Session session, Transaction txc) async {
    await resultRepository.updateResult(players, session, txc);
    await resultRepository.updateRank(session, txc);
  }
}

final resultProvider = AsyncNotifierProvider<ResultNotifier, List<Result>>(() {
  return ResultNotifier(DatabaseHelper.instance.database);
});
