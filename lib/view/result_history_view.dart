import 'package:family_game_score/model/entity/result_history.dart';
import 'package:family_game_score/model/entity/session.dart';
import 'package:family_game_score/view/widget/result_card.dart';
import 'package:family_game_score/viewmodel/provider/result_history_provider.dart';
import 'package:family_game_score/view/widget/common_async_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResultHistoryView extends ConsumerWidget {
  const ResultHistoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultHistory = ref.watch(resultHistoryProvider);

    return Scaffold(
      body: resultHistory.when(
        data: (data) => data.isEmpty
            ? buildNoMatchHistoryMessage(context)
            : buildResultHistoryList(context, data),
        error: (error, stackTrace) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    '${AppLocalizations.of(context)!.errorMessage}\n${error.toString()}',
                    textAlign: TextAlign.center,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // ignore: unused_result
                    ref.refresh(resultHistoryProvider);
                  },
                  child: Text(AppLocalizations.of(context)!.retry),
                ),
              ],
            ),
          );
        },
        loading: () => CommonAsyncWidgets.showLoading(),
      ),
    );
  }

  Widget buildNoMatchHistoryMessage(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(AppLocalizations.of(context)!.noMatchHistory,
          style: const TextStyle(fontSize: 18)),
    ));
  }

  Widget buildResultHistoryList(
      BuildContext context, List<ResultHistory> resultHistory) {
    return GroupedListView<dynamic, String>(
      elements: resultHistory,
      groupBy: (element) => element.session.begTime,
      groupComparator: (value1, value2) => value2.compareTo(value1),
      itemComparator: (item1, item2) =>
          item1.result.rank.compareTo(item2.result.rank),
      groupSeparatorBuilder: (String value) =>
          buildGroupedListSeparator(context, value),
      itemBuilder: (context, dynamic element) => element.player.status == 0
          ? ResultCard(player: element.player, result: element.result)
          : buildPlayerHasBeenDeletedCard(context),
    );
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
            '${AppLocalizations.of(context)!.resultHistoryHeaderLeading}  ${value.getFormatBegTime()}',
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

  Widget buildPlayerHasBeenDeletedCard(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        title: Text(AppLocalizations.of(context)!.playerHasBeenDeleted),
      ),
    );
  }
}
