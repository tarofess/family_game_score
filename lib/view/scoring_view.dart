import 'package:family_game_score/provider/player_provider.dart';
import 'package:family_game_score/provider/result_provider.dart';
import 'package:family_game_score/provider/session_provider.dart';
import 'package:family_game_score/view/ranking_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScoringView extends ConsumerWidget {
  const ScoringView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.watch(playerProvider);
    final session = ref.watch(sessionProvider);
    final results = ref.watch(resultProvider);

    return Scaffold(
        appBar: AppBar(
          title: Text(
              '${session.value != null ? session.value!.round.toString() : '1'}${AppLocalizations.of(context)!.round}'),
          leading: IconButton(
            icon: const Icon(Icons.check_circle_outline),
            onPressed: session.value != null
                ? () {
                    showFinishGameDialog(context, ref);
                  }
                : null,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showMoveToNextRoundDialog(context, ref);
                },
                icon: const Icon(Icons.arrow_forward)),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              Text(AppLocalizations.of(context)!.hereAreTheCurrentRankings),
              Expanded(
                  child: results.when(
                      data: (data) => players.when(
                          data: (data) => data.isNotEmpty
                              ? ReorderableListView.builder(
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      key: Key(data[index].id.toString()),
                                      title: Text(
                                        data[index].name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      leading: Text(
                                        '${index + 1}${AppLocalizations.of(context)!.rank}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      trailing: ReorderableDragStartListener(
                                        index: index,
                                        child: const Icon(Icons.drag_handle),
                                      ),
                                    );
                                  },
                                  onReorder: (oldIndex, newIndex) {
                                    if (oldIndex < newIndex) {
                                      newIndex -= 1;
                                    }
                                    ref
                                        .read(playerProvider.notifier)
                                        .reorderPlayer(oldIndex, newIndex);
                                  },
                                )
                              : Text(AppLocalizations.of(context)!.noData),
                          error: (error, stackTrace) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text(
                                      '${AppLocalizations.of(context)!.errorMessage}\n${error.toString()}',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // ignore: unused_result
                                      ref.refresh(playerProvider);
                                    },
                                    child: Text(
                                        AppLocalizations.of(context)!.retry),
                                  ),
                                ],
                              ),
                            );
                          },
                          loading: () => const CircularProgressIndicator()),
                      error: (error, stackTrace) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  '${AppLocalizations.of(context)!.errorMessage}\n${error.toString()}',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // ignore: unused_result
                                  ref.refresh(resultProvider);
                                },
                                child:
                                    Text(AppLocalizations.of(context)!.retry),
                              ),
                            ],
                          ),
                        );
                      },
                      loading: () => const CircularProgressIndicator())),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: session.value != null
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RankingView()),
                  );
                }
              : null,
          child: const Icon(Icons.description),
        ));
  }

  void showMoveToNextRoundDialog(BuildContext context, WidgetRef ref) {
    final session = ref.read(sessionProvider);
    final results = ref.read(resultProvider);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.confirmation),
          content: Text(
              '${AppLocalizations.of(context)!.moveToNextRoundDialogMessageEn}${session.value != null ? (session.value!.round + 1).toString() : '2'}${AppLocalizations.of(context)!.moveToNextRoundDialogMessageRoundEn}${AppLocalizations.of(context)!.moveToNextRoundDialogMessageJa}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.no),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await ref.read(sessionProvider.notifier).addSession();
                  await ref.read(sessionProvider.notifier).updateRound();

                  if (results.value?.isEmpty ?? true) {
                    await ref.read(resultProvider.notifier).addResult();
                  } else {
                    await ref.read(resultProvider.notifier).updateResult();
                  }

                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                } catch (e) {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                  // ignore: use_build_context_synchronously
                  showErrorDialog(context, e);
                }
              },
              child: Text(AppLocalizations.of(context)!.yes),
            ),
          ],
        );
      },
    );
  }

  void showFinishGameDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.confirmation),
          content: Text(
              AppLocalizations.of(context)!.finishDialogMessageInScoringView),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.no),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await ref.read(sessionProvider.notifier).updateEndTime();
                  ref.read(sessionProvider.notifier).disposeSession();
                  ref.read(playerProvider.notifier).resetOrder();

                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const RankingView(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  }
                } catch (e) {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                  // ignore: use_build_context_synchronously
                  showErrorDialog(context, e);
                }
              },
              child: Text(AppLocalizations.of(context)!.yes),
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
          title: Text(AppLocalizations.of(context)!.errorTitle),
          content: Text(
              '${AppLocalizations.of(context)!.errorMessage}\n${error.toString()}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.close),
            ),
          ],
        );
      },
    );
  }
}
