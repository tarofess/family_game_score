import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/result.dart';
import 'package:family_game_score/model/entity/session.dart';
import 'package:family_game_score/service/dialog_service.dart';
import 'package:family_game_score/service/navigation_service.dart';
import 'package:family_game_score/view/ranking_view.dart';
import 'package:family_game_score/viewmodel/provider/player_provider.dart';
import 'package:family_game_score/viewmodel/provider/result_provider.dart';
import 'package:family_game_score/viewmodel/provider/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ScoringViewModel {
  final Ref ref;
  final DialogService dialogService;
  final NavigationService navigationService;

  ScoringViewModel(this.ref, this.dialogService, this.navigationService);

  AsyncValue<List<Player>> get players => ref.watch(playerProvider);
  AsyncValue<Session?> get session => ref.watch(sessionProvider);
  AsyncValue<List<Result>> get results => ref.watch(resultProvider);

  Widget getAppBarTitle(BuildContext context) {
    return Text(
        '${session.value == null ? '1' : session.value!.round.toString()}回戦');
  }

  VoidCallback? getExitButtonCallback(BuildContext context, WidgetRef ref) {
    if (results.hasValue && session.value != null) {
      return () => dialogService.showFinishGameDialog(context, ref);
    }
    return null;
  }

  VoidCallback? getCheckButtonCallback(BuildContext context, WidgetRef ref) {
    if (results.hasValue) {
      return () =>
          dialogService.showMoveToNextRoundDialog(context, ref, session);
    }
    return null;
  }

  VoidCallback? getFloatingActionButtonCallback(
      BuildContext context, WidgetRef ref) {
    if (session.value != null) {
      return () => navigationService.push(context, const RankingView());
    }
    return null;
  }

  Color? getFloatingActionButtonColor() {
    return session.value == null ? Colors.grey[300] : null;
  }
}

final scoringViewModelProvider = Provider((ref) => ScoringViewModel(
    ref, DialogService(NavigationService()), NavigationService()));
