import 'package:family_game_score/model/player.dart';
import 'package:family_game_score/provider/player_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingView extends ConsumerWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerProvider = ref.watch(playerNotifierProvider);

    return Scaffold(
        body: Center(
          child: playerProvider.when(data: (data) {
            if (data.isEmpty) {
              return const Text('プレイヤーが登録されていません');
            } else {
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
                    onDismissed: (direction) {
                      if (direction == DismissDirection.endToStart) {
                        showEditPlayerDialog(context, ref, data[index]);
                      } else if (direction == DismissDirection.startToEnd) {
                        ref
                            .read(playerNotifierProvider.notifier)
                            .deletePlayer(data[index]);
                      }
                    },
                    child: ListTile(
                      title: Text(data[index].name),
                    ),
                  );
                },
              );
            }
          }, error: (error, _) {
            return const Text('エラーが発生しました');
          }, loading: () {
            return const Center(child: CircularProgressIndicator());
          }),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showAddPlayerDialog(context, ref);
          },
          child: const Icon(Icons.add),
        ));
  }

  Future showAddPlayerDialog(BuildContext context, WidgetRef ref) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        String inputText = '';
        return AlertDialog(
          title: const Text('名前を入力してください'),
          content: TextField(
            onChanged: (value) {
              inputText = value;
            },
            decoration: const InputDecoration(
              hintText: 'プレイヤー名',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                ref
                    .read(playerNotifierProvider.notifier)
                    .createPlayer(inputText);
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
          title: const Text('プレイヤー名を編集してください'),
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
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                ref
                    .read(playerNotifierProvider.notifier)
                    .updatePlayer(player.copyWith(name: inputText));
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
