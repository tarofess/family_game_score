import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:family_game_score/domain/entity/result.dart' as entity_result;
import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/domain/entity/session.dart';
import 'package:family_game_score/presentation/widget/async_error_widget.dart';
import 'package:family_game_score/presentation/widget/list_card/result_list_card.dart';
import 'package:family_game_score/presentation/widget/sakura_animation.dart';
import 'package:family_game_score/presentation/dialog/input_dialog.dart';
import 'package:family_game_score/presentation/dialog/message_dialog.dart';
import 'package:family_game_score/presentation/provider/reset_game_usecase_provider.dart';
import 'package:family_game_score/domain/result.dart';
import 'package:family_game_score/presentation/dialog/error_dialog.dart';
import 'package:family_game_score/presentation/provider/add_game_type_usecase_provider.dart';
import 'package:family_game_score/application/state/player_notifier.dart';
import 'package:family_game_score/application/state/result_notifier.dart';
import 'package:family_game_score/application/state/session_notifier.dart';

class RankingPage extends HookConsumerWidget {
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionState = ref.watch(sessionNotifierProvider);
    final playersState = ref.watch(playerNotifierProvider);
    final resultsState = ref.watch(resultNotifierProvider);
    final isWrittenGameType = useState(false);

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
                    isWrittenGameType,
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
    ValueNotifier<bool> isWrittenGameType,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isFinishedGame(session) ? '結果発表' : '現在の順位'),
        actions: [
          isFinishedGame(session)
              ? IconButton(
                  icon: Icon(Icons.home, size: 24.r),
                  onPressed: () async {
                    await showMessageDialog(
                      context,
                      'お疲れ様でした！\nホーム画面に戻ります。',
                    );

                    ref.read(resetGameUsecaseProvider).execute();
                    if (context.mounted) context.pushReplacement('/');
                  },
                )
              : const SizedBox(),
        ],
      ),
      body: Stack(
        children: [
          _buildRankingList(players, results, context, ref),
          _buildSakuraAnimation(session),
        ],
      ),
      floatingActionButton: Visibility(
        visible: isFinishedGame(session) && !isWrittenGameType.value,
        child: FloatingActionButton(
          onPressed: () async {
            final gameType = await showInputDialog(
              context: context,
              title: '遊んだゲームの種類を記録できます',
              hintText: '例：大富豪',
            );
            if (gameType == null) return;

            final result =
                await ref.read(addGameTypeUsecaseProvider).execute(gameType);
            switch (result) {
              case Success():
                if (context.mounted) {
                  await showMessageDialog(context, 'ゲームの種類を記録しました。');
                  isWrittenGameType.value = true;
                }
                break;
              case Failure(message: final message):
                if (context.mounted) showErrorDialog(context, message);
            }
          },
          child: Icon(Icons.mode_edit, size: 24.r),
        ),
      ),
    );
  }

  Widget _buildRankingList(
    List<Player> players,
    List<entity_result.Result> results,
    BuildContext context,
    WidgetRef ref,
  ) {
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
    return isFinishedGame(session)
        ? const Positioned.fill(
            child: IgnorePointer(
              child: SakuraAnimation(),
            ),
          )
        : const SizedBox();
  }

  bool isFinishedGame(Session? session) {
    return session != null && session.endTime != null ? true : false;
  }
}
