import 'package:family_game_score/provider/player_provider.dart';
import 'package:family_game_score/provider/result_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RankingView extends ConsumerWidget {
  const RankingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultProvider = ref.watch(resultNotifierProvider);
    final players = ref.read(playerNotifierProvider).value!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('現在の順位'),
      ),
      body: resultProvider.when(data: (data) {
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final result = data[index];
            return ListTile(
              title: Text(players
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
              const Text('エラーが発生しました'),
              ElevatedButton(
                onPressed: () {
                  ref.refresh(resultNotifierProvider);
                },
                child: const Text('リトライ'),
              ),
            ],
          ),
        );
      }),
    );
  }
}
