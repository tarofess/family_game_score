import 'package:family_game_score/model/entity/result_history.dart';
import 'package:family_game_score/viewmodel/provider/result_history_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ResultHistoryCalendarViewModel {
  Ref ref;
  ResultHistoryCalendarViewModel(this.ref);

  AsyncValue<List<ResultHistory>> get resultHistories =>
      ref.watch(resultHistoryProvider);

  Map<DateTime, List<int>> get eventSessions {
    Map<DateTime, Set<int>> tempResult = {};
    for (var resultHistory in resultHistories.value ?? []) {
      var date = DateTime.parse(resultHistory.session.begTime);
      date = DateTime(date.year, date.month, date.day);

      tempResult.putIfAbsent(date, () => <int>{}).add(resultHistory.session.id);
    }
    return tempResult.map((key, value) => MapEntry(key, value.toList()));
  }
}

final resultHistoryCalendarViewModelProvider =
    Provider<ResultHistoryCalendarViewModel>((ref) {
  return ResultHistoryCalendarViewModel(ref);
});
