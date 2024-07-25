import 'package:family_game_score/main.dart';
import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/service/navigation_service.dart';
import 'package:family_game_score/view/ranking_view.dart';
import 'package:family_game_score/viewmodel/provider/player_provider.dart';
import 'package:family_game_score/viewmodel/provider/result_history_provider.dart';
import 'package:family_game_score/viewmodel/provider/result_provider.dart';
import 'package:family_game_score/viewmodel/provider/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DialogService {
  final NavigationService navigationService;
  bool isFinished = false; // pushAndRemoveUntilの直後にpopが呼ばれないようにするためのフラグ

  DialogService(this.navigationService);

  Future<void> showAddPlayerDialog(BuildContext context, WidgetRef ref) {
    return showInputDialog(
        context: context,
        title: '名前を入力してください',
        hintText: 'プレイヤー名',
        action: (String inputText) async {
          handleActionAndError(context, () async {
            await ref.read(playerProvider.notifier).addPlayer(inputText);
          });
        });
  }

  Future<void> showEditPlayerDialog(
      BuildContext context, WidgetRef ref, Player player) {
    return showInputDialog(
        context: context,
        title: 'プレイヤー名を編集してください',
        hintText: player.name,
        action: (String inputText) async {
          handleActionAndError(context, () async {
            await ref
                .read(playerProvider.notifier)
                .updatePlayer(player.copyWith(name: inputText));
            ref.invalidate(resultHistoryProvider);
          });
        });
  }

  Future<void> showDeletePlayerDialog(
      BuildContext context, WidgetRef ref, Player player) {
    return showConfimationDialog(
        context: context,
        title: '${player.name}を削除します',
        content: '削除すると元に戻せませんが本当に削除しますか？',
        action: () async {
          handleActionAndError(context, () async {
            await ref.read(playerProvider.notifier).deletePlayer(player);
            ref.invalidate(resultHistoryProvider);
          });
        });
  }

  Future<void> showMoveToNextRoundDialog(BuildContext context, WidgetRef ref) {
    final session = ref.read(sessionProvider);
    final nextRound =
        session.value != null ? (session.value!.round + 1).toString() : '2';

    return showConfimationDialog(
        context: context,
        title: '確認',
        content: '$nextRound回戦に進みますか？',
        action: () {
          handleActionAndError(context, () async {
            await ref.read(sessionProvider.notifier).addSession();
            await ref.read(sessionProvider.notifier).updateRound();
            await ref.read(resultProvider.notifier).addOrUpdateResult();
          });
        });
  }

  Future<void> showFinishGameDialog(BuildContext context, WidgetRef ref) {
    return showConfimationDialog(
        context: context,
        title: '確認',
        content: 'ゲームを終了しますか？\nゲームが終了すると順位が確定します',
        action: () async {
          handleActionAndError(context, () async {
            await ref.read(sessionProvider.notifier).updateEndTime();
            ref.read(sessionProvider.notifier).disposeSession();
            ref.read(playerProvider.notifier).resetOrder();

            if (context.mounted) {
              isFinished = true;
              navigationService.pushAndRemoveUntil(
                  context, const RankingView());
            }
          });
        });
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
                ref.invalidate(resultProvider);
                ref.invalidate(resultHistoryProvider);
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

  Future<void> showErrorDialog(BuildContext context, dynamic error,
      NavigationService navigationService) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('エラー'),
          content: Text('エラーが発生しました\n${error.toString()}'),
          actions: [
            TextButton(
              onPressed: () {
                navigationService.pop(context);
              },
              child: const Text('閉じる'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showInputDialog(
      {required BuildContext context,
      required String title,
      required String hintText,
      required Function(String) action,
      String confirmText = 'OK',
      String cancelText = 'キャンセル',
      String inputText = ''}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
              onChanged: (value) {
                inputText = value;
              },
              decoration: InputDecoration(hintText: hintText)),
          actions: [
            TextButton(
                onPressed: () {
                  navigationService.pop(context);
                },
                child: Text(cancelText)),
            TextButton(
              onPressed: () => action(inputText),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }

  Future<void> showConfimationDialog({
    required BuildContext context,
    required String title,
    required String content,
    required Function() action,
    String confirmText = '確認',
    String cancelText = 'キャンセル',
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
                onPressed: () {
                  navigationService.pop(context);
                },
                child: const Text('いいえ')),
            TextButton(
              onPressed: () async => await action(),
              child: const Text('はい'),
            )
          ],
        );
      },
    );
  }

  Future<void> handleActionAndError(
      BuildContext context, Future<void> Function() action) async {
    try {
      await action();
    } catch (e) {
      if (context.mounted) {
        await showErrorDialog(context, e, NavigationService());
      }
    } finally {
      if (context.mounted && !isFinished) {
        navigationService.pop(context);
      }
    }
  }
}
