import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/domain/entity/session.dart';
import 'package:family_game_score/presentation/widget/gradient_circle_button.dart';
import 'package:family_game_score/presentation/widget/async_error_widget.dart';
import 'package:family_game_score/application/state/combined_provider.dart';
import 'package:family_game_score/presentation/dialog/error_dialog.dart';
import 'package:family_game_score/domain/result.dart';
import 'package:family_game_score/presentation/provider/start_game_usecase_provider.dart';
import 'package:family_game_score/presentation/dialog/message_dialog.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final combinedState = ref.watch(combinedProvider);

    return Scaffold(
      body: combinedState.when(
        data: (combinedData) {
          final session = combinedData.$1;
          final players = combinedData.$2;

          return Center(
            child: _buildCenterCircleButton(context, ref, session, players),
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
  ) {
    return GradientCircleButton(
      onPressed: areTwoOrMorePlayersActive(players)
          ? () async {
              final isConfirmed =
                  await ref.read(startGameUsecaseProvider).execute();
              switch (isConfirmed) {
                case Success():
                  if (context.mounted) context.go('/scoring_view');
                  break;
                case Failure(message: final message):
                  if (context.mounted) showErrorDialog(context, message);
                  break;
              }
            }
          : () => showMessageDialog(
                context,
                '有効なプレイヤーが2名以上登録されていません。\n'
                'プレイヤー設定画面でプレイヤーを登録してください。',
              ),
      text: session == null ? 'ゲームスタート！' : 'ゲーム再開！',
      size: 200.r,
      gradientColors: areTwoOrMorePlayersActive(players)
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

  bool areTwoOrMorePlayersActive(List<Player> players) {
    return players.where((player) => player.status == 1).length >= 2;
  }
}
