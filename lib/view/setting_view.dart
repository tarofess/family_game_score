import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/service/dialog_service.dart';
import 'package:family_game_score/viewmodel/provider/player_provider.dart';
import 'package:family_game_score/viewmodel/provider/session_provider.dart';
import 'package:family_game_score/view/widget/common_async_widget.dart';
import 'package:family_game_score/viewmodel/setting_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingView extends ConsumerWidget {
  final DialogService dialogService;

  const SettingView({super.key, required this.dialogService});

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
            ref, () => dialogService.showAddPlayerDialog(context, ref)),
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
        return Dismissible(
          key: Key(players[index].name),
          direction: DismissDirection.horizontal,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16.0),
            child: const Icon(Icons.delete),
          ),
          secondaryBackground: Container(
            color: Colors.green,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 16.0),
            child: const Icon(Icons.edit),
          ),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              await dialogService.showEditPlayerDialog(
                  context, ref, players[index]);
            } else if (direction == DismissDirection.startToEnd) {
              await dialogService.showDeletePlayerDialog(
                  context, ref, players[index]);
            }
            return false;
          },
          child: Builder(
            builder: (context) {
              return ListTile(
                title: Text(players[index].name,
                    style: const TextStyle(fontSize: 18)),
                leading: const Icon(Icons.person, color: Colors.blue),
              );
            },
          ),
        );
      },
    );
  }
}
