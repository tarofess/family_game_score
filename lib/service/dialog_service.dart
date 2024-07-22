import 'package:family_game_score/main.dart';
import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/session.dart';
import 'package:family_game_score/service/navigation_service.dart';
import 'package:family_game_score/view/ranking_view.dart';
import 'package:family_game_score/view/widget/common_dialog.dart';
import 'package:family_game_score/viewmodel/provider/player_provider.dart';
import 'package:family_game_score/viewmodel/provider/result_history_provider.dart';
import 'package:family_game_score/viewmodel/provider/result_provider.dart';
import 'package:family_game_score/viewmodel/provider/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DialogService {
  final NavigationService navigationService;

  DialogService(this.navigationService);

  Future showAddPlayerDialog(BuildContext context, WidgetRef ref) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        String inputText = '';
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.enterYourName),
          content: TextField(
            onChanged: (value) {
              inputText = value;
            },
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.playerName,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                navigationService.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await ref.read(playerProvider.notifier).addPlayer(inputText);
                } catch (e) {
                  // ignore: use_build_context_synchronously
                  CommonDialog.showErrorDialog(context, e, NavigationService());
                }
                // ignore: use_build_context_synchronously
                navigationService.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future showEditPlayerDialog(
      BuildContext context, WidgetRef ref, Player player) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        String inputText = player.name;
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.editPlayerName),
          content: TextField(
            onChanged: (value) {
              inputText = value;
            },
            decoration: InputDecoration(
              hintText: player.name,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                navigationService.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await ref
                      .read(playerProvider.notifier)
                      .updatePlayer(player.copyWith(name: inputText));
                  // ignore: unused_result
                  ref.refresh(resultHistoryProvider.future);
                } catch (e) {
                  // ignore: use_build_context_synchronously
                  CommonDialog.showErrorDialog(context, e, NavigationService());
                }
                // ignore: use_build_context_synchronously
                navigationService.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future showDeletePlayerDialog(
      BuildContext context, WidgetRef ref, Player player) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              '${AppLocalizations.of(context)!.deleteConfirmationTitleEn}${player.name}${AppLocalizations.of(context)!.deleteConfirmationTitleJa}'),
          content:
              Text(AppLocalizations.of(context)!.deleteConfirmationMessage),
          actions: [
            TextButton(
              onPressed: () {
                navigationService.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.no),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await ref.read(playerProvider.notifier).deletePlayer(player);
                  // ignore: unused_result
                  ref.refresh(resultHistoryProvider.future);
                } catch (e) {
                  // ignore: use_build_context_synchronously
                  CommonDialog.showErrorDialog(context, e, NavigationService());
                }
                // ignore: use_build_context_synchronously
                navigationService.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.yes),
            ),
          ],
        );
      },
    );
  }

  void showMoveToNextRoundDialog(
      BuildContext context, WidgetRef ref, AsyncValue<Session?> session) {
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
                navigationService.pop(context);
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
                  navigationService.pop(context);
                } catch (e) {
                  // ignore: use_build_context_synchronously
                  navigationService.pop(context);
                  // ignore: use_build_context_synchronously
                  CommonDialog.showErrorDialog(context, e, NavigationService());
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
                navigationService.pop(context);
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
                    navigationService.pushAndRemoveUntil(
                        context, const RankingView());
                  }
                } catch (e) {
                  // ignore: use_build_context_synchronously
                  navigationService.pop(context);
                  // ignore: use_build_context_synchronously
                  CommonDialog.showErrorDialog(context, e, NavigationService());
                }
              },
              child: Text(AppLocalizations.of(context)!.yes),
            ),
          ],
        );
      },
    );
  }

  void showReturnToHomeDialog(BuildContext context, WidgetRef ref) {
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

                navigationService.pop(context);
                navigationService.pushReplacement(context, const MyApp());
              },
              child: Text(AppLocalizations.of(context)!.yes),
            ),
          ],
        );
      },
    );
  }
}
