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

class DialogService {
  final NavigationService navigationService;

  DialogService(this.navigationService);

  Future showAddPlayerDialog(BuildContext context, WidgetRef ref) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        String inputText = '';
        return AlertDialog(
          title: const Text('名前を入力してください'),
          content: TextField(
            onChanged: (value) {
              inputText = value;
            },
            decoration: const InputDecoration(
              hintText: 'プレイヤー名',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                navigationService.pop(context);
              },
              child: const Text('キャンセル'),
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
          title: const Text('プレイヤー名を編集してください'),
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
              child: const Text('キャンセル'),
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
          title: Text('${player.name}を削除します'),
          content: const Text('削除すると元に戻せませんが本当に削除しますか？'),
          actions: [
            TextButton(
              onPressed: () {
                navigationService.pop(context);
              },
              child: const Text('いいえ'),
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
              child: const Text('はい'),
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
          title: const Text('確認'),
          content: Text(
              '${session.value != null ? (session.value!.round + 1).toString() : '2'}回戦に進みますか？'),
          actions: [
            TextButton(
              onPressed: () {
                navigationService.pop(context);
              },
              child: const Text('いいえ'),
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
              child: const Text('はい'),
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
          title: const Text('確認'),
          content: const Text('ゲームを終了しますか？\nゲームが終了すると順位が確定します'),
          actions: [
            TextButton(
              onPressed: () {
                navigationService.pop(context);
              },
              child: const Text('いいえ'),
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
              child: const Text('はい'),
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
          title: const Text('お疲れ様でした！'),
          content: const Text('ホーム画面に戻ります'),
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
              child: const Text('はい'),
            ),
          ],
        );
      },
    );
  }
}
