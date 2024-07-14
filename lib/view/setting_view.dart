import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/provider/player_provider.dart';
import 'package:family_game_score/provider/session_provider.dart';
import 'package:family_game_score/view/widget/common_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingView extends ConsumerWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.watch(playerProvider);
    final session = ref.watch(sessionProvider);

    return Scaffold(
        body: Center(
            child: session.when(
                data: (data) => data == null
                    ? players.when(data: (data) {
                        if (data.isEmpty) {
                          return Text(
                              AppLocalizations.of(context)!.playerNotRegistered,
                              textAlign: TextAlign.center);
                        } else {
                          return buildPlayerList(data, ref);
                        }
                      }, error: (error, stackTrace) {
                        return CommonErrorWidget.showDataFetchErrorMessage(
                          context,
                          ref,
                          playerProvider,
                          error,
                        );
                      }, loading: () {
                        return const Center(child: CircularProgressIndicator());
                      })
                    : Center(
                        child: Text(
                          AppLocalizations.of(context)!.unableToEditPlayer,
                          textAlign: TextAlign.center,
                        ),
                      ),
                error: (error, stackTrace) {
                  return CommonErrorWidget.showDataFetchErrorMessage(
                    context,
                    ref,
                    sessionProvider,
                    error,
                  );
                },
                loading: () {
                  return const Center(child: CircularProgressIndicator());
                })),
        floatingActionButton: FloatingActionButton(
          onPressed:
              players.hasValue && session.hasValue && session.value == null
                  ? () {
                      showAddPlayerDialog(context, ref);
                    }
                  : null,
          child: const Icon(Icons.add),
        ));
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

  Future showAddPlayerDialog(BuildContext context, WidgetRef ref) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        String inputText = '';
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.enterYourName),
          content: TextField(
            onChanged: (value) {
              inputText = value;
            },
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.playerName,
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
                  await ref.read(playerProvider.notifier).addPlayer(inputText);
                } catch (e) {
                  // ignore: use_build_context_synchronously
                  CommonErrorWidget.showErrorDialog(context, e);
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
                  CommonErrorWidget.showErrorDialog(context, e);
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
          title: Text(AppLocalizations.of(context)!.confirmation),
          content: Text(
              '${AppLocalizations.of(context)!.deleteConfirmationEn}${player.name}${AppLocalizations.of(context)!.deleteConfirmationJa}'),
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
                  CommonErrorWidget.showErrorDialog(context, e);
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
