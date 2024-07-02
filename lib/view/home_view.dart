import 'package:family_game_score/provider/player_provider.dart';
import 'package:family_game_score/view/scoring_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider);

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: player.value != null && player.value!.isNotEmpty
              ? () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ScoringView()),
                  );
                }
              : null,
          child: const Text('ゲームスタート！'),
        ),
      ),
    );
  }
}
