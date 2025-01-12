import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/domain/entity/session.dart';
import 'package:family_game_score/infrastructure/repository/database_helper.dart';
import 'package:family_game_score/presentation/widget/loading_overlay.dart';
import 'package:family_game_score/application/state/player_provider.dart';
import 'package:family_game_score/application/state/result_history_provider.dart';
import 'package:family_game_score/application/state/result_provider.dart';
import 'package:family_game_score/application/state/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        content: 'ゲームを終了しますか？\nゲームが終了すると順位が確定します。',
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
          title: Center(
              child: Text('お疲れ様でした！',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ))),
          content: Text('ホーム画面に戻ります。', style: TextStyle(fontSize: 14.sp)),
          actions: [
            TextButton(
              onPressed: () {
                ref.invalidate(resultProvider);
                ref.invalidate(resultHistoryProvider);
                ref.invalidate(playerProvider);
                ref.read(sessionProvider.notifier).disposeSession();
                Navigator.of(dialogContext).pop(true);
              },
              child:
                  Center(child: Text('はい', style: TextStyle(fontSize: 14.sp))),
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
          title: Center(
              child: Text('エラー発生',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ))),
          content: Text(error.toString(), style: TextStyle(fontSize: 14.sp)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child:
                  Center(child: Text('はい', style: TextStyle(fontSize: 14.sp))),
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
          title: Center(
              child: Text('権限エラー',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ))),
          content: Text(content, style: TextStyle(fontSize: 14.sp)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child:
                  Center(child: Text('はい', style: TextStyle(fontSize: 14.sp))),
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
          title: Center(
              child: Text('権限エラー',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ))),
          content: Text(content, style: TextStyle(fontSize: 14.sp)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text('いいえ', style: TextStyle(fontSize: 14.sp)),
            ),
            TextButton(
              onPressed: () {
                openAppSettings();
                Navigator.of(dialogContext).pop();
              },
              child: Text('はい', style: TextStyle(fontSize: 14.sp)),
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
        title: '遊んだゲームの種類を記録できます。',
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
        title: '遊んだゲームの種類を編集できます。',
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
          content: Text(content, style: TextStyle(fontSize: 14.sp)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child:
                  Center(child: Text('はい', style: TextStyle(fontSize: 14.sp))),
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
          title: Center(
              child: Text(title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ))),
          content: Text(content, style: TextStyle(fontSize: 14.sp)),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(false);
                },
                child: Text('いいえ', style: TextStyle(fontSize: 14.sp))),
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
              child: Text('はい', style: TextStyle(fontSize: 14.sp)),
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
              title: Center(
                  child: Text(title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ))),
              content: TextField(
                  onChanged: (value) {
                    setState(() {
                      inputText = value;
                    });
                  },
                  decoration: InputDecoration(hintText: hintText),
                  style: TextStyle(fontSize: 14.sp)),
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
        child: Text('キャンセル', style: TextStyle(fontSize: 14.sp)),
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
        child: Text('登録', style: TextStyle(fontSize: 14.sp)),
      )
    ];
  }
}
