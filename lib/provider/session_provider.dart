import 'package:family_game_score/model/session.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

class SessionNotifier extends AsyncNotifier<Session?> {
  @override
  Future<Session?> build() async {
    try {
      final session = await readSession();

      return session;
    } catch (e) {
      rethrow;
    }
  }

  Future<Database> openDB() async {
    return await openDatabase(
      'family_game_score.db',
      version: 1,
    );
  }

  Future<void> createSession() async {
    Database? database;

    try {
      database = await openDB();

      if (state.value == null) {
        final List<Map<String, dynamic>> maxIdResponse =
            await database.rawQuery('SELECT MAX(id) as maxId FROM Session');
        final int newID = maxIdResponse.first['maxId'] == null
            ? 1
            : maxIdResponse.first['maxId'] + 1;
        final newSession =
            Session(id: newID, round: 1, begTime: DateTime.now().toString());

        await database.rawInsert(
            'INSERT INTO Session(id, round, begTime) VALUES(?, ?, ?)',
            [newSession.id, newSession.round, newSession.begTime]);
        state = AsyncData(newSession);
      }
    } catch (e) {
      rethrow;
    } finally {
      database?.close();
    }
  }

  Future<Session?> readSession() async {
    Database? database;

    try {
      database = await openDB();

      final List<Map<String, dynamic>> session = await database
          .rawQuery('SELECT * FROM Session WHERE endTime IS NULL');

      if (session.isEmpty) {
        return null;
      } else {
        return Session.fromJson(session.first);
      }
    } catch (e) {
      rethrow;
    } finally {
      database?.close();
    }
  }

  Future<void> updateSession() async {
    Database? database;

    try {
      database = await openDB();

      await database.rawUpdate(
          'UPDATE Session SET round = ?, endTime = ? WHERE id = ?',
          [state.value!.round, state.value!.endTime, state.value!.id]);
    } catch (e) {
      rethrow;
    } finally {
      database?.close();
    }
  }

  void updateRound() {
    state = AsyncData(state.value!.copyWith(round: state.value!.round + 1));
  }

  void updateEndTime() {
    state =
        AsyncData(state.value!.copyWith(endTime: DateTime.now().toString()));
  }

  void disposeSession() {
    state = AsyncData(null);
  }

  Future<bool> isExistSession() async {
    Database? database;

    try {
      database = await openDB();

      final List<Map<String, dynamic>> currentSession = await database
          .rawQuery('SELECT * FROM Session WHERE endTime IS NULL');

      return currentSession.isNotEmpty;
    } catch (e) {
      rethrow;
    } finally {
      database?.close();
    }
  }
}

final sessionProvider = AsyncNotifierProvider<SessionNotifier, Session?>(() {
  return SessionNotifier();
});
