import 'package:family_game_score/provider/player_provider.dart';
import 'package:family_game_score/provider/session_provider.dart';
import 'package:family_game_score/view/scoring_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            data: (playersData) {
              return Center(
                child: ElevatedButton(
                    onPressed: playersData.length >= 2
                        ? () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ScoringView(),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      side: const BorderSide(
                          color: Color.fromARGB(255, 174, 206, 255)),
                      minimumSize: const Size(200, 50),
                    ),
                    child: sessionData == null
                        ? Text(AppLocalizations.of(context)!.gameStart)
                        : Text(AppLocalizations.of(context)!.gameRestart)),
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
                        '${AppLocalizations.of(context)!.errorMessage}\n${error.toString()}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // ignore: unused_result
                        ref.refresh(playerProvider);
                      },
                      child: Text(AppLocalizations.of(context)!.retry),
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
                    '${AppLocalizations.of(context)!.errorMessage}\n${error.toString()}',
                    textAlign: TextAlign.center,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // ignore: unused_result
                    ref.refresh(sessionProvider);
                  },
                  child: Text(AppLocalizations.of(context)!.retry),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
