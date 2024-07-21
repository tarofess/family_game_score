import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/view/widget/common_dialog.dart';
import 'package:family_game_score/viewmodel/provider/player_provider.dart';
import 'package:family_game_score/viewmodel/provider/session_provider.dart';
import 'package:family_game_score/view/widget/common_async_widget.dart';
import 'package:family_game_score/viewmodel/setting_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingView extends ConsumerWidget {
  const SettingView({super.key});

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
                        context, ref, sessionProvider, error))),
        floatingActionButton: FloatingActionButton(
          onPressed: vm.getFloatingActionButtonCallback(context, ref),
          backgroundColor: vm.getFloatingActionButtonColor(),
          child: const Icon(Icons.add),
        ));
  }

  Widget buildPlayers(
      BuildContext context, WidgetRef ref, SettingViewModel vm) {
    return vm.players.when(
        data: (data) {
          if (data.isEmpty) {
            return buildPlayerNotRegisteredMessage(context);
          } else {
            return buildPlayerList(data, ref);
          }
        },
        loading: () => CommonAsyncWidgets.showLoading(),
        error: (error, stackTrace) =>
            CommonAsyncWidgets.showDataFetchErrorMessage(
                context, ref, playerProvider, error));
  }

  Widget buildUnableToEditPlayerText(BuildContext context) {
    return Center(
      child: Text(AppLocalizations.of(context)!.unableToEditPlayer,
          textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
    );
  }

  Widget buildPlayerNotRegisteredMessage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        AppLocalizations.of(context)!.playerNotRegistered,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget buildPlayerList(List<Player> data, WidgetRef ref) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          key: Key(data[index].name),
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
              return await showEditPlayerDialog(context, ref, data[index]);
            } else if (direction == DismissDirection.startToEnd) {
              return await showDeleteDialog(context, ref, data[index]);
            }
            return false;
          },
          child: Builder(
            builder: (context) {
              return ListTile(
                title: Text(
                  data[index].name,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                leading: const Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future showEditPlayerDialog(
      BuildContext context, WidgetRef ref, Player player) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        String inputText = player.name;
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.editPlayerName),
          content: TextField(
            onChanged: (value) {
              inputText = value;
            },
            decoration: InputDecoration(
              hintText: player.name,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await ref
                      .read(playerProvider.notifier)
                      .updatePlayer(player.copyWith(name: inputText));
                } catch (e) {
                  // ignore: use_build_context_synchronously
                  CommonDialog.showErrorDialog(context, e);
                }
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future showDeleteDialog(BuildContext context, WidgetRef ref, Player player) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              '${AppLocalizations.of(context)!.deleteConfirmationTitleEn}${player.name}${AppLocalizations.of(context)!.deleteConfirmationTitleJa}'),
          content:
              Text(AppLocalizations.of(context)!.deleteConfirmationMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.no),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await ref.read(playerProvider.notifier).deletePlayer(player);
                } catch (e) {
                  // ignore: use_build_context_synchronously
                  CommonDialog.showErrorDialog(context, e);
                }
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.yes),
            ),
          ],
        );
      },
    );
  }
}
