import 'package:family_game_score/provider/result_history_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';

class ResultHistoryView extends ConsumerWidget {
  const ResultHistoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultHistory = ref.watch(resultHistoryProvider);

    return Scaffold(
      body: resultHistory.when(
        data: (data) => data.isNotEmpty
            ? GroupedListView<dynamic, String>(
                elements: data,
                groupBy: (element) => element.session.begTime,
                groupSeparatorBuilder: (String value) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                itemBuilder: (context, dynamic element) => Card(
                  elevation: 8.0,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 6.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    leading: Text('${element.result.rank}位',
                        style: const TextStyle(fontSize: 14)),
                    title: Text(element.player.name),
                    trailing: Text('${element.result.score}ポイント',
                        style: const TextStyle(fontSize: 14)),
                  ),
                ),
                order: GroupedListOrder.ASC, // optional
              )
            : const Center(child: Text('まだ対戦履歴がありません')),
        error: (error, stackTrace) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'エラーが発生しました\n${error.toString()}',
                    textAlign: TextAlign.center,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // ignore: unused_result
                    ref.refresh(resultHistoryProvider);
                  },
                  child: const Text('リトライ'),
                ),
              ],
            ),
          );
        },
        loading: () => const CircularProgressIndicator(),
      ),
    );
  }
}
