import 'package:family_game_score/main.dart';
import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/session.dart';
import 'package:family_game_score/service/navigation_service.dart';
import 'package:family_game_score/view/ranking_view.dart';
import 'package:family_game_score/view/widget/loading_overlay.dart';
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
    try {
      await showConfimationBaseDialog(
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
    } catch (e) {
      rethrow;
    }
  }

  Future<void> showMoveToNextRoundDialog(
      BuildContext context, WidgetRef ref) async {
    try {
      final session = ref.read(sessionProvider);
      final nextRound =
          session.value != null ? (session.value!.round + 1).toString() : '2';

      await showConfimationBaseDialog(
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
    } catch (e) {
      rethrow;
    }
  }

  Future<void> showFinishGameDialog(BuildContext context, WidgetRef ref) async {
    try {
      await showConfimationBaseDialog(
          context: context,
          title: '確認',
          content: 'ゲームを終了しますか？\nゲームが終了すると順位が確定します',
          action: (BuildContext dialogContext) async {
            await handleActionAndError(dialogContext, '結果の保存中にエラーが発生しました',
                () async {
              await ref.read(sessionProvider.notifier).updateEndTime();
            });

            if (context.mounted) {
              navigationService.pushAndRemoveUntil(context, RankingView());
            }
          });
    } catch (e) {
      rethrow;
    }
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
                ref.read(playerProvider.notifier).resetOrder();
                ref.read(sessionProvider.notifier).disposeSession();
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

  Future<bool> showAddGameTypeDialog(
      BuildContext context, WidgetRef ref) async {
    try {
      return await showInputBaseDialog(
          context: context,
          title: '遊んだゲームの種類を記録できます',
          hintText: '例：大富豪',
          action: (String inputText, BuildContext dialogContext) async {
            await handleActionAndError(dialogContext, 'ゲーム種類の記録中にエラーが発生しました',
                () async {
              await ref.read(sessionProvider.notifier).addGameType(inputText);
            });
          });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> showEditGameTypeDialog(
      BuildContext context, WidgetRef ref, Session session) async {
    try {
      await showInputBaseDialog(
          context: context,
          title: '遊んだゲームの種類を編集できます',
          hintText: '例：大富豪',
          action: (String inputText, BuildContext dialogContext) async {
            await handleActionAndError(dialogContext, 'ゲーム種類の編集中にエラーが発生しました',
                () async {
              await ref
                  .read(resultHistoryProvider.notifier)
                  .updateSessionGameType(session, inputText);
            });
          });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> showMessageDialog(
      BuildContext context, String title, String content) async {
    try {
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
                child: const Text('はい'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> showConfimationBaseDialog({
    required BuildContext context,
    required String title,
    required String content,
    required Function(BuildContext dialogContext) action,
  }) async {
    final loadingOverlay = LoadingOverlay.of(context);
    try {
      final result = await showDialog(
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
                onPressed: () async {
                  loadingOverlay.show();
                  await action(dialogContext);
                  loadingOverlay.hide();
                },
                child: const Text('はい'),
              )
            ],
          );
        },
      );
      return result ?? false;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> showInputBaseDialog({
    required BuildContext context,
    required String title,
    required String hintText,
    required Function(String, BuildContext) action,
    String inputText = '',
  }) async {
    final loadingOverlay = LoadingOverlay.of(context);
    try {
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
                actions: [
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
                            loadingOverlay.show();
                            await action(inputText, dialogContext);
                            loadingOverlay.hide();
                          },
                    child: const Text('登録'),
                  ),
                ],
              );
            },
          );
        },
      );
      return result ?? false;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> handleActionAndError(BuildContext dialogContext,
      String? errorReason, Future<void> Function() action) async {
    try {
      await action();
      if (dialogContext.mounted) {
        Navigator.of(dialogContext).pop(true);
      }
    } catch (e) {
      throw Exception(errorReason);
    }
  }
}
