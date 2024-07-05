import 'package:family_game_score/model/result.dart';
import 'package:family_game_score/provider/player_provider.dart';
import 'package:family_game_score/provider/session_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

class ResultNotifier extends AsyncNotifier<List<Result>> {
  @override
  Future<List<Result>> build() async {
    try {
      final results = await getResultsWithSessionFromDB();
      state = AsyncData(results);

      return results;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<Database> openDB() async {
    return await openDatabase(
      'family_game_score.db',
      version: 1,
    );
  }

  Future<void> updateResult() async {
    Database? database;
    final session = ref.read(sessionProvider).value!;
    final players = ref.read(playerProvider).value!;
    int x = players.length; // 順位ごとにscoreに10ポイントずつ差をつけるための変数

    state = const AsyncLoading();

    try {
      database = await openDB();

      for (final player in players) {
        final response = await database.rawQuery(
            'SELECT * FROM Result WHERE playerId = ? AND sessionId = ?',
            [player.id, session.id]);

        if (response.isNotEmpty) {
          // すでにResultテーブルにデータがある場合はスコアを更新
          final results = response.map((e) => Result.fromJson(e)).toList();
          final result = results.first;

          await database.rawUpdate(
              'UPDATE Result SET score = ? WHERE playerId = ? AND sessionId = ?',
              [result.score + x * 10, player.id, session.id]);
        } else {
          // Resultテーブルにデータがない場合は新規登録
          await database.rawInsert(
              'INSERT INTO Result(playerId, sessionId, score, rank) VALUES(?, ?, ?, 1)',
              [player.id, session.id, x * 10]);
        }
        x -= 1; // 該当プレイヤーが順位を下げるたびに10ポイントずつ減らす
      }
      final results = await getResultsWithSessionFromDB();
      state = AsyncData(results);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    } finally {
      database?.close();
    }
  }

  Future<void> updateRank() async {
    Database? database;
    final session = ref.read(sessionProvider).value!;

    state = const AsyncLoading();

    try {
      database = await openDB();

      final List<Map<String, dynamic>> results = await database.rawQuery(
          'SELECT * FROM Result WHERE sessionId = ? ORDER BY score DESC',
          [session.id]);

      int rank = 1;
      for (final result in results) {
        await database.rawUpdate(
            'UPDATE Result SET rank = ? WHERE id = ?', [rank, result['id']]);
        rank += 1;
      }

      final updatedResults = await getResultsWithSessionFromDB();
      state = AsyncData(updatedResults);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    } finally {
      database?.close();
    }
  }

  Future<List<Result>> getResultsWithSessionFromDB() async {
    Database? database;
    try {
      database = await openDB();

      final session = ref.read(sessionProvider);

      if (session.value == null) {
        return [];
      }

      final List<Map<String, dynamic>> results = await database.rawQuery(
          'SELECT * FROM Result WHERE sessionId = ? ORDER BY score DESC',
          [session.value!.id]);

      return results.map((e) => Result.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    } finally {
      database?.close();
    }
  }
}

final resultProvider = AsyncNotifierProvider<ResultNotifier, List<Result>>(() {
  return ResultNotifier();
});
