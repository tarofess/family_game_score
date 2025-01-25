import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/domain/entity/session.dart';
import 'package:family_game_score/presentation/widget/gradient_circle_button.dart';
import 'package:family_game_score/presentation/widget/async_error_widget.dart';
import 'package:family_game_score/presentation/dialog/error_dialog.dart';
import 'package:family_game_score/domain/result.dart';
import 'package:family_game_score/presentation/provider/start_game_usecase_provider.dart';
import 'package:family_game_score/presentation/dialog/message_dialog.dart';
import 'package:family_game_score/application/state/player_notifier.dart';
import 'package:family_game_score/application/state/session_notifier.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionState = ref.watch(sessionNotifierProvider);
    final playersState = ref.watch(playerNotifierProvider);

    return Scaffold(
      body: sessionState.when(
        data: (session) {
          return playersState.when(
            data: (players) {
              return Center(
                child: _buildCenterCircleButton(context, ref, session, players),
              );
            },
            loading: () {
              return const Center(child: CircularProgressIndicator());
            },
            error: (error, stackTrace) {
              return AsyncErrorWidget(error: error, retry: () => playersState);
            },
          );
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
        error: (error, stackTrace) {
          return AsyncErrorWidget(error: error, retry: () => sessionState);
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
              final result = await ref.read(startGameUsecaseProvider).execute();
              switch (result) {
                case Success():
                  if (context.mounted) context.go('/scoring_page');
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
      gradientColors: areTwoOrMorePlayersActive(players)
          ? getActiveButtonColor()
          : getInactiveButtonColor(),
    );
  }

  bool areTwoOrMorePlayersActive(List<Player> players) {
    return players.where((player) => player.status == 1).length >= 2;
  }
}
