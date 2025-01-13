import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:family_game_score/main.dart';
import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/infrastructure/service/dialog_service.dart';
import 'package:family_game_score/presentation/widget/list_card/player_list_card.dart';
import 'package:family_game_score/application/state/player_notifier.dart';
import 'package:family_game_score/application/state/session_notifier.dart';
import 'package:family_game_score/presentation/widget/common_async_widget.dart';
import 'package:family_game_score/others/viewmodel/player_setting_viewmodel.dart';

class PlayerSettingView extends ConsumerWidget {
  final DialogService dialogService = getIt<DialogService>();

  PlayerSettingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(settingViewModelProvider);

    return Scaffold(
      body: buildBody(context, ref, vm),
      floatingActionButton: buildFloatingActionButton(context, ref, vm),
    );
  }

  Widget buildBody(
      BuildContext context, WidgetRef ref, PlayerSettingViewModel vm) {
    return Center(
      child: vm.session.when(
        data: (data) => vm.isSessionNull()
            ? buildPlayers(context, ref, vm)
            : buildUnableToEditPlayerText(context),
        loading: () => CommonAsyncWidgets.showLoading(),
        error: (error, stackTrace) =>
            CommonAsyncWidgets.showDataFetchErrorMessage(
                context, ref, sessionNotifierProvider, error),
      ),
    );
  }

  Widget buildFloatingActionButton(
      BuildContext context, WidgetRef ref, PlayerSettingViewModel vm) {
    return FloatingActionButton(
      onPressed: vm.getFloatingActionButtonCallback(
        ref,
        () => context.push(
          '/player_setting_detail_view',
          extra: {'player': null},
        ),
      ),
      backgroundColor: vm.getFloatingActionButtonColor(),
      child: Icon(Icons.add, size: 24.r),
    );
  }

  Widget buildPlayers(
      BuildContext context, WidgetRef ref, PlayerSettingViewModel vm) {
    return vm.players.when(
      data: (data) => data.isEmpty
          ? buildPlayerNotRegisteredMessage(context)
          : buildPlayerList(context, data, ref),
      loading: () => CommonAsyncWidgets.showLoading(),
      error: (error, stackTrace) =>
          CommonAsyncWidgets.showDataFetchErrorMessage(
              context, ref, playerNotifierProvider, error),
    );
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
