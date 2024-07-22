import 'package:family_game_score/main.dart';
import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/result.dart';
import 'package:family_game_score/model/entity/session.dart';
import 'package:family_game_score/view/widget/sakura_painter.dart';
import 'package:family_game_score/viewmodel/provider/player_provider.dart';
import 'package:family_game_score/viewmodel/provider/result_history_provider.dart';
import 'package:family_game_score/viewmodel/provider/result_provider.dart';
import 'package:family_game_score/viewmodel/provider/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RankingViewModel {
  final Ref ref;

  RankingViewModel(this.ref);

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
              showFinishDialog(context, ref);
            },
          )
        : const SizedBox();
  }

  Widget getSakuraAnimation(ValueNotifier<List<SakuraPetal>> petals) {
    return session.value == null
        ? CustomPaint(
            painter: SakuraPainter(petals.value),
            child: Container(),
          )
        : const SizedBox();
  }

  void showFinishDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              AppLocalizations.of(context)!.finishDialogTitleInRankingView),
          content: Text(
              AppLocalizations.of(context)!.finishDialogMessageInRankingView),
          actions: [
            TextButton(
              onPressed: () {
                // ignore: unused_result
                ref.refresh(resultProvider.future);
                // ignore: unused_result
                ref.refresh(resultHistoryProvider.future);

                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()),
                );
              },
              child: Text(AppLocalizations.of(context)!.yes),
            ),
          ],
        );
      },
    );
  }
}

final rankingViewModelProvider = Provider((ref) => RankingViewModel(ref));
