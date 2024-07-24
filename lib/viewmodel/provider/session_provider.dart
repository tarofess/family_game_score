import 'package:family_game_score/model/entity/session.dart';
import 'package:family_game_score/model/repository/database_helper.dart';
import 'package:family_game_score/model/repository/session_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqflite/sqflite.dart';

class SessionNotifier extends AsyncNotifier<Session?> {
  late SessionRepository sessionRepository;
  Database database;

  SessionNotifier(this.database);

  @override
  Future<Session?> build() async {
    try {
      sessionRepository = SessionRepository(database);
      final session = await sessionRepository.getSession();
      state = AsyncData(session);
      return session;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> addSession() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      if (state.value == null) {
        final maxID = await sessionRepository.getMaxID();
        final newSession = await sessionRepository.addSession(maxID);
        return newSession;
      } else {
        return state.value;
      }
    });
  }

  Future<void> getSession() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final session = await sessionRepository.getSession();
      return session;
    });
  }

  Future<void> updateRound() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      if (state.value == null) {
        throw Exception('Session is null');
      }
      final updatedSession = await sessionRepository.updateRound(state.value!);
      return updatedSession;
    });
  }

  Future<void> updateEndTime() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      if (state.value == null) {
        throw Exception('Session is null');
      }
      final updatedSession =
          await sessionRepository.updateEndTime(state.value!);
      return updatedSession;
    });
  }

  void disposeSession() {
    state = const AsyncData(null);
  }
}

final sessionProvider = AsyncNotifierProvider<SessionNotifier, Session?>(() {
  return SessionNotifier(DatabaseHelper.instance.database);
});
