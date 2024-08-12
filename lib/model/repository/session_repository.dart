import 'package:family_game_score/model/entity/session.dart';
import 'package:sqflite/sqflite.dart';

class SessionRepository {
  Database database;

  SessionRepository(this.database);

  Future<Session> addSession(int id) async {
    final newSession =
        Session(id: id, round: 1, begTime: DateTime.now().toString());

    await database.rawInsert(
        'INSERT INTO Session(id, round, begTime) VALUES(?, ?, ?)',
        [newSession.id, newSession.round, newSession.begTime]);

    return newSession;
  }

  Future<Session?> getSession() async {
    final List<Map<String, dynamic>> response =
        await database.rawQuery('SELECT * FROM Session WHERE endTime IS NULL');
    final session = response.map((map) => Session.fromJson(map)).toList();

    return session.isEmpty ? null : session.first;
  }

  Future<int> getMaxID() async {
    final List<Map<String, dynamic>> maxIdResponse =
        await database.rawQuery('SELECT MAX(id) as maxId FROM Session');
    return maxIdResponse.first['maxId'] == null
        ? 1
        : maxIdResponse.first['maxId'] + 1;
  }

  Future<Session> updateRound(Session session) async {
    final updatedSession = session.copyWith(round: session.round + 1);
    await database.rawUpdate('UPDATE Session SET round = ? WHERE id = ?',
        [updatedSession.round, updatedSession.id]);

    return updatedSession;
  }

  Future<Session> updateEndTime(Session session) async {
    final updatedSession = session.copyWith(endTime: DateTime.now().toString());
    await database.rawUpdate('UPDATE Session SET endTime = ? WHERE id = ?',
        [updatedSession.endTime, updatedSession.id]);

    return updatedSession;
  }

  Future<void> updateGameType(Session session, String gameType) async {
    await database.rawUpdate(
        'UPDATE Session SET gameType = ? WHERE id = ?', [gameType, session.id]);
  }
}
