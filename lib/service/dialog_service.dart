import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/session.dart';
import 'package:family_game_score/model/repository/database_helper.dart';
import 'package:family_game_score/view/widget/loading_overlay.dart';
import 'package:family_game_score/viewmodel/provider/player_provider.dart';
import 'package:family_game_score/viewmodel/provider/result_history_provider.dart';
import 'package:family_game_score/viewmodel/provider/result_provider.dart';
import 'package:family_game_score/viewmodel/provider/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class DialogService {
  Future<bool> showDeletePlayerDialog(
      BuildContext context, WidgetRef ref, Player player) async {
    final result = await showConfimationBaseDialog(
        context: context,
        title: 'プレイヤー：${player.name}を削除しますか？',
        content: '削除すると元に戻せませんが、本当に削除しますか？',
        action: (BuildContext dialogContext) async {
          await ref.read(playerProvider.notifier).deletePlayer(player);
          ref.invalidate(resultHistoryProvider);
        });
    return result ?? false;
  }

  Future<void> showMoveToNextRoundDialog(
      BuildContext context, WidgetRef ref) async {
    final session = ref.read(sessionProvider).value;
    final nextRound = session != null ? (session.round + 1).toString() : '2';

    await showConfimationBaseDialog(
        context: context,
        title: '確認',
        content: '$nextRound回戦に進みますか？',
        action: (BuildContext dialogContext) async {
          await DatabaseHelper.instance.database.transaction((txc) async {
            await ref.read(sessionProvider.notifier).addSession(txc);
            await ref.read(sessionProvider.notifier).updateRound(txc);
            await ref.read(resultProvider.notifier).addOrUpdateResult(txc);
          });
        },
        onRollBack: () async {
          await ref.read(sessionProvider.notifier).getSession();
        });
  }

  Future<bool> showFinishGameDialog(BuildContext context, WidgetRef ref) async {
    final result = await showConfimationBaseDialog(
        context: context,
        title: '確認',
        content: 'ゲームを終了しますか？\nゲームが終了すると順位が確定します',
        action: (BuildContext dialogContext) async {
          await ref.read(sessionProvider.notifier).updateEndTime();
        });
    return result ?? false;
  }

  Future<bool> showReturnToHomeDialog(
      BuildContext context, WidgetRef ref) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('お疲れ様でした！'),
          content: const Text('ホーム画面に戻ります'),
          actions: [
            TextButton(
              onPressed: () {
                ref.invalidate(resultProvider);
                ref.invalidate(resultHistoryProvider);
                ref.invalidate(playerProvider);
                ref.read(sessionProvider.notifier).disposeSession();
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('はい'),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  Future<void> showErrorDialog(BuildContext context, dynamic error) async {
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('エラー発生'),
          content: Text(error.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('はい'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showPermissionDeniedDialog(
      BuildContext context, String content) async {
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('権限エラー'),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('はい'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showPermissionPermanentlyDeniedDialog(
      BuildContext context, String content) async {
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('権限エラー'),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('いいえ'),
            ),
            TextButton(
              onPressed: () {
                openAppSettings();
                Navigator.of(dialogContext).pop();
              },
              child: const Text('はい'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> showAddGameTypeDialog(
      BuildContext context, WidgetRef ref) async {
    final result = await showInputBaseDialog(
        context: context,
        title: '遊んだゲームの種類を記録できます',
        hintText: '例：大富豪',
        action: (String inputText, BuildContext dialogContext) async {
          await ref.read(sessionProvider.notifier).addGameType(inputText);
        });
    return result ?? false;
  }

  Future<void> showEditGameTypeDialog(
      BuildContext context, WidgetRef ref, Session session) async {
    await showInputBaseDialog(
        context: context,
        title: '遊んだゲームの種類を編集できます',
        hintText: '例：大富豪',
        action: (String inputText, BuildContext dialogContext) async {
          await ref
              .read(resultHistoryProvider.notifier)
              .updateSessionGameType(session, inputText);
        });
  }

  Future<void> showMessageDialog(BuildContext context, String content) async {
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(''),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('はい'),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> showConfimationBaseDialog({
    required BuildContext context,
    required String title,
    required String content,
    required Function(BuildContext dialogContext) action,
    VoidCallback? onRollBack,
  }) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(false);
                },
                child: const Text('いいえ')),
            TextButton(
              onPressed: () async {
                try {
                  await LoadingOverlay.of(context)
                      .during(() => action(dialogContext));
                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop(true);
                  }
                } catch (e) {
                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop(false);
                  }
                  if (onRollBack != null) onRollBack();
                  if (context.mounted) await showErrorDialog(context, e);
                }
              },
              child: const Text('はい'),
            )
          ],
        );
      },
    );
    return result ?? false;
  }

  Future<bool?> showInputBaseDialog({
    required BuildContext context,
    required String title,
    required String hintText,
    required Function(String, BuildContext) action,
    String inputText = '',
  }) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(title),
              content: TextField(
                onChanged: (value) {
                  setState(() {
                    inputText = value;
                  });
                },
                decoration: InputDecoration(hintText: hintText),
              ),
              actions: getInputBaseDialogButtons(
                  context, dialogContext, inputText, action),
            );
          },
        );
      },
    );
    return result ?? false;
  }

  List<Widget> getInputBaseDialogButtons(BuildContext context,
      BuildContext dialogContext, String inputText, Function action) {
    return [
      TextButton(
        onPressed: () {
          Navigator.of(dialogContext).pop(false);
        },
        child: const Text('キャンセル'),
      ),
      TextButton(
        onPressed: inputText.trim().isEmpty
            ? null
            : () async {
                try {
                  await LoadingOverlay.of(context)
                      .during(() => action(inputText, dialogContext));
                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop(true);
                  }
                } catch (e) {
                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop(false);
                  }
                  if (context.mounted) await showErrorDialog(context, e);
                }
              },
        child: const Text('登録'),
      )
    ];
  }
}
