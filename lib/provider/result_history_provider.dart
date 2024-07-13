import 'package:family_game_score/model/entity/result_history.dart';
import 'package:family_game_score/model/repository/database_helper.dart';
import 'package:family_game_score/model/repository/result_history_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

class ResultHistoryNotifier
    extends AutoDisposeAsyncNotifier<List<ResultHistory>> {
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
}

final resultHistoryProvider = AsyncNotifierProvider.autoDispose<
        ResultHistoryNotifier, List<ResultHistory>>(
    () => ResultHistoryNotifier(DatabaseHelper.instance.database));
