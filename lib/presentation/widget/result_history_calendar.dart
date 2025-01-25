import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:family_game_score/domain/entity/result_history.dart';

class ResultHistoryCalendar extends ConsumerWidget {
  final List<ResultHistory> resultHistories;
  final ValueNotifier<DateTime> selectedDay;
  final ValueNotifier<DateTime> focusedDay;
  late final LinkedHashMap<DateTime, List> events;

  ResultHistoryCalendar({
    super.key,
    required this.resultHistories,
    required this.selectedDay,
    required this.focusedDay,
  }) {
    initializeEvents();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TableCalendar(
      availableGestures: AvailableGestures.none,
      firstDay: DateTime.utc(2024, 1, 1),
      lastDay: DateTime.utc(2123, 12, 31),
      focusedDay: focusedDay.value,
      headerStyle: const HeaderStyle(formatButtonVisible: false),
      locale: 'ja_JP',
      rowHeight: 52.r,
      eventLoader: (day) => events[day] ?? [],
      onDaySelected: (tappedDay, focused) {
        selectedDay.value = tappedDay;
        focusedDay.value = focused;

        if (hasDataInTappedDay(tappedDay)) {
          context.push('/result_history_detail_page', extra: {
            'selectedDay': selectedDay.value,
          });
        }
      },
      selectedDayPredicate: (day) {
        return isSameDay(selectedDay.value, day);
      },
      calendarStyle: CalendarStyle(
        todayDecoration: const BoxDecoration(
          color: Colors.brown,
          shape: BoxShape.circle,
        ),
        todayTextStyle: TextStyle(fontSize: 14.sp, color: Colors.white),
        selectedDecoration: const BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
        ),
        selectedTextStyle: TextStyle(fontSize: 14.sp, color: Colors.white),
        defaultTextStyle: TextStyle(fontSize: 14.sp),
        weekendTextStyle: TextStyle(fontSize: 14.sp),
        outsideTextStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(fontSize: 14.sp),
        weekendStyle: TextStyle(fontSize: 14.sp),
      ),
      daysOfWeekHeight: 24.r,
    );
  }

  Map<DateTime, List<int>> get eventSessions {
    Map<DateTime, Set<int>> tempResult = {};
    for (var resultHistory in resultHistories) {
      var date = DateTime.parse(resultHistory.session.endTime ?? '');
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

  bool hasDataInTappedDay(DateTime tappedDay) {
    return events[tappedDay] != null;
  }
}
