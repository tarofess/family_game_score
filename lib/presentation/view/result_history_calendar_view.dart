import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:family_game_score/presentation/widget/async_error_widget.dart';
import 'package:family_game_score/presentation/widget/result_history_calendar.dart';
import 'package:family_game_score/application/state/result_history_notifier.dart';

class ResultHistoryCalendarView extends HookConsumerWidget {
  const ResultHistoryCalendarView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultHistoryState = ref.watch(resultHistoryNotifierProvider);
    var selectedDay = useState(DateTime.now());
    var focusedDay = useState(DateTime.now());

    return Scaffold(
      body: resultHistoryState.when(
        data: (resultHistories) => SingleChildScrollView(
          child: ResultHistoryCalendar(
            resultHistories: resultHistories,
            selectedDay: selectedDay,
            focusedDay: focusedDay,
          ),
        ),
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, stackTrace) {
          return AsyncErrorWidget(
            error: error,
            retry: () => resultHistoryState,
          );
        },
      ),
    );
  }
}
