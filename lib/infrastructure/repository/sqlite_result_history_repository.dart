import 'package:sqflite/sqflite.dart';

import 'package:family_game_score/application/interface/result_history_repository.dart';
import 'package:family_game_score/domain/entity/result_history.dart';

class SQLiteResultHistoryRepository implements ResultHistoryRepository {
  final Database _database;

  SQLiteResultHistoryRepository(this._database);

  @override
  Future<List<ResultHistory>> getResultHistory() async {
    try {
      final response = await _database.rawQuery('''
          SELECT 
            Result.id as resultId,
            Result.playerId,
            Result.sessionId,
            Result.score,
            Result.rank,
            Player.id as playerId,
            Player.name as playerName,
            Player.image as playerImage,
            Player.status as playerStatus,
            Session.id as sessionId,
            Session.round,
            Session.begTime,
            Session.endTime,
            Session.gameType
          FROM Result
          INNER JOIN Session ON Result.sessionId = Session.id
          INNER JOIN Player ON Result.playerId = Player.id
          WHERE Session.endTime IS NOT NULL
          ORDER BY Session.begTime DESC, Result.rank
        ''');
      final results = response.map((e) => ResultHistory.fromJson(e)).toList();
      return results;
    } catch (e) {
      throw Exception('過去の履歴の取得中にエラーが発生しました。');
    }
  }
}
