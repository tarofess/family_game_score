import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:family_game_score/application/state/result_history_notifier.dart';
import 'package:family_game_score/domain/entity/result_history.dart';
import 'package:family_game_score/main.dart';
import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/infrastructure/service/dialog_service.dart';
import 'package:family_game_score/presentation/widget/async_error_widget.dart';
import 'package:family_game_score/presentation/widget/list_card/result_list_card.dart';
import 'package:family_game_score/domain/entity/session.dart';

class ResultHistoryDetailView extends ConsumerWidget {
  final DateTime selectedDay;
  final dialogService = getIt<DialogService>();

  ResultHistoryDetailView({super.key, required this.selectedDay});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultHistoryState = ref.watch(resultHistoryNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 56.r,
        title: Text('成績の詳細', style: TextStyle(fontSize: 20.sp)),
      ),
      body: resultHistoryState.when(
        data: (resultHistories) {
          return ListView.builder(
            itemCount: getResultHistorySections(resultHistories).length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSectionHeader(context, ref, resultHistories, index),
                  buildSectionItems(ref, resultHistories, index),
                ],
              );
            },
          );
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
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

  Widget buildSectionHeader(
    BuildContext context,
    WidgetRef ref,
    List<ResultHistory> resultHistories,
    int index,
  ) {
    return GestureDetector(
      onTap: () async => await dialogService.showEditGameTypeDialog(context,
          ref, getResultHistorySections(resultHistories)[index].session),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 139, 218, 255),
                Color.fromARGB(255, 54, 154, 255),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: getResultHistorySections(resultHistories)[index]
                        .session
                        .gameType ==
                    null
                ? const Text('')
                : Text(
                    '${getResultHistorySections(resultHistories)[index].session.gameType}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.white,
                          fontSize: 20.sp,
                        ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget buildSectionItems(
    WidgetRef ref,
    List<ResultHistory> resultHistories,
    int index,
  ) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: getResultHistorySections(resultHistories)[index].items.length,
      itemBuilder: (context, itemIndex) {
        return getResultHistorySections(resultHistories)[index]
                    .items[itemIndex]
                    .player
                    .status ==
                -1
            ? buildPlayerHasBeenDeletedCard(
                getResultHistorySections(resultHistories)[index]
                    .items[itemIndex]
                    .player)
            : ResultListCard(
                key: ValueKey(
                  getResultHistorySections(resultHistories)[index]
                      .items[itemIndex]
                      .result
                      .id,
                ),
                player: getResultHistorySections(resultHistories)[index]
                    .items[itemIndex]
                    .player,
                result: getResultHistorySections(resultHistories)[index]
                    .items[itemIndex]
                    .result,
              );
      },
    );
  }

  Widget buildPlayerHasBeenDeletedCard(Player player) {
    return Card(
      elevation: 2.r,
      margin: EdgeInsets.symmetric(horizontal: 10.r, vertical: 6.r),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 10.r),
        title: Text(
          'プレイヤー：${player.name}は削除されました。',
          style: TextStyle(fontSize: 14.sp),
        ),
      ),
    );
  }

  List<ResultHistorySection> getResultHistorySections(
    List<ResultHistory> resultHistories,
  ) {
    final filteredResultHistoryies = resultHistories.where((element) {
      final elementDate = DateTime.parse(element.session.endTime!);
      return isSameDay(elementDate, selectedDay);
    }).toList();

    if (filteredResultHistoryies.isNotEmpty) {
      final convertedResultHistorySection =
          convertToResultHistorySection(filteredResultHistoryies);
      return convertedResultHistorySection;
    }

    return [];
  }

  List<ResultHistorySection> convertToResultHistorySection(
      List<ResultHistory> resultHistories) {
    Map<int, List<ResultHistoryItems>> sessionItemsMap = {};

    for (var resultHistory in resultHistories) {
      int sessionId = resultHistory.session.id;
      if (!sessionItemsMap.containsKey(sessionId)) {
        sessionItemsMap[sessionId] = [];
      }
      sessionItemsMap[sessionId]!.add(ResultHistoryItems(
        player: resultHistory.player,
        result: resultHistory.result,
      ));
    }

    List<ResultHistorySection> sessionResultHistories = [];
    for (var entry in sessionItemsMap.entries) {
      int sessionId = entry.key;
      List<ResultHistoryItems> items = entry.value;

      Session session = resultHistories
          .firstWhere((history) => history.session.id == sessionId)
          .session;

      sessionResultHistories.add(ResultHistorySection(
        session: session,
        items: items,
      ));
    }

    return sessionResultHistories;
  }
}
