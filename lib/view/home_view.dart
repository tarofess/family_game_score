import 'package:family_game_score/provider/player_provider.dart';
import 'package:family_game_score/view/scoring_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerProvider = ref.watch(playerNotifierProvider);

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed:
              playerProvider.value != null && playerProvider.value!.isNotEmpty
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
