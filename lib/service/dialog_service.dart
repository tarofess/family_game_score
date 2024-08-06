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
  final NavigationService navigationService = getIt<NavigationService>();

  Future<void> showDeletePlayerDialog(
      BuildContext context, WidgetRef ref, Player player) async {
    await showConfimationDialog(
        context: context,
        title: '${player.name}を削除しますか？',
        content: '削除すると元に戻せませんが、本当に削除しますか？',
        action: (BuildContext dialogContext) async {
          await handleActionAndError(dialogContext, 'プレイヤーの削除中にエラーが発生しました',
              () async {
            await ref.read(playerProvider.notifier).deletePlayer(player);
            ref.invalidate(resultHistoryProvider);
          });
        });
  }

  Future<void> showMoveToNextRoundDialog(
      BuildContext context, WidgetRef ref) async {
    final session = ref.read(sessionProvider);
    final nextRound =
        session.value != null ? (session.value!.round + 1).toString() : '2';

    await showConfimationDialog(
        context: context,
        title: '確認',
        content: '$nextRound回戦に進みますか？',
        action: (BuildContext dialogContext) async {
          await handleActionAndError(dialogContext, '結果の保存中にエラーが発生しました',
              () async {
            await ref.read(sessionProvider.notifier).addSession();
            await ref.read(sessionProvider.notifier).updateRound();
            await ref.read(resultProvider.notifier).addOrUpdateResult();
          });
        });
  }

  Future<void> showFinishGameDialog(BuildContext context, WidgetRef ref) async {
    await showConfimationDialog(
        context: context,
        title: '確認',
        content: 'ゲームを終了しますか？\nゲームが終了すると順位が確定します',
        action: (BuildContext dialogContext) async {
          await handleActionAndError(dialogContext, '結果の保存中にエラーが発生しました',
              () async {
            await ref.read(sessionProvider.notifier).updateEndTime();
            ref.read(sessionProvider.notifier).disposeSession();
            ref.read(playerProvider.notifier).resetOrder();
          });

          if (context.mounted) {
            navigationService.pushAndRemoveUntil(context, RankingView());
          }
        });
  }

  Future<void> showReturnToHomeDialog(
      BuildContext context, WidgetRef ref) async {
    await showDialog(
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
                navigationService.pop(dialogContext);
                navigationService.pushReplacement(context, const MyApp());
              },
              child: const Text('はい'),
            ),
          ],
        );
      },
    );
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
                navigationService.pop(dialogContext);
              },
              child: const Text('はい'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showConfimationDialog(
      {required BuildContext context,
      required String title,
      required String content,
      required Function(BuildContext dialogContext) action,
      String confirmText = '確認',
      String cancelText = 'キャンセル'}) async {
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
                onPressed: () {
                  navigationService.pop(dialogContext);
                },
                child: const Text('いいえ')),
            TextButton(
              onPressed: () async => await action(dialogContext),
              child: const Text('はい'),
            )
          ],
        );
      },
    );
  }

  Future<void> handleActionAndError(BuildContext dialogContext,
      String? errorReason, Future<void> Function() action) async {
    try {
      await action();
    } catch (e) {
      throw Exception(errorReason);
    } finally {
      if (dialogContext.mounted) {
        navigationService.pop(dialogContext);
      }
    }
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
                navigationService.pop(dialogContext);
              },
              child: const Text('はい'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showPermissionPermanentlyDeniedDialog(BuildContext context,
      String content, VoidCallback onOpenAppSettings) async {
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('権限エラー'),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                navigationService.pop(dialogContext);
              },
              child: const Text('いいえ'),
            ),
            TextButton(
              onPressed: () {
                onOpenAppSettings();
                navigationService.pop(dialogContext);
              },
              child: const Text('はい'),
            ),
          ],
        );
      },
    );
  }
}
