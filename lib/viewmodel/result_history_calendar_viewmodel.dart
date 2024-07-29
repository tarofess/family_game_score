import 'dart:collection';

import 'package:family_game_score/model/entity/result_history.dart';
import 'package:family_game_score/viewmodel/provider/result_history_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class ResultHistoryCalendarViewModel {
  Ref ref;
  late LinkedHashMap<DateTime, List> events;

  ResultHistoryCalendarViewModel(this.ref) {
    initializeEvents();
  }

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

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  void initializeEvents() {
    events = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(eventSessions);
  }

  void handleOnDaySelected(
    DateTime tappedDay,
    DateTime focused,
    ValueNotifier<DateTime> selectedDay,
    ValueNotifier<DateTime> focusedDay,
    Function(List<ResultHistory>) onShowResultHistoryDetailView,
  ) {
    selectedDay.value = tappedDay;
    focusedDay.value = focused;

    if (resultHistories.value != null) {
      final filteredResultHistoryies = resultHistories.value!.where((element) {
        final elementDate = DateTime.parse(element.session.begTime);
        return isSameDay(elementDate, tappedDay);
      }).toList();

      if (filteredResultHistoryies.isNotEmpty) {
        onShowResultHistoryDetailView(filteredResultHistoryies);
      }
    }
  }
}

final resultHistoryCalendarViewModelProvider =
    Provider<ResultHistoryCalendarViewModel>((ref) {
  return ResultHistoryCalendarViewModel(ref);
});
