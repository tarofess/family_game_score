import 'package:family_game_score/provider/player_provider.dart';
import 'package:family_game_score/provider/result_provider.dart';
import 'package:family_game_score/provider/session_provider.dart';
import 'package:family_game_score/view/ranking_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScoringView extends ConsumerWidget {
  const ScoringView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerProvider = ref.watch(playerNotifierProvider);
    final sessionProvider = ref.watch(sessionNotifierProvider);

    return Scaffold(
        appBar: AppBar(
          title: Text(
              '${sessionProvider.value != null ? sessionProvider.value!.round.toString() : '1'}回戦'),
          leading: IconButton(
            icon: const Icon(Icons.check_circle_outline),
            onPressed: () {
              showFinishGameDialog(context, ref);
            },
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showMoveToNextRoundDialog(context, ref);
                },
                icon: const Icon(Icons.arrow_forward)),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              const Text('現在の順位はこちら↓'),
              Expanded(
                child: sessionProvider.when(
                  data: (data) => playerProvider.when(
                      data: (data) => data.isNotEmpty
                          ? ReorderableListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  key: Key(data[index].id.toString()),
                                  title: Text(data[index].name),
                                  trailing: ReorderableDragStartListener(
                                    index: index,
                                    child: const Icon(Icons.drag_handle),
                                  ),
                                );
                              },
                              onReorder: (oldIndex, newIndex) {
                                if (oldIndex < newIndex) {
                                  newIndex -= 1;
                                }
                                ref
                                    .read(playerNotifierProvider.notifier)
                                    .reorderPlayer(oldIndex, newIndex);
                              },
                            )
                          : const Text('データがありません'),
                      error: (error, stackTrace) => Text('Error: $error'),
                      loading: () => const CircularProgressIndicator()),
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stackTrace) => Text('Error: $error'),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // RankingViewに遷移
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RankingView()),
            );
          },
          child: const Icon(Icons.description),
        ));
  }

  void showMoveToNextRoundDialog(BuildContext context, WidgetRef ref) {
    final session = ref.read(sessionNotifierProvider);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('確認'),
          content: Text(
              '${session.value != null ? (session.value!.round + 1).toString() : '2'}回戦に進みますか？'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('いいえ'),
            ),
            TextButton(
              onPressed: () {
                ref.read(resultNotifierProvider.notifier).updateResult();
                ref.read(sessionNotifierProvider.notifier).updateRound();
                ref.read(sessionNotifierProvider.notifier).updateSession();
                Navigator.of(context).pop();
              },
              child: const Text('はい'),
            ),
          ],
        );
      },
    );
  }

  void showFinishGameDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('確認'),
          content: const Text('ゲームを終了しますか？\nゲームが終了すると順位が確定します'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('いいえ'),
            ),
            TextButton(
              onPressed: () {
                ref.read(resultNotifierProvider.notifier).updateResult();
                ref.read(sessionNotifierProvider.notifier).updateSession();
                // RankingViewに遷移
              },
              child: const Text('はい'),
            ),
          ],
        );
      },
    );
  }
}
