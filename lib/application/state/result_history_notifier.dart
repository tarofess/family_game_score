import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:family_game_score/domain/entity/result_history.dart';
import 'package:family_game_score/domain/entity/session.dart';
import 'package:family_game_score/infrastructure/repository/sqlite_result_history_repository.dart';
import 'package:family_game_score/infrastructure/repository/sqlite_session_repository.dart';

class ResultHistoryNotifier extends AsyncNotifier<List<ResultHistory>> {
  final SQLiteResultHistoryRepository _resultHistoryRepository;
  final SQLiteSessionRepository _sessionRepository;

  ResultHistoryNotifier(this._resultHistoryRepository, this._sessionRepository);

  @override
  Future<List<ResultHistory>> build() async {
    final resultHistory = await _resultHistoryRepository.getResultHistory();
    state = AsyncData(resultHistory);
    return resultHistory;
  }

  Future<void> updateSessionGameType(Session session, String gameType) async {
    await _sessionRepository.updateGameType(session, gameType);

    final updatedSession = state.value!.map((e) {
      if (e.session.id == session.id) {
        return e.copyWith(session: e.session.copyWith(gameType: gameType));
      }
      return e;
    }).toList();

    state = AsyncData(updatedSession);
  }
}

final resultHistoryNotifierProvider =
    AsyncNotifierProvider<ResultHistoryNotifier, List<ResultHistory>>(
  () => ResultHistoryNotifier(
    SQLiteResultHistoryRepository(),
    SQLiteSessionRepository(),
  ),
);
