import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/result.dart';
import 'package:family_game_score/model/entity/session.dart';
import 'package:sqflite/sqflite.dart';

class ResultRepository {
  Database database;

  ResultRepository(this.database);

  Future<void> addResult(
      List<Player> players, Session session, Transaction txc) async {
    try {
      int x = players.length; // 順位ごとにscoreに10ポイントずつ差をつけるための変数

      for (final player in players) {
        await txc.rawInsert(
            'INSERT INTO Result(playerId, sessionId, score, rank) VALUES(?, ?, ?, 1)',
            [player.id, session.id, x * 10]);

        x -= 1; // 該当プレイヤーが順位を下げるたびに10ポイントずつ減らす
      }
    } catch (e) {
      throw Exception('結果の追加中にエラーが発生しました。');
    }
  }

  Future<List<Result>> getResult(Session session, Transaction? txc) async {
    try {
      List<Map<String, dynamic>> results;
      txc == null
          ? results = await database.rawQuery(
              'SELECT * FROM Result WHERE sessionId = ? ORDER BY score DESC',
              [session.id])
          : results = await txc.rawQuery(
              'SELECT * FROM Result WHERE sessionId = ? ORDER BY score DESC',
              [session.id]);
      return results.map((e) => Result.fromJson(e)).toList();
    } catch (e) {
      throw Exception('結果の取得中にエラーが発生しました。');
    }
  }

  Future<int> getTotalScore(Player player) async {
    try {
      final response = await database.rawQuery(
          'SELECT SUM(score) AS totalScore FROM Result WHERE playerId = ?',
          [player.id]);
      final totalScore = response.first['totalScore'] as int;
      return totalScore;
    } catch (e) {
      throw Exception('合計スコアの取得中にエラーが発生しました。');
    }
  }

  Future<void> updateResult(
      List<Player> players, Session session, Transaction txc) async {
    try {
      int x = players.length; // 順位ごとにscoreに10ポイントずつ差をつけるための変数

      for (final player in players) {
        final response = await txc.rawQuery(
            'SELECT * FROM Result WHERE playerId = ? AND sessionId = ?',
            [player.id, session.id]);
        final results = response.map((e) => Result.fromJson(e)).toList();
        await txc.rawUpdate(
            'UPDATE Result SET score = ? WHERE playerId = ? AND sessionId = ?',
            [results.first.score + x * 10, player.id, session.id]);

        x -= 1; // 該当プレイヤーが順位を下げるたびに10ポイントずつ減らす
      }
    } catch (e) {
      throw Exception('結果の更新中にエラーが発生しました。');
    }
  }

  Future<void> updateRank(Session session, Transaction txc) async {
    try {
      int rank = 1;

      final resultsForRank = await getResult(session, txc);

      for (int index = 0; index < resultsForRank.length; index++) {
        if (index >= 1 &&
            resultsForRank[index].score == resultsForRank[index - 1].score) {
          // 同じスコアの場合は同じ順位にする
          await txc.rawUpdate('UPDATE Result SET rank = ? WHERE id = ?',
              [rank, resultsForRank[index].id]);
        } else {
          rank = index + 1;
          await txc.rawUpdate('UPDATE Result SET rank = ? WHERE id = ?',
              [rank, resultsForRank[index].id]);
        }
      }
    } catch (e) {
      throw Exception('順位の更新中にエラーが発生しました。');
    }
  }
}
