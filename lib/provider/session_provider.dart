import 'package:family_game_score/model/session.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

class SessionNotifier extends AsyncNotifier<Session> {
  late Database _database;

  @override
  Future<Session> build() async {
    state = const AsyncLoading();

    try {
      await openDB();
      final session = await readSession();
      state = AsyncData(session);
      return session;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return Session(id: 0, round: 0, begTime: DateTime.now().toString());
    }
  }

  Future<void> openDB() async {
    _database = await openDatabase(
      'family_game_score.db',
      version: 1,
    );
  }

  Future<Session> readSession() async {
    state = const AsyncLoading();

    try {
      final List<Map<String, dynamic>> currentSession = await _database
          .rawQuery('SELECT * FROM Session WHERE endTime IS NULL');

      if (currentSession.isEmpty) {
        // 現在進行中のSessionがないので新規作成
        final List<Map<String, dynamic>> maxIdResponse =
            await _database.rawQuery('SELECT MAX(id) as maxId FROM Session');
        final int newID = maxIdResponse.first['maxId'] == null
            ? 1
            : maxIdResponse.first['maxId'] + 1;
        final newSession =
            Session(id: newID, round: 1, begTime: DateTime.now().toString());
        await _database.rawInsert(
            'INSERT INTO Session(id, round, begTime) VALUES(?, ?, ?)',
            [newSession.id, newSession.round, newSession.begTime]);
        state = AsyncData(newSession);
        return newSession;
      } else {
        // 現在進行中のSessionがあるのでそれを返す
        final savedSession = Session.fromJson(currentSession.first);
        state = AsyncData(savedSession);
        return savedSession;
      }
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return Session(id: 0, round: 0, begTime: DateTime.now().toString());
    }
  }

  Future<void> updateSession() async {
    state = const AsyncLoading();

    try {
      await _database.rawUpdate(
          'UPDATE Session SET round = ?, endTime = ? WHERE id = ?',
          [state.value!.round, state.value!.endTime, state.value!.id]);
      state = AsyncData(state.value!);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  void updateRound() {
    state = AsyncData(state.value!.copyWith(round: state.value!.round + 1));
  }
}

final sessionNotifierProvider =
    AsyncNotifierProvider<SessionNotifier, Session>(() {
  return SessionNotifier();
});
