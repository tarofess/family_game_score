import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/result.dart';
import 'package:family_game_score/model/entity/session.dart';
import 'package:family_game_score/view/ranking_view.dart';
import 'package:family_game_score/view/widget/common_dialog.dart';
import 'package:family_game_score/viewmodel/provider/player_provider.dart';
import 'package:family_game_score/viewmodel/provider/result_provider.dart';
import 'package:family_game_score/viewmodel/provider/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScoringViewModel {
  final Ref ref;

  ScoringViewModel(this.ref);

  AsyncValue<List<Player>> get players => ref.watch(playerProvider);
  AsyncValue<Session?> get session => ref.watch(sessionProvider);
  AsyncValue<List<Result>> get results => ref.watch(resultProvider);

  Widget getAppBarTitle(BuildContext context) {
    return Text(
        '${session.value == null ? '1' : session.value!.round.toString()}${AppLocalizations.of(context)!.round}');
  }

  VoidCallback? getExitButtonCallback(BuildContext context, WidgetRef ref) {
    if (results.hasValue && session.value != null) {
      return () => showFinishGameDialog(context, ref);
    }
    return null;
  }

  VoidCallback? getCheckButtonCallback(BuildContext context, WidgetRef ref) {
    if (results.hasValue) {
      return () => showMoveToNextRoundDialog(context, ref);
    }
    return null;
  }

  VoidCallback? getFloatingActionButtonCallback(
      BuildContext context, WidgetRef ref) {
    if (session.value != null) {
      return () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RankingView()),
          );
    }
    return null;
  }

  Color? getFloatingActionButtonColor() {
    return session.value != null ? null : Colors.grey[300];
  }

  void showMoveToNextRoundDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.confirmation),
          content: Text(
              '${AppLocalizations.of(context)!.moveToNextRoundDialogMessageEn}${session.value != null ? (session.value!.round + 1).toString() : '2'}${AppLocalizations.of(context)!.moveToNextRoundDialogMessageRoundEn}${AppLocalizations.of(context)!.moveToNextRoundDialogMessageJa}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.no),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await ref.read(sessionProvider.notifier).addSession();
                  await ref.read(sessionProvider.notifier).updateRound();
                  await ref.read(resultProvider.notifier).addOrUpdateResult();

                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                } catch (e) {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                  // ignore: use_build_context_synchronously
                  CommonDialog.showErrorDialog(context, e);
                }
              },
              child: Text(AppLocalizations.of(context)!.yes),
            ),
          ],
        );
      },
    );
  }

  void showFinishGameDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.confirmation),
          content: Text(
              AppLocalizations.of(context)!.finishDialogMessageInScoringView),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.no),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await ref.read(sessionProvider.notifier).updateEndTime();
                  ref.read(sessionProvider.notifier).disposeSession();
                  ref.read(playerProvider.notifier).resetOrder();

                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const RankingView(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  }
                } catch (e) {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                  // ignore: use_build_context_synchronously
                  CommonDialog.showErrorDialog(context, e);
                }
              },
              child: Text(AppLocalizations.of(context)!.yes),
            ),
          ],
        );
      },
    );
  }
}

final scoringViewModelProvider = Provider((ref) => ScoringViewModel(ref));
