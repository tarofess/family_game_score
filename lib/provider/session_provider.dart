import 'package:family_game_score/model/entity/session.dart';
import 'package:family_game_score/model/repository/session_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionNotifier extends AsyncNotifier<Session?> {
  @override
  Future<Session?> build() async {
    try {
      final sessionRepository = SessionRepository();
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

    if (state.value == null) {
      state = await AsyncValue.guard(() async {
        final sessionRepository = SessionRepository();
        final newSession = await sessionRepository.addSession();
        return newSession;
      });
    }
  }

  Future<void> getSession() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final sessionRepository = SessionRepository();
      final session = await sessionRepository.getSession();
      return session;
    });
  }

  Future<void> updateRound() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final sessionRepository = SessionRepository();
      final updatedSession = await sessionRepository.updateRound(state.value!);
      return updatedSession;
    });
  }

  Future<void> updateEndTime() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final sessionRepository = SessionRepository();
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
  return SessionNotifier();
});
