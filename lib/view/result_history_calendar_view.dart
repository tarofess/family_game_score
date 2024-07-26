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
                eventLoader: (day) => vm.events[day] ?? [],
                onDaySelected: (tappedDay, focused) {
                  vm.handleOnDaySelected(
                      tappedDay, focused, context, selectedDay, focusedDay);
                },
                selectedDayPredicate: (day) {
                  return isSameDay(selectedDay.value, day);
                }),
            loading: () => CommonAsyncWidgets.showLoading(),
            error: (error, stackTrace) =>
                CommonAsyncWidgets.showDataFetchErrorMessage(
                    context, ref, resultHistoryProvider, error)));
  }
}