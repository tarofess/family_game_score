import 'package:family_game_score/model/player.dart';
import 'package:family_game_score/provider/player_provider.dart';
import 'package:family_game_score/provider/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingView extends ConsumerWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.watch(playerProvider);
    final session = ref.watch(sessionProvider);

    return Scaffold(
        body: Center(
            child: session.when(
                data: (data) => data != null
                    ? const Center(
                        child: Text(
                          '現在ゲームが進行中のため\nプレイヤーの編集ができません',
                          textAlign: TextAlign.center,
                        ),
                      )
                    : players.when(data: (data) {
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
                                confirmDismiss: (direction) async {
                                  if (direction ==
                                      DismissDirection.endToStart) {
                                    return showEditPlayerDialog(
                                            context, ref, data[index]) ==
                                        true;
                                  } else if (direction ==
                                      DismissDirection.startToEnd) {
                                    return showDeleteDialog(
                                            context, ref, data[index]) ==
                                        true;
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
                      }, error: (error, stackTrace) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  'エラーが発生しました\n${error.toString()}',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // ignore: unused_result
                                  ref.refresh(playerProvider);
                                },
                                child: const Text('リトライ'),
                              ),
                            ],
                          ),
                        );
                      }, loading: () {
                        return const Center(child: CircularProgressIndicator());
                      }),
                error: (error, stackTrace) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            'エラーが発生しました\n${error.toString()}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // ignore: unused_result
                            ref.refresh(playerProvider);
                          },
                          child: const Text('リトライ'),
                        ),
                      ],
                    ),
                  );
                },
                loading: () {
                  return const Center(child: CircularProgressIndicator());
                })),
        floatingActionButton: FloatingActionButton(
          onPressed: players.hasError || session.value != null
              ? null
              : () {
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
              onPressed: () async {
                try {
                  await ref
                      .read(playerProvider.notifier)
                      .createPlayer(inputText);
                } catch (e) {
                  showErrorDialog(context, e);
                }
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
              onPressed: () async {
                try {
                  await ref
                      .read(playerProvider.notifier)
                      .updatePlayer(player.copyWith(name: inputText));
                } catch (e) {
                  showErrorDialog(context, e);
                }
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
          title: const Text('確認'),
          content: Text('${player.name}を削除しますか？'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('いいえ'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await ref.read(playerProvider.notifier).deletePlayer(player);
                } catch (e) {
                  showErrorDialog(context, e);
                }
                Navigator.pop(context);
              },
              child: const Text('はい'),
            ),
          ],
        );
      },
    );
  }

  void showErrorDialog(BuildContext context, dynamic error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('エラー'),
          content: Text('エラーが発生しました\n${error.toString()}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('閉じる'),
            ),
          ],
        );
      },
    );
  }
}
