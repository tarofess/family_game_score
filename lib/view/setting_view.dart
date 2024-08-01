import 'package:family_game_score/main.dart';
import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/service/dialog_service.dart';
import 'package:family_game_score/service/navigation_service.dart';
import 'package:family_game_score/view/setting_detail_view.dart';
import 'package:family_game_score/view/widget/list_card/player_list_card.dart';
import 'package:family_game_score/viewmodel/provider/player_provider.dart';
import 'package:family_game_score/viewmodel/provider/session_provider.dart';
import 'package:family_game_score/view/widget/common_async_widget.dart';
import 'package:family_game_score/viewmodel/setting_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingView extends ConsumerWidget {
  final NavigationService navigationService = getIt<NavigationService>();
  final DialogService dialogService = getIt<DialogService>();

  SettingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(settingViewModelProvider);

    return Scaffold(
      body: Center(
        child: vm.session.when(
          data: (data) => data == null
              ? buildPlayers(context, ref, vm)
              : buildUnableToEditPlayerText(context),
          loading: () => CommonAsyncWidgets.showLoading(),
          error: (error, stackTrace) =>
              CommonAsyncWidgets.showDataFetchErrorMessage(
                  context, ref, sessionProvider, error),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: vm.getFloatingActionButtonCallback(
          ref,
          () => navigationService.push(
            context,
            SettingDetailView(player: null),
          ),
        ),
        backgroundColor: vm.getFloatingActionButtonColor(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildPlayers(
      BuildContext context, WidgetRef ref, SettingViewModel vm) {
    return vm.players.when(
      data: (data) => data.isEmpty
          ? buildPlayerNotRegisteredMessage(context)
          : buildPlayerList(context, data, ref),
      loading: () => CommonAsyncWidgets.showLoading(),
      error: (error, stackTrace) =>
          CommonAsyncWidgets.showDataFetchErrorMessage(
              context, ref, playerProvider, error),
    );
  }

  Widget buildUnableToEditPlayerText(BuildContext context) {
    return const Center(
      child: Text(
        '現在ゲームが進行中のため\nプレイヤーの編集ができません',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget buildPlayerNotRegisteredMessage(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        'プレイヤーが登録されていません\nゲームを始めるために2名以上追加してください',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget buildPlayerList(
      BuildContext context, List<Player> players, WidgetRef ref) {
    return ListView.builder(
      itemCount: players.length,
      itemBuilder: (BuildContext context, int index) {
        return PlayerListCard(player: players[index], ref: ref);
      },
    );
  }
}
