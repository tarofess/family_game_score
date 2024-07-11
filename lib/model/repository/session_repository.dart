import 'package:family_game_score/model/entity/session.dart';
import 'package:sqflite/sqflite.dart';

class SessionRepository {
  Database database;

  SessionRepository(this.database);

  Future<Session> addSession() async {
    try {
      final List<Map<String, dynamic>> maxIdResponse =
          await database.rawQuery('SELECT MAX(id) as maxId FROM Session');
      final int newID = maxIdResponse.first['maxId'] == null
          ? 1
          : maxIdResponse.first['maxId'] + 1;
      final newSession =
          Session(id: newID, round: 1, begTime: formatDateTime(DateTime.now()));

      await database.rawInsert(
          'INSERT INTO Session(id, round, begTime) VALUES(?, ?, ?)',
          [newSession.id, newSession.round, newSession.begTime]);

      return newSession;
    } catch (e) {
      rethrow;
    }
  }

  Future<Session?> getSession() async {
    try {
      final List<Map<String, dynamic>> response = await database
          .rawQuery('SELECT * FROM Session WHERE endTime IS NULL');
      final session = response.map((map) => Session.fromJson(map)).toList();

      return session.isEmpty ? null : session.first;
    } catch (e) {
      rethrow;
    }
  }

  Future<Session> updateRound(Session session) async {
    try {
      final updatedSession = session.copyWith(round: session.round + 1);
      await database.rawUpdate('UPDATE Session SET round = ? WHERE id = ?',
          [updatedSession.round, updatedSession.id]);

      return updatedSession;
    } catch (e) {
      rethrow;
    }
  }

  Future<Session> updateEndTime(Session session) async {
    try {
      final updatedSession =
          session.copyWith(endTime: formatDateTime(DateTime.now()));
      await database.rawUpdate('UPDATE Session SET endTime = ? WHERE id = ?',
          [updatedSession.endTime, updatedSession.id]);

      return updatedSession;
    } catch (e) {
      rethrow;
    }
  }

  String formatDateTime(DateTime dateTime) {
    final year = dateTime.year.toString();
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$year-$month-$day $hour:$minute';
  }
}
