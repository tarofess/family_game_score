import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:family_game_score/others/viewmodel/result_history_calendar_viewmodel.dart';

class ResultHistoryCalendar extends ConsumerWidget {
  final ValueNotifier<DateTime> selectedDay;
  final ValueNotifier<DateTime> focusedDay;

  const ResultHistoryCalendar({
    super.key,
    required this.selectedDay,
    required this.focusedDay,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(resultHistoryCalendarViewModelProvider);

    return TableCalendar(
      availableGestures: AvailableGestures.none,
      firstDay: DateTime.utc(2024, 1, 1),
      lastDay: DateTime.utc(2123, 12, 31),
      focusedDay: focusedDay.value,
      headerStyle: const HeaderStyle(formatButtonVisible: false),
      locale: 'ja_JP',
      rowHeight: 52.r,
      eventLoader: (day) => vm.events[day] ?? [],
      onDaySelected: (tappedDay, focused) {
        selectedDay.value = tappedDay;
        focusedDay.value = focused;

        if (vm.hasDataInTappedDay(tappedDay)) {
          context.push('/result_history_detail_view', extra: {
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
}
