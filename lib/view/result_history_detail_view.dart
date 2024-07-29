import 'package:family_game_score/model/entity/result_history.dart';
import 'package:family_game_score/model/entity/session.dart';
import 'package:family_game_score/view/widget/result_card.dart';
import 'package:family_game_score/viewmodel/result_history_detail_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';

class ResultHistoryDetailView extends ConsumerWidget {
  final List<ResultHistory> filteredResultHistories;

  const ResultHistoryDetailView(
      {super.key, required this.filteredResultHistories});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(resultHistoryViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('成績の詳細'),
      ),
      body: buildResultHistoryList(context, vm),
    );
  }

  Widget buildResultHistoryList(
      BuildContext context, ResultHistoryDetailViewModel vm) {
    return GroupedListView<dynamic, String>(
        elements: filteredResultHistories,
        groupBy: (element) => element.session.begTime,
        groupComparator: (value1, value2) => value2.compareTo(value1),
        itemComparator: (item1, item2) =>
            item1.result.rank.compareTo(item2.result.rank),
        groupSeparatorBuilder: (String value) =>
            buildGroupedListSeparator(context, value),
        itemBuilder: (context, dynamic element) => element.player.status == 0
            ? ResultCard(player: element.player, result: element.result)
            : buildPlayerHasBeenDeletedCard(context));
  }

  Widget buildGroupedListSeparator(BuildContext context, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 124, 213, 255),
              Color.fromARGB(255, 54, 154, 255),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '日時  ${value.getFormatBegTime()}',
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Gill Sans'),
          ),
        ),
      ),
    );
  }

  Widget buildPlayerHasBeenDeletedCard(BuildContext context) {
    return const Card(
      elevation: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        title: Text('プレイヤーは削除されました'),
      ),
    );
  }
}
