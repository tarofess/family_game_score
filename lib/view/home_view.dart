import 'package:family_game_score/provider/player_provider.dart';
import 'package:family_game_score/provider/session_provider.dart';
import 'package:family_game_score/view/scoring_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.watch(playerProvider);
    final session = ref.watch(sessionProvider);

    return Scaffold(
      body: session.when(
        data: (sessionData) {
          return players.when(
            data: (data) {
              return Center(
                child: ElevatedButton(
                  onPressed: data.isNotEmpty
                      ? () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ScoringView(),
                            ),
                          );
                        }
                      : null,
                  child: sessionData == null
                      ? const Text('ゲームスタート！')
                      : const Text('ゲーム再開！'),
                ),
              );
            },
            loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
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
                        ref.refresh(playerProvider);
                      },
                      child: const Text('リトライ'),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
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
                    ref.refresh(sessionProvider);
                  },
                  child: const Text('リトライ'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
