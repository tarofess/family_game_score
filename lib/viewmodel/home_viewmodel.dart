import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/session.dart';
import 'package:family_game_score/view/scoring_view.dart';
import 'package:family_game_score/viewmodel/provider/player_provider.dart';
import 'package:family_game_score/viewmodel/provider/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeViewModel {
  final Ref ref;

  HomeViewModel(this.ref);

  AsyncValue<List<Player>> get players => ref.watch(playerProvider);
  AsyncValue<Session?> get session => ref.watch(sessionProvider);

  void handleButtonPress(BuildContext context, List<Player> players) {
    canStartGame(players)
        ? navigateToScoringView(context)
        : showSnackBarMessage(context);
  }

  bool canStartGame(List<Player> players) => players.length >= 2;

  void navigateToScoringView(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const ScoringView(),
        transitionDuration: const Duration(milliseconds: 800),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.fastLinearToSlowEaseIn;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  void showSnackBarMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.homeSnackbarMessage,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  String getButtonText(Session? sessionData, BuildContext context) {
    return sessionData == null
        ? AppLocalizations.of(context)!.gameStart
        : AppLocalizations.of(context)!.gameRestart;
  }

  List<Color> getGradientColors(List<Player> players) {
    return canStartGame(players)
        ? const [
            Color.fromARGB(255, 255, 194, 102),
            Color.fromARGB(255, 255, 101, 90)
          ]
        : const [
            Color.fromARGB(255, 223, 223, 223),
            Color.fromARGB(255, 109, 109, 109)
          ];
  }
}

final homeViewModelProvider = Provider((ref) => HomeViewModel(ref));
