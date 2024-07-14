import 'package:family_game_score/model/entity/result_history.dart';
import 'package:family_game_score/provider/result_history_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
            ? Center(child: Text(AppLocalizations.of(context)!.noMatchHistory))
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
        loading: () => const CircularProgressIndicator(),
      ),
    );
  }

  Widget buildResultHistoryList(
      BuildContext context, List<ResultHistory> data) {
    return GroupedListView<dynamic, String>(
      elements: data,
      groupBy: (element) => element.session.begTime,
      groupSeparatorBuilder: (String value) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          '${AppLocalizations.of(context)!.resultHistoryHeaderLeading}  $value',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      itemBuilder: (context, dynamic element) => element.player.status == 0
          ? Card(
              elevation: 8.0,
              margin:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                leading: Text(
                    '${element.result.rank}${AppLocalizations.of(context)!.rank}',
                    style: const TextStyle(fontSize: 14)),
                title: Text(element.player.name),
                trailing: Text(
                    '${element.result.score}${AppLocalizations.of(context)!.point}',
                    style: const TextStyle(fontSize: 14)),
              ),
            )
          : Card(
              elevation: 8.0,
              margin:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                title: Text(AppLocalizations.of(context)!.playerHasBeenDeleted),
              ),
            ),
      order: GroupedListOrder.ASC, // optional
    );
  }
}
