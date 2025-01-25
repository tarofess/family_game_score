import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqflite/sqflite.dart';

import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/domain/entity/result.dart';
import 'package:family_game_score/domain/entity/session.dart';
import 'package:family_game_score/application/state/player_notifier.dart';
import 'package:family_game_score/application/state/session_notifier.dart';
import 'package:family_game_score/application/interface/result_repository.dart';
import 'package:family_game_score/infrastructure/repository/sqlite_result_repository.dart';

class ResultNotifier extends AsyncNotifier<List<Result>> {
  final ResultRepository _resultRepository;

  ResultNotifier(this._resultRepository);

  @override
  Future<List<Result>> build() async {
    final session = ref.read(sessionNotifierProvider).valueOrNull;

    if (session == null) {
      state = const AsyncData([]);
      return [];
    } else {
      final results = await _resultRepository.getResult(session, null);
      state = AsyncData(results);
      return results;
    }
  }

  Future<void> addOrUpdateResult(Transaction txc) async {
    final players = ref.read(playerNotifierProvider).valueOrNull;
    final session = ref.read(sessionNotifierProvider).valueOrNull;

    if (players == null || session == null) {
      throw Exception('プレイヤーまたはセッションが取得できませんでした');
    }

    if (state.value?.isEmpty ?? true) {
      await addResult(players, session, txc);
    } else {
      await updateResult(players, session, txc);
    }

    final results = await _resultRepository.getResult(session, txc);
    state = AsyncData(results);
  }

  Future<void> addResult(
      List<Player> players, Session session, Transaction txc) async {
    await _resultRepository.addResult(players, session, txc);
    await _resultRepository.updateRank(session, txc);
  }

  Future<void> updateResult(
      List<Player> players, Session session, Transaction txc) async {
    await _resultRepository.updateResult(players, session, txc);
    await _resultRepository.updateRank(session, txc);
  }
}

final resultNotifierProvider =
    AsyncNotifierProvider<ResultNotifier, List<Result>>(() {
  return ResultNotifier(SQLiteResultRepository());
});
