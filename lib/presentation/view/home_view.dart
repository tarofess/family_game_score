import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/domain/entity/session.dart';
import 'package:family_game_score/presentation/widget/loading_overlay.dart';
import 'package:family_game_score/application/state/player_notifier.dart';
import 'package:family_game_score/presentation/widget/gradient_circle_button.dart';
import 'package:family_game_score/presentation/widget/async_error_widget.dart';
import 'package:family_game_score/application/state/combined_provider.dart';
import 'package:family_game_score/presentation/dialog/error_dialog.dart';

class HomeView extends HookConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final combinedState = ref.watch(combinedProvider);
    final isSnackbarVisible = useState(false);

    return Scaffold(
      body: combinedState.when(
        data: (combinedData) {
          final session = combinedData.$1;
          final players = combinedData.$2;

          return Center(
            child: _buildCenterCircleButton(
              context,
              ref,
              session,
              players,
              isSnackbarVisible,
            ),
          );
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
        error: (error, stackTrace) {
          return AsyncErrorWidget(error: error, retry: () => combinedState);
        },
      ),
    );
  }

  Widget _buildCenterCircleButton(
    BuildContext context,
    WidgetRef ref,
    Session? session,
    List<Player> players,
    ValueNotifier<bool> isSnackbarVisible,
  ) {
    return GradientCircleButton(
      onPressed: players.where((player) => player.status == 1).length >= 2
          ? () async {
              try {
                await LoadingOverlay.of(context).during(() => ref
                    .read(playerNotifierProvider.notifier)
                    .getActivePlayer());
                if (context.mounted) {
                  context.go('/scoring_view');
                }
              } catch (e) {
                if (context.mounted) {
                  showErrorDialog(context, e.toString());
                }
              }
            }
          : () => _showHomeViewSnackBar(context, isSnackbarVisible),
      text: session == null ? 'ゲームスタート！' : 'ゲーム再開！',
      size: 200.r,
      gradientColors: players.where((player) => player.status == 1).length >= 2
          ? const [
              Color.fromARGB(255, 255, 194, 102),
              Color.fromARGB(255, 255, 101, 90)
            ]
          : const [
              Color.fromARGB(255, 223, 223, 223),
              Color.fromARGB(255, 109, 109, 109)
            ],
      textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  void _showHomeViewSnackBar(
    BuildContext context,
    ValueNotifier<bool> isSnackbarVisible,
  ) {
    if (isSnackbarVisible.value) return;

    isSnackbarVisible.value = true;

    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: Text(
              '有効なプレイヤーが2名以上登録されていません。\n'
              'プレイヤー設定画面でプレイヤーを登録してください。',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ),
        )
        .closed
        .then((_) => isSnackbarVisible.value = false);
  }
}
