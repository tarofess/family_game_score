import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/result.dart';
import 'package:family_game_score/model/entity/session.dart';
import 'package:family_game_score/service/dialog_service.dart';
import 'package:family_game_score/service/navigation_service.dart';
import 'package:family_game_score/viewmodel/provider/player_provider.dart';
import 'package:family_game_score/viewmodel/provider/result_provider.dart';
import 'package:family_game_score/viewmodel/provider/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RankingViewModel {
  final Ref ref;
  final DialogService dialogService;

  RankingViewModel(this.ref, this.dialogService);

  AsyncValue<List<Result>> get results => ref.watch(resultProvider);
  AsyncValue<List<Player>> get players => ref.watch(playerProvider);
  AsyncValue<Session?> get session => ref.watch(sessionProvider);

  Widget getAppBarTitle(BuildContext context) {
    return session.value == null
        ? Text(AppLocalizations.of(context)!.announcementOfResults)
        : Text(AppLocalizations.of(context)!.currentRanking);
  }

  Widget getIconButton(BuildContext context, WidgetRef ref) {
    return session.value == null
        ? IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              dialogService.showReturnToHomeDialog(context, ref);
            },
          )
        : const SizedBox();
  }
}

final rankingViewModelProvider = Provider(
    (ref) => RankingViewModel(ref, DialogService(NavigationService())));
