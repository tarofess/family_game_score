import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/domain/entity/result.dart' as entity_result;
import 'package:family_game_score/domain/entity/session.dart';
import 'package:family_game_score/presentation/widget/list_card/scoring_list_card.dart';
import 'package:family_game_score/application/state/player_notifier.dart';
import 'package:family_game_score/presentation/widget/async_error_widget.dart';
import 'package:family_game_score/presentation/dialog/confirmation_dialog.dart';
import 'package:family_game_score/domain/result.dart';
import 'package:family_game_score/presentation/dialog/error_dialog.dart';
import 'package:family_game_score/presentation/provider/finish_game_usecase_provider.dart';
import 'package:family_game_score/presentation/provider/move_to_next_round_usecase_provider.dart';
import 'package:family_game_score/application/state/session_notifier.dart';
import 'package:family_game_score/application/state/result_notifier.dart';

class ScoringPage extends ConsumerWidget {
  const ScoringPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionState = ref.watch(sessionNotifierProvider);
    final playersState = ref.watch(playerNotifierProvider);
    final resultsState = ref.watch(resultNotifierProvider);

    return Scaffold(
      body: sessionState.when(
        data: (session) {
          return playersState.when(
            data: (players) {
              return resultsState.when(
                data: (results) {
                  return _buildScaffold(
                    context,
                    ref,
                    session,
                    players,
                    results,
                  );
                },
                loading: () {
                  return const Center(child: CircularProgressIndicator());
                },
                error: (error, stackTrace) {
                  return AsyncErrorWidget(
                    error: error,
                    retry: () => resultsState,
                  );
                },
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

  Widget _buildScaffold(
    BuildContext context,
    WidgetRef ref,
    Session? session,
    List<Player> players,
    List<entity_result.Result> results,
  ) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '${session == null ? '1' : session.round.toString()}回戦',
          style: TextStyle(fontSize: 20.sp),
        ),
        toolbarHeight: 56.r,
        leading: _buildFinighGameIconButton(context, ref, session),
        actions: [
          _buildMoveToNextRoundIconButton(context, ref),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              '現在の順位はこちら↓',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.normal,
              ),
            ),
            Expanded(
              child: _buildScoringList(players, ref),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: session == null ? null : () => context.push('/ranking_page'),
        backgroundColor: session == null ? Colors.grey[300] : null,
        child: Icon(Icons.description, size: 24.r),
      ),
    );
  }

  Widget _buildFinighGameIconButton(
    BuildContext context,
    WidgetRef ref,
    Session? session,
  ) {
    return IconButton(
      icon: Icon(Icons.exit_to_app, size: 24.r),
      onPressed: session != null
          ? () async {
              final isConfirmed = await showConfimationDialog(
                context: context,
                title: '確認',
                content: 'ゲームを終了しますか？\nゲームが終了すると順位が確定します。',
              );
              if (!isConfirmed) return;

              final result =
                  await ref.read(finishGameUsecaseProvider).execute();
              switch (result) {
                case Success():
                  if (context.mounted) {
                    context.pushReplacement('/ranking_page');
                  }
                  break;
                case Failure(message: final message):
                  if (context.mounted) showErrorDialog(context, message);
              }
            }
          : null,
    );
  }

  Widget _buildMoveToNextRoundIconButton(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () async {
        final session = ref.read(sessionNotifierProvider).value;
        final nextRound =
            session != null ? (session.round + 1).toString() : '2';
        final isConfirmed = await showConfimationDialog(
          context: context,
          title: '確認',
          content: '$nextRound回戦に進みますか？',
        );

        if (!isConfirmed) return;

        final result = await ref.read(moveToNextRoundUsecaseProvider).execute();
        switch (result) {
          case Success():
            break;
          case Failure(message: final message):
            if (context.mounted) showErrorDialog(context, message);
            break;
        }
      },
      icon: Icon(Icons.check_circle_outline, size: 24.r),
    );
  }

  Widget _buildScoringList(List<Player> players, WidgetRef ref) {
    return ReorderableListView.builder(
      itemCount: players.length,
      itemBuilder: (context, index) => ScoringListCard(
        key: ValueKey(players[index].id),
        players: players,
        index: index,
      ),
      onReorder: (oldIndex, newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        ref.read(playerNotifierProvider.notifier).reorderPlayer(
              oldIndex,
              newIndex,
            );
      },
    );
  }
}
