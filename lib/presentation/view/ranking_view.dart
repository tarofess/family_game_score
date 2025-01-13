import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:family_game_score/domain/entity/result.dart';
import 'package:family_game_score/application/state/combined_provider.dart';
import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/domain/entity/session.dart';
import 'package:family_game_score/presentation/widget/async_error_widget.dart';
import 'package:family_game_score/presentation/widget/list_card/result_list_card.dart';
import 'package:family_game_score/presentation/widget/sakura_animation.dart';
import 'package:family_game_score/application/state/player_notifier.dart';
import 'package:family_game_score/application/state/result_history_notifier.dart';
import 'package:family_game_score/application/state/result_notifier.dart';
import 'package:family_game_score/application/state/session_notifier.dart';
import 'package:family_game_score/presentation/dialog/input_dialog.dart';
import 'package:family_game_score/presentation/dialog/message_dialog.dart';

class RankingView extends ConsumerWidget {
  const RankingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final combinedState = ref.watch(combinedProvider);

    return combinedState.when(
      data: (combinedData) {
        final session = combinedData.$1;
        final players = combinedData.$2;
        final results = combinedData.$3;

        return _buildScaffold(context, ref, session, players, results);
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
      error: (error, stackTrace) {
        return AsyncErrorWidget(error: error, retry: () => combinedState);
      },
    );
  }

  Widget _buildScaffold(
    BuildContext context,
    WidgetRef ref,
    Session? session,
    List<Player> players,
    List<Result> results,
  ) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            session != null && session.endTime == null ? '現在の順位' : '結果発表',
            style: TextStyle(fontSize: 20.sp)),
        toolbarHeight: 56.r,
        actions: [
          session != null && session.endTime == null
              ? const SizedBox()
              : IconButton(
                  icon: Icon(Icons.home, size: 24.r),
                  onPressed: () async {
                    await showMessageDialog(
                      context,
                      'お疲れ様でした！\nホーム画面に戻ります。',
                    );
                    if (context.mounted) {
                      ref.invalidate(resultNotifierProvider);
                      ref.invalidate(resultHistoryNotifierProvider);
                      ref.invalidate(playerNotifierProvider);
                      ref
                          .read(sessionNotifierProvider.notifier)
                          .disposeSession();
                      context.pop();
                      context.pushReplacement('/');
                    }
                  },
                ),
        ],
      ),
      body: Stack(
        children: [
          _buildRankingList(players, results, context, ref),
          _buildSakuraAnimation(session),
        ],
      ),
      floatingActionButton: Visibility(
        visible: session != null && session.endTime != null,
        child: FloatingActionButton(
          onPressed: () async {
            final result = await showInputDialog(
              context: context,
              title: '遊んだゲームの種類を記録できます。',
              hintText: '例：大富豪',
            );

            await ref
                .read(sessionNotifierProvider.notifier)
                .addGameType(result ?? '');

            if (context.mounted) {
              await showMessageDialog(context, 'ゲームの種類を記録しました。');
            }
          },
          child: Icon(Icons.mode_edit, size: 24.r),
        ),
      ),
    );
  }

  Widget _buildRankingList(List<Player> players, List<Result> results,
      BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        final player = players.firstWhere((p) => p.id == result.playerId);
        return ResultListCard(
          key: ValueKey(player.id),
          player: player,
          result: result,
        );
      },
    );
  }

  Widget _buildSakuraAnimation(Session? session) {
    return session != null && session.endTime == null
        ? const SizedBox()
        : const Positioned.fill(
            child: IgnorePointer(
              child: SakuraAnimation(),
            ),
          );
  }
}
