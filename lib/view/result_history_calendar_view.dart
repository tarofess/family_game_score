import 'package:family_game_score/main.dart';
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
  final NavigationService navigationService = getIt<NavigationService>();

  ResultHistoryCalendarView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(resultHistoryCalendarViewModelProvider);

    var selectedDay = useState(DateTime.now());
    var focusedDay = useState(DateTime.now());

    return Scaffold(
      body: vm.resultHistories.when(
        data: (_) => SingleChildScrollView(
          child: TableCalendar(
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
              navigationService.push(context,
                  ResultHistoryDetailView(selectedDay: selectedDay.value));
            },
            selectedDayPredicate: (day) {
              return isSameDay(selectedDay.value, day);
            },
          ),
        ),
        loading: () => CommonAsyncWidgets.showLoading(),
        error: (error, stackTrace) =>
            CommonAsyncWidgets.showDataFetchErrorMessage(
                context, ref, resultHistoryProvider, error),
      ),
    );
  }
}
