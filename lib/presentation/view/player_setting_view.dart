import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:family_game_score/main.dart';
import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/infrastructure/service/dialog_service.dart';
import 'package:family_game_score/presentation/widget/list_card/player_list_card.dart';
import 'package:family_game_score/application/state/combined_provider.dart';
import 'package:family_game_score/presentation/widget/async_error_widget.dart';

class PlayerSettingView extends ConsumerWidget {
  final DialogService dialogService = getIt<DialogService>();

  PlayerSettingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final combinedState = ref.watch(combinedProvider);

    return combinedState.when(
      data: (combinedData) {
        final session = combinedData.$1;
        final players = combinedData.$2;

        return _buildScaffold(context, ref, session, players);
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
    session,
    players,
  ) {
    return Scaffold(
      body: Center(
        child: session == null
            ? buildPlayers(context, ref, players)
            : buildUnableToEditPlayerText(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: session == null
            ? () => context.push(
                  '/player_setting_detail_view',
                  extra: {'player': null},
                )
            : null,
        backgroundColor: session == null ? null : Colors.grey[300],
        child: Icon(Icons.add, size: 24.r),
      ),
    );
  }

  Widget buildPlayers(
    BuildContext context,
    WidgetRef ref,
    List<Player> players,
  ) {
    return players.isEmpty
        ? buildPlayerNotRegisteredMessage(context)
        : buildPlayerList(context, players, ref);
  }

  Widget buildUnableToEditPlayerText(BuildContext context) {
    return Center(
      child: Text(
        '現在ゲームが進行中のため\nプレイヤーの編集ができません。',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16.sp),
      ),
    );
  }

  Widget buildPlayerNotRegisteredMessage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'プレイヤーが登録されていません。\n'
        'ゲームを始めるために2名以上追加してください。',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16.sp),
      ),
    );
  }

  Widget buildPlayerList(
      BuildContext context, List<Player> players, WidgetRef ref) {
    return ListView.builder(
      itemCount: players.length,
      itemBuilder: (BuildContext context, int index) {
        return PlayerListCard(
          player: players[index],
          ref: ref,
          key: ValueKey(players[index].id),
        );
      },
    );
  }
}
