import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:family_game_score/main.dart';
import 'package:family_game_score/domain/entity/result.dart';
import 'package:family_game_score/infrastructure/service/dialog_service.dart';
import 'package:family_game_score/application/state/combined_provider.dart';
import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/domain/entity/session.dart';
import 'package:family_game_score/presentation/widget/async_error_widget.dart';
import 'package:family_game_score/presentation/widget/list_card/result_list_card.dart';
import 'package:family_game_score/presentation/widget/sakura_animation.dart';

class RankingView extends ConsumerWidget {
  final DialogService dialogService = getIt<DialogService>();

  RankingView({super.key});

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
                    final isSuccess = await dialogService
                        .showReturnToHomeDialog(context, ref);
                    if (isSuccess) {
                      if (context.mounted) {
                        context.pushReplacement('/');
                      }
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
            final isSuccess =
                await dialogService.showAddGameTypeDialog(context, ref);
            if (isSuccess) {
              if (context.mounted) {
                await dialogService.showMessageDialog(
                    context, 'ゲームの種類を記録しました。');
              }
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
