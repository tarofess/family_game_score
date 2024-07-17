import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/session.dart';
import 'package:family_game_score/provider/player_provider.dart';
import 'package:family_game_score/provider/session_provider.dart';
import 'package:family_game_score/view/scoring_view.dart';
import 'package:family_game_score/view/widget/common_error_widget.dart';
import 'package:family_game_score/view/widget/gradient_circle_button.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
                  child: buildCenterCircleButton(
                      context, ref, sessionData, playersData));
            },
            loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            error: (error, stackTrace) {
              return CommonErrorWidget.showDataFetchErrorMessage(
                  context, ref, playerProvider, error);
            },
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, stackTrace) {
          return CommonErrorWidget.showDataFetchErrorMessage(
              context, ref, sessionProvider, error);
        },
      ),
    );
  }

  Widget buildCenterCircleButton(BuildContext context, WidgetRef ref,
      Session? sessionData, List<Player> playersData) {
    return GradientCircleButton(
      onPressed: () async {
        playersData.length >= 2
            ? Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const ScoringView(),
                  transitionDuration: const Duration(milliseconds: 800),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    var begin = const Offset(0.0, 1.0);
                    var end = Offset.zero;
                    var curve = Curves.fastLinearToSlowEaseIn;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
              )
            : ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context)!.homeSnackbarMessage,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // backgroundColor: Colors.red,
                ),
              );
      },
      text: sessionData == null
          ? AppLocalizations.of(context)!.gameStart
          : AppLocalizations.of(context)!.gameRestart,
      size: 200.0,
      gradientColors: playersData.length >= 2
          ? const [
              Color.fromARGB(255, 255, 194, 102),
              Color.fromARGB(255, 255, 101, 90)
            ]
          : const [
              Color.fromARGB(255, 223, 223, 223),
              Color.fromARGB(255, 109, 109, 109)
            ],
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Gill Sans',
      ),
    );
  }
}
