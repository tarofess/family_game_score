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
    try {
      resultHistoryRepository = ResultHistoryRepository(database);
      final resultHistory = await resultHistoryRepository.getResultHistory();
      state = AsyncData(resultHistory);
      return resultHistory;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> updateSessionGameType(Session session, String gameType) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final sessionRepository = SessionRepository(database);
      await sessionRepository.updateGameType(session, gameType);

      return state.value!.map((e) {
        if (e.session.id == session.id) {
          return e.copyWith(session: e.session.copyWith(gameType: gameType));
        }
        return e;
      }).toList();
    });
  }
}

final resultHistoryProvider =
    AsyncNotifierProvider<ResultHistoryNotifier, List<ResultHistory>>(
        () => ResultHistoryNotifier(DatabaseHelper.instance.database));
