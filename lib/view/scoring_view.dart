import 'package:family_game_score/provider/player_provider.dart';
import 'package:family_game_score/provider/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScoringView extends ConsumerWidget {
  const ScoringView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider);
    final session = ref.watch(sessionProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('1回戦'),
          leading: IconButton(
            icon: const Icon(Icons.check_circle_outline),
            onPressed: () {
              showFinishGameDialog(context, ref);
            },
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showMoveToNextRoundDialog(context);
                },
                icon: const Icon(Icons.arrow_forward)),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              const Text('現在の順位はこちら↓'),
              Expanded(
                child: session.when(
                  data: (data) => player.when(
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
                                    .read(playerProvider.notifier)
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
          },
          child: const Icon(Icons.description),
        ));
  }

  void showMoveToNextRoundDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('確認'),
          content: const Text('2回戦に進みますか？'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('いいえ'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('はい'),
            ),
          ],
        );
      },
    );
  }

  void showFinishGameDialog(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);

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
                ref
                    .read(sessionProvider.notifier)
                    .updateSession(session.value!);
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
