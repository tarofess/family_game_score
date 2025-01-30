import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqflite/sqflite.dart';

import 'package:family_game_score/domain/entity/session.dart';
import 'package:family_game_score/application/interface/session_repository.dart';
import 'package:family_game_score/infrastructure/repository/sqlite_session_repository.dart';
import 'package:family_game_score/infrastructure/repository/database_helper.dart';

class SessionNotifier extends AsyncNotifier<Session?> {
  final SessionRepository _sessionRepository;

  SessionNotifier(this._sessionRepository);

  @override
  Future<Session?> build() async {
    final session = await _sessionRepository.getSession();
    state = AsyncData(session);
    return session;
  }

  Future<void> addSession(Transaction txc) async {
    if (state.value == null) {
      final maxID = await _sessionRepository.getMaxID(txc);
      final newSession = await _sessionRepository.addSession(maxID, txc);
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
    await _sessionRepository.updateGameType(session, gameType);
    state = AsyncData(session);
  }

  Future<void> getSession() async {
    final session = await _sessionRepository.getSession();
    state = AsyncData(session);
  }

  Future<void> updateRound(Transaction txc) async {
    if (state.value == null) {
      throw Exception('ゲームは既に終了しており予期せぬエラーが発生しました。');
    }
    final updatedSession = await _sessionRepository.updateRound(
      state.value!,
      txc,
    );

    state = AsyncData(updatedSession);
  }

  Future<void> updateEndTime() async {
    if (state.value == null) {
      throw Exception('ゲームは既に終了しており予期せぬエラーが発生しました。');
    }
    final updatedSession = await _sessionRepository.updateEndTime(state.value!);
    state = AsyncData(updatedSession);
  }

  void disposeSession() {
    state = const AsyncData(null);
  }
}

final sessionNotifierProvider =
    AsyncNotifierProvider<SessionNotifier, Session?>(() {
  return SessionNotifier(SQLiteSessionRepository(
    DatabaseHelper.instance.database,
  ));
});
