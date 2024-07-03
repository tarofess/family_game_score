import 'package:family_game_score/model/result.dart';
import 'package:family_game_score/provider/player_provider.dart';
import 'package:family_game_score/provider/session_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

class ResultNotifier extends AsyncNotifier<List<Result>> {
  late Database _database;

  @override
  Future<List<Result>> build() async {
    state = const AsyncLoading();

    try {
      await openDB();
      final results = await getResultsWithSessionFromDB();
      state = AsyncData(results);
      return results;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return [];
    }
  }

  Future<void> openDB() async {
    _database = await openDatabase(
      'family_game_score.db',
      version: 1,
    );
  }

  Future<void> updateResult() async {
    final session = ref.read(sessionNotifierProvider).value!;
    final players = ref.read(playerNotifierProvider).value!;
    int x = players.length; // 順位ごとにscoreに10ポイントずつ差をつけるための変数

    state = const AsyncLoading();

    try {
      await _database.transaction((txn) async {
        for (final player in players) {
          final response = await txn.rawQuery(
              'SELECT * FROM Result WHERE playerId = ? AND sessionId = ?',
              [player.id, session.id]);
          final results = response.map((e) => Result.fromJson(e)).toList();
          if (results.isNotEmpty) {
            // すでにResultテーブルにデータがある場合はスコアを更新
            final result = results.first;
            await txn.rawUpdate(
                'UPDATE Result SET score = ? WHERE playerId = ? AND sessionId = ?',
                [result.score + x * 10, player.id, session.id]);
          } else {
            // Resultテーブルにデータがない場合は新規登録
            await txn.rawInsert(
                'INSERT INTO Result(playerId, sessionId, score) VALUES(?, ?, ?)',
                [player.id, session.id, x * 10]);
          }
          x -= 1; // 該当プレイヤーが順位を下げるたびに10ポイントずつ減らす
        }
      });
      final results = await getResultsWithSessionFromDB();
      state = AsyncData(results);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<List<Result>> getResultsWithSessionFromDB() async {
    final session = ref.read(sessionNotifierProvider);
    final List<Map<String, dynamic>> results = await _database.rawQuery(
        'SELECT * FROM Result WHERE sessionId = ? ORDER BY score DESC',
        [session.value!.id]);
    return results.map((e) => Result.fromJson(e)).toList();
  }
}

final resultNotifierProvider =
    AsyncNotifierProvider<ResultNotifier, List<Result>>(() {
  return ResultNotifier();
});
