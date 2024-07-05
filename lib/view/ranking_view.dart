import 'package:family_game_score/main.dart';
import 'package:family_game_score/provider/player_provider.dart';
import 'package:family_game_score/provider/result_provider.dart';
import 'package:family_game_score/provider/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RankingView extends ConsumerWidget {
  const RankingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(resultProvider);
    final players = ref.read(playerProvider);
    final session = ref.read(sessionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('現在の順位'),
        actions: [
          if (session.value == null)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                showFinishDialog(context);
              },
            ),
        ],
      ),
      body: results.when(data: (data) {
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final result = data[index];
            return ListTile(
              title: Text(players.value!
                  .where((player) => player.id == result.playerId)
                  .first
                  .name),
              subtitle: Text(result.score.toString()),
            );
          },
        );
      }, loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }, error: (error, stackTrace) {
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
                  ref.refresh(resultProvider);
                },
                child: const Text('リトライ'),
              ),
            ],
          ),
        );
      }),
    );
  }

  void showFinishDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('お疲れ様でした！'),
          content: const Text('ホーム画面に戻ります'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()),
                );
              },
              child: const Text('はい'),
            ),
          ],
        );
      },
    );
  }
}
