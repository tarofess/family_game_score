import 'package:family_game_score/model/entity/result_history.dart';
import 'package:sqflite/sqflite.dart';

class ResultHistoryRepository {
  Database database;

  ResultHistoryRepository(this.database);

  Future<List<ResultHistory>> getResultHistory() async {
    try {
      final response = await database.rawQuery('''
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
            Session.endTime
          FROM Result
          INNER JOIN Session ON Result.sessionId = Session.id
          INNER JOIN Player ON Result.playerId = Player.id
          WHERE Session.endTime IS NOT NULL
          ORDER BY Session.begTime DESC, Result.rank
        ''');
      final results = response.map((e) => ResultHistory.fromJson(e)).toList();
      return results;
    } catch (e) {
      rethrow;
    }
  }
}
