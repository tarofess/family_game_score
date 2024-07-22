import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/session.dart';
import 'package:family_game_score/service/navigation_service.dart';
import 'package:family_game_score/service/snackbar_service.dart';
import 'package:family_game_score/view/scoring_view.dart';
import 'package:family_game_score/viewmodel/provider/player_provider.dart';
import 'package:family_game_score/viewmodel/provider/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeViewModel {
  final Ref ref;
  final NavigationService navigationService;
  final SnackbarService snackbarService;

  HomeViewModel(this.ref, this.navigationService, this.snackbarService);

  AsyncValue<List<Player>> get players => ref.watch(playerProvider);
  AsyncValue<Session?> get session => ref.watch(sessionProvider);

  void handleButtonPress(BuildContext context, List<Player> players) {
    canStartGame(players)
        ? navigationService.pushReplacementWithAnimationFromBottom(
            context, const ScoringView())
        : snackbarService.showHomeViewSnackBar(context);
  }

  bool canStartGame(List<Player> players) => players.length >= 2;

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

final homeViewModelProvider = Provider(
    (ref) => HomeViewModel(ref, NavigationService(), SnackbarService()));
