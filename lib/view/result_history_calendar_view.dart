import 'dart:collection';

import 'package:family_game_score/service/navigation_service.dart';
import 'package:family_game_score/view/result_history_detail_view.dart';
import 'package:family_game_score/view/widget/common_async_widget.dart';
import 'package:family_game_score/viewmodel/provider/result_history_provider.dart';
import 'package:family_game_score/viewmodel/result_history_calendar_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:table_calendar/table_calendar.dart';

class ResultHistoryCalendarView extends HookConsumerWidget {
  const ResultHistoryCalendarView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(resultHistoryCalendarViewModelProvider);

    var selectedDay = useState(DateTime.now());
    var focusedDay = useState(DateTime.now());

    int getHashCode(DateTime key) {
      return key.day * 1000000 + key.month * 10000 + key.year;
    }

    final events = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(vm.eventSessions);

    return Scaffold(
        body: vm.resultHistories.when(
            data: (data) => TableCalendar(
                firstDay: DateTime.utc(2024, 1, 1),
                lastDay: DateTime.utc(2123, 12, 31),
                focusedDay: focusedDay.value,
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                ),
                locale: 'ja_JP',
                eventLoader: (day) => events[day] ?? [],
                onDaySelected: (tappedDay, focused) {
                  print(events);
                  handleOnDaySelected(
                      tappedDay, focused, vm, context, selectedDay, focusedDay);
                },
                selectedDayPredicate: (day) {
                  return isSameDay(selectedDay.value, day);
                }),
            loading: () => CommonAsyncWidgets.showLoading(),
            error: (error, stackTrace) =>
                CommonAsyncWidgets.showDataFetchErrorMessage(
                    context, ref, resultHistoryProvider, error)));
  }

  void handleOnDaySelected(
    DateTime tappedDay,
    DateTime focused,
    ResultHistoryCalendarViewModel vm,
    BuildContext context,
    ValueNotifier<DateTime> selectedDay,
    ValueNotifier<DateTime> focusedDay,
  ) {
    selectedDay.value = tappedDay;
    focusedDay.value = focused;

    if (vm.resultHistories.value != null) {
      final filteredResultHistoryies =
          vm.resultHistories.value!.where((element) {
        final elementDate = DateTime.parse(element.session.begTime);
        return isSameDay(elementDate, tappedDay);
      }).toList();
      if (filteredResultHistoryies.isNotEmpty) {
        final navigationService = NavigationService();
        navigationService.push(
            context,
            ResultHistoryDetailView(
              filteredResultHistories: filteredResultHistoryies,
            ));
      }
    }
  }
}
