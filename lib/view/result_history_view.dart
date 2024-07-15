import 'package:family_game_score/model/entity/result_history.dart';
import 'package:family_game_score/model/entity/session.dart';
import 'package:family_game_score/provider/result_history_provider.dart';
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
            ? Center(
                child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(AppLocalizations.of(context)!.noMatchHistory,
                    style: const TextStyle(fontSize: 18)),
              ))
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
      groupComparator: (value1, value2) => value2.compareTo(value1),
      groupSeparatorBuilder: (String value) => Padding(
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
    );
  }
}
