import 'package:family_game_score/model/entity/result_history.dart';
import 'package:family_game_score/model/entity/session.dart';
import 'package:family_game_score/view/widget/list_card/result_list_card.dart';
import 'package:family_game_score/viewmodel/result_history_detail_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ResultHistoryDetailView extends ConsumerWidget {
  final List<ResultHistorySection> resultHistorySections;

  const ResultHistoryDetailView(
      {super.key, required this.resultHistorySections});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(resultHistoryViewModelProvider);

    return Scaffold(
      appBar: buildAppBar(context, vm),
      body: buildBody(context, vm),
    );
  }

  AppBar buildAppBar(BuildContext context, ResultHistoryDetailViewModel vm) {
    return AppBar(
      centerTitle: true,
      title: const Text('成績の詳細'),
    );
  }

  Widget buildBody(BuildContext context, ResultHistoryDetailViewModel vm) {
    return ListView.builder(
      itemCount: resultHistorySections.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionHeader(index),
            buildSectionItems(index),
          ],
        );
      },
    );
  }

  Widget buildSectionHeader(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
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
            '日時  ${resultHistorySections[index].session.endTime!.getFormatBegTime()}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Gill Sans',
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSectionItems(int index) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: resultHistorySections[index].items.length,
      itemBuilder: (context, itemIndex) {
        return resultHistorySections[index].items[itemIndex].player.status == 0
            ? ResultListCard(
                player: resultHistorySections[index].items[itemIndex].player,
                result: resultHistorySections[index].items[itemIndex].result,
              )
            : buildPlayerHasBeenDeletedCard(context);
      },
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
