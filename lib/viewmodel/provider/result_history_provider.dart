import 'package:family_game_score/model/entity/result_history.dart';
import 'package:family_game_score/model/entity/session.dart';
import 'package:family_game_score/model/repository/database_helper.dart';
import 'package:family_game_score/model/repository/result_history_repository.dart';
import 'package:family_game_score/model/repository/session_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqflite/sqflite.dart';

class ResultHistoryNotifier extends AsyncNotifier<List<ResultHistory>> {
  late ResultHistoryRepository resultHistoryRepository;
  Database database;

  ResultHistoryNotifier(this.database);

  @override
  Future<List<ResultHistory>> build() async {
    resultHistoryRepository = ResultHistoryRepository(database);
    final resultHistory = await resultHistoryRepository.getResultHistory();
    state = AsyncData(resultHistory);
    return resultHistory;
  }

  Future<void> updateSessionGameType(Session session, String gameType) async {
    final sessionRepository = SessionRepository(database);
    await sessionRepository.updateGameType(session, gameType);

    final updatedSession = state.value!.map((e) {
      if (e.session.id == session.id) {
        return e.copyWith(session: e.session.copyWith(gameType: gameType));
      }
      return e;
    }).toList();

    state = AsyncData(updatedSession);
  }
}

final resultHistoryProvider =
    AsyncNotifierProvider<ResultHistoryNotifier, List<ResultHistory>>(
        () => ResultHistoryNotifier(DatabaseHelper.instance.database));
