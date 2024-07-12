import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/result.dart';
import 'package:family_game_score/model/entity/session.dart';
import 'package:sqflite/sqflite.dart';

class ResultRepository {
  Database database;

  ResultRepository(this.database);

  Future<void> addResult(List<Player> players, Session session) async {
    int x = players.length; // 順位ごとにscoreに10ポイントずつ差をつけるための変数

    try {
      for (final player in players) {
        await database.rawInsert(
            'INSERT INTO Result(playerId, sessionId, score, rank) VALUES(?, ?, ?, 1)',
            [player.id, session.id, x * 10]);

        x -= 1; // 該当プレイヤーが順位を下げるたびに10ポイントずつ減らす
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Result>> getResult(Session session) async {
    try {
      final List<Map<String, dynamic>> results = await database.rawQuery(
          'SELECT * FROM Result WHERE sessionId = ? ORDER BY score DESC',
          [session.id]);

      return results.map((e) => Result.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateResult(List<Player> players, Session session) async {
    int x = players.length; // 順位ごとにscoreに10ポイントずつ差をつけるための変数

    try {
      for (final player in players) {
        final response = await database.rawQuery(
            'SELECT * FROM Result WHERE playerId = ? AND sessionId = ?',
            [player.id, session.id]);
        final results = response.map((e) => Result.fromJson(e)).toList();
        await database.rawUpdate(
            'UPDATE Result SET score = ? WHERE playerId = ? AND sessionId = ?',
            [results.first.score + x * 10, player.id, session.id]);

        x -= 1; // 該当プレイヤーが順位を下げるたびに10ポイントずつ減らす
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateRank(Session session) async {
    int rank = 1;

    try {
      final resultsForRank = await getResult(session);

      for (int index = 0; index < resultsForRank.length; index++) {
        if (index >= 1 &&
            resultsForRank[index].score == resultsForRank[index - 1].score) {
          // 同じスコアの場合は同じ順位にする
          await database.rawUpdate('UPDATE Result SET rank = ? WHERE id = ?',
              [rank, resultsForRank[index].id]);
        } else {
          rank = index + 1;
          await database.rawUpdate('UPDATE Result SET rank = ? WHERE id = ?',
              [rank, resultsForRank[index].id]);
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}
