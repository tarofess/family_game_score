import 'package:family_game_score/model/result_history.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

class ResultHistoryNotifier
    extends AutoDisposeAsyncNotifier<List<ResultHistory>> {
  @override
  Future<List<ResultHistory>> build() async {
    try {
      final results = await getResultsFromDB();
      state = AsyncData(results);

      return results;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<List<ResultHistory>> getResultsFromDB() async {
    Database? database;

    try {
      database = await openDB();
      final response = await database.rawQuery('''
          SELECT 
            Result.id as resultId,
            Result.playerId,
            Result.sessionId,
            Result.score,
            Result.rank,
            Player.id as playerId,
            Player.name as playerName,
            Session.id as sessionId,
            Session.round,
            Session.begTime,
            Session.endTime
          FROM Result
          INNER JOIN Session ON Result.sessionId = Session.id
          INNER JOIN Player ON Result.playerId = Player.id
          WHERE Session.endTime IS NOT NULL
          ORDER BY Session.begTime, Result.rank
        ''');
      final results = response.map((e) => ResultHistory.fromJson(e)).toList();

      return results;
    } catch (e) {
      rethrow;
    } finally {
      await database?.close();
    }
  }

  Future<Database> openDB() async {
    return await openDatabase(
      'family_game_score.db',
      version: 1,
    );
  }
}

final resultHistoryProvider = AsyncNotifierProvider.autoDispose<
    ResultHistoryNotifier, List<ResultHistory>>(() => ResultHistoryNotifier());
