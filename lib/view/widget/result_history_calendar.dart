import 'package:family_game_score/main.dart';
import 'package:family_game_score/service/navigation_service.dart';
import 'package:family_game_score/view/result_history_detail_view.dart';
import 'package:family_game_score/viewmodel/result_history_calendar_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class ResultHistoryCalendar extends ConsumerWidget {
  final NavigationService navigationService = getIt<NavigationService>();
  final ValueNotifier<DateTime> selectedDay;
  final ValueNotifier<DateTime> focusedDay;

  ResultHistoryCalendar(
      {super.key, required this.selectedDay, required this.focusedDay});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(resultHistoryCalendarViewModelProvider);

    return TableCalendar(
      availableGestures: AvailableGestures.none,
      firstDay: DateTime.utc(2024, 1, 1),
      lastDay: DateTime.utc(2123, 12, 31),
      focusedDay: focusedDay.value,
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
      ),
      locale: 'ja_JP',
      eventLoader: (day) => vm.events[day] ?? [],
      onDaySelected: (tappedDay, focused) {
        selectedDay.value = tappedDay;
        focusedDay.value = focused;

        if (vm.hasDataInTappedDay(tappedDay)) {
          navigationService.push(
            context,
            ResultHistoryDetailView(selectedDay: selectedDay.value),
          );
        }
      },
      selectedDayPredicate: (day) {
        return isSameDay(selectedDay.value, day);
      },
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.brown,
          shape: BoxShape.circle,
        ),
        todayTextStyle: TextStyle(color: Colors.white),
        selectedDecoration: BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
        ),
        selectedTextStyle: TextStyle(color: Colors.white),
      ),
    );
  }
}
