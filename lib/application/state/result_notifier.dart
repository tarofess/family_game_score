import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqflite/sqflite.dart';

import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/domain/entity/result.dart';
import 'package:family_game_score/domain/entity/session.dart';
import 'package:family_game_score/application/state/player_notifier.dart';
import 'package:family_game_score/application/state/session_notifier.dart';
import 'package:family_game_score/application/interface/result_repository.dart';
import 'package:family_game_score/infrastructure/repository/sqlite_result_repository.dart';
import 'package:family_game_score/domain/feature/score_calculator.dart';
import 'package:family_game_score/infrastructure/repository/database_helper.dart';

class ResultNotifier extends AsyncNotifier<List<Result>> {
  final ResultRepository _resultRepository;
  final ScoreCalculator _calculator;

  ResultNotifier(this._resultRepository, this._calculator);

  @override
  Future<List<Result>> build() async {
    final session = ref.read(sessionNotifierProvider).value;

    if (session == null) {
      state = const AsyncData([]);
      return [];
    } else {
      final results = await _resultRepository.getResult(session, null);
      state = AsyncData(results);
      return results;
    }
  }

  Future<void> saveResult(Transaction txc) async {
    final players = ref.read(playerNotifierProvider).value;
    final session = ref.read(sessionNotifierProvider).value;

    if (players == null || session == null) {
      throw Exception('プレイヤーまたはセッションが取得できませんでした。');
    }

    if (state.value?.isEmpty ?? true) {
      // 初回の結果登録
      await addResult(players, session, txc);
    } else {
      await updateResult(players, session, txc);
    }

    final results = await _resultRepository.getResult(session, txc);
    state = AsyncData(results);
  }

  Future<void> addResult(
    List<Player> players,
    Session session,
    Transaction txc,
  ) async {
    final results = _calculator.calculateScores(players, session);

    for (final result in results) {
      await _resultRepository.addResult(result, txc);
      await _resultRepository.updateRank(result, txc);
    }
  }

  Future<void> updateResult(
    List<Player> players,
    Session session,
    Transaction txc,
  ) async {
    // 既存の結果を取得
    final existingResults = await _resultRepository.getResult(
      session,
      txc,
    );

    // スコアを更新した結果を取得
    final updatedResults = _calculator.calculateUpdatedScores(
      players,
      session,
      existingResults,
    );

    for (final result in updatedResults) {
      await _resultRepository.updateResult(result, txc);
      await _resultRepository.updateRank(result, txc);
    }
  }
}

final resultNotifierProvider =
    AsyncNotifierProvider<ResultNotifier, List<Result>>(
  () => ResultNotifier(
    SQLiteResultRepository(DatabaseHelper.instance.database),
    ScoreCalculator(),
  ),
);
