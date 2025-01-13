import 'package:family_game_score/domain/entity/session.dart';
import 'package:family_game_score/infrastructure/repository/database_helper.dart';
import 'package:family_game_score/infrastructure/repository/session_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqflite/sqflite.dart';

class SessionNotifier extends AsyncNotifier<Session?> {
  late SessionRepository sessionRepository;
  Database database;

  SessionNotifier(this.database);

  @override
  Future<Session?> build() async {
    sessionRepository = SessionRepository(database);
    final session = await sessionRepository.getSession();
    state = AsyncData(session);
    return session;
  }

  Future<void> addSession(Transaction txc) async {
    if (state.value == null) {
      final maxID = await sessionRepository.getMaxID(txc);
      final newSession = await sessionRepository.addSession(maxID, txc);
      state = AsyncData(newSession);
    } else {
      state = AsyncData(state.value);
    }
  }

  Future<void> addGameType(String gameType) async {
    if (state.value == null) {
      throw Exception('ゲームは既に終了しており予期せぬエラーが発生しました。');
    }
    final session = state.value!;
    await sessionRepository.updateGameType(session, gameType);
    state = AsyncData(session);
  }

  Future<void> getSession() async {
    final session = await sessionRepository.getSession();
    state = AsyncData(session);
  }

  Future<void> updateRound(Transaction txc) async {
    if (state.value == null) {
      throw Exception('ゲームは既に終了しており予期せぬエラーが発生しました。');
    }
    final updatedSession =
        await sessionRepository.updateRound(state.value!, txc);
    state = AsyncData(updatedSession);
  }

  Future<void> updateEndTime() async {
    if (state.value == null) {
      throw Exception('ゲームは既に終了しており予期せぬエラーが発生しました。');
    }
    final updatedSession = await sessionRepository.updateEndTime(state.value!);
    state = AsyncData(updatedSession);
  }

  void disposeSession() {
    state = const AsyncData(null);
  }
}

final sessionNotifierProvider =
    AsyncNotifierProvider<SessionNotifier, Session?>(() {
  return SessionNotifier(DatabaseHelper.instance.database);
});
