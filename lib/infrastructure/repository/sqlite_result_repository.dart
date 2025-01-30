import 'package:sqflite/sqflite.dart';

import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/domain/entity/result.dart';
import 'package:family_game_score/domain/entity/session.dart';
import 'package:family_game_score/application/interface/result_repository.dart';

class SQLiteResultRepository implements ResultRepository {
  final Database _database;

  SQLiteResultRepository(this._database);

  @override
  Future<void> addResult(Result result, Transaction txc) async {
    try {
      await txc.rawInsert(
        'INSERT INTO Result(playerId, sessionId, score, rank) VALUES(?, ?, ?, ?)',
        [result.playerId, result.sessionId, result.score, result.rank],
      );
    } catch (e) {
      throw Exception('結果の追加中にエラーが発生しました。');
    }
  }

  @override
  Future<List<Result>> getResult(Session session, Transaction? txc) async {
    try {
      List<Map<String, dynamic>> results;
      txc == null
          ? results = await _database.rawQuery(
              'SELECT * FROM Result WHERE sessionId = ? ORDER BY score DESC',
              [session.id],
            )
          : results = await txc.rawQuery(
              'SELECT * FROM Result WHERE sessionId = ? ORDER BY score DESC',
              [session.id],
            );

      return results.map((e) => Result.fromJson(e)).toList();
    } catch (e) {
      throw Exception('結果の取得中にエラーが発生しました。');
    }
  }

  @override
  Future<int> getTotalScore(Player player) async {
    try {
      final response = await _database.rawQuery(
        'SELECT SUM(score) AS totalScore FROM Result WHERE playerId = ?',
        [player.id],
      );

      final totalScore = response.first['totalScore'] as int;
      return totalScore;
    } catch (e) {
      throw Exception('合計スコアの取得中にエラーが発生しました。');
    }
  }

  @override
  Future<void> updateResult(Result result, Transaction txc) async {
    try {
      await txc.rawUpdate(
        'UPDATE Result SET score = ? WHERE playerId = ? AND sessionId = ?',
        [result.score, result.playerId, result.sessionId],
      );
    } catch (e) {
      throw Exception('結果の更新中にエラーが発生しました。');
    }
  }

  @override
  Future<void> updateRank(Result result, Transaction txc) async {
    try {
      await txc.rawUpdate(
        'UPDATE Result SET rank = ? WHERE playerId = ? AND sessionId = ?',
        [result.rank, result.playerId, result.sessionId],
      );
    } catch (e) {
      throw Exception('順位の更新中にエラーが発生しました。');
    }
  }
}
