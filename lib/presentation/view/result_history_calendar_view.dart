import 'package:family_game_score/presentation/widget/common_async_widget.dart';
import 'package:family_game_score/presentation/widget/result_history_calendar.dart';
import 'package:family_game_score/application/state/result_history_notifier.dart';
import 'package:family_game_score/others/viewmodel/result_history_calendar_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ResultHistoryCalendarView extends HookConsumerWidget {
  const ResultHistoryCalendarView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(resultHistoryCalendarViewModelProvider);
    var selectedDay = useState(DateTime.now());
    var focusedDay = useState(DateTime.now());

    return Scaffold(
      body: vm.resultHistories.when(
        data: (_) => SingleChildScrollView(
          child: ResultHistoryCalendar(
            selectedDay: selectedDay,
            focusedDay: focusedDay,
          ),
        ),
        loading: () => CommonAsyncWidgets.showLoading(),
        error: (error, stackTrace) =>
            CommonAsyncWidgets.showDataFetchErrorMessage(
                context, ref, resultHistoryNotifierProvider, error),
      ),
    );
  }
}
