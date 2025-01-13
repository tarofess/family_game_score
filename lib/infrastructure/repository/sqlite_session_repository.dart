import 'package:sqflite/sqflite.dart';

import 'package:family_game_score/domain/entity/session.dart';
import 'package:family_game_score/application/interface/session_repository.dart';
import 'package:family_game_score/infrastructure/repository/database_helper.dart';

class SQLiteSessionRepository implements SessionRepository {
  final Database _database;

  SQLiteSessionRepository() : _database = DatabaseHelper.instance.database;

  @override
  Future<Session> addSession(int id, Transaction txc) async {
    try {
      final newSession =
          Session(id: id, round: 1, begTime: DateTime.now().toString());
      await txc.rawInsert(
          'INSERT INTO Session(id, round, begTime) VALUES(?, ?, ?)',
          [newSession.id, newSession.round, newSession.begTime]);
      return newSession;
    } catch (e) {
      throw Exception('セッションの追加中にエラーが発生しました。');
    }
  }

  @override
  Future<Session?> getSession() async {
    try {
      final List<Map<String, dynamic>> response = await _database
          .rawQuery('SELECT * FROM Session WHERE endTime IS NULL');
      final session = response.map((map) => Session.fromJson(map)).toList();
      return session.isEmpty ? null : session.first;
    } catch (e) {
      throw Exception('セッションの取得中にエラーが発生しました。');
    }
  }

  @override
  Future<int> getMaxID(Transaction txc) async {
    try {
      final List<Map<String, dynamic>> maxIdResponse =
          await txc.rawQuery('SELECT MAX(id) as maxId FROM Session');
      return maxIdResponse.first['maxId'] == null
          ? 1
          : maxIdResponse.first['maxId'] + 1;
    } catch (e) {
      throw Exception('最新セッションの取得中にエラーが発生しました。');
    }
  }

  @override
  Future<Session> updateRound(Session session, Transaction txc) async {
    try {
      final updatedSession = session.copyWith(round: session.round + 1);
      await txc.rawUpdate('UPDATE Session SET round = ? WHERE id = ?',
          [updatedSession.round, updatedSession.id]);
      return updatedSession;
    } catch (e) {
      throw Exception('ラウンドの更新中にエラーが発生しました。');
    }
  }

  @override
  Future<Session> updateEndTime(Session session) async {
    try {
      final updatedSession =
          session.copyWith(endTime: DateTime.now().toString());
      await _database.rawUpdate('UPDATE Session SET endTime = ? WHERE id = ?',
          [updatedSession.endTime, updatedSession.id]);
      return updatedSession;
    } catch (e) {
      throw Exception('終了時間の更新中にエラーが発生しました。');
    }
  }

  @override
  Future<void> updateGameType(Session session, String gameType) async {
    try {
      await _database.rawUpdate('UPDATE Session SET gameType = ? WHERE id = ?',
          [gameType, session.id]);
    } catch (e) {
      throw Exception('ゲーム種類の記録中にエラーが発生しました。');
    }
  }
}
