import 'package:family_game_score/model/entity/result_history.dart';
import 'package:family_game_score/model/repository/result_history_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResultHistoryNotifier
    extends AutoDisposeAsyncNotifier<List<ResultHistory>> {
  @override
  Future<List<ResultHistory>> build() async {
    try {
      final resultHistoryRepository = ResultHistoryRepository();
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
    ResultHistoryNotifier, List<ResultHistory>>(() => ResultHistoryNotifier());
