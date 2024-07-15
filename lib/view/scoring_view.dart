import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/provider/player_provider.dart';
import 'package:family_game_score/provider/result_provider.dart';
import 'package:family_game_score/provider/session_provider.dart';
import 'package:family_game_score/view/ranking_view.dart';
import 'package:family_game_score/view/widget/common_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
          centerTitle: true,
          title: Text(
              '${session.value == null ? '1' : session.value!.round.toString()}${AppLocalizations.of(context)!.round}'),
          leading: IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: results.hasValue && session.value != null
                ? () {
                    showFinishGameDialog(context, ref);
                  }
                : null,
          ),
          actions: [
            IconButton(
                onPressed: results.hasValue
                    ? () {
                        showMoveToNextRoundDialog(context, ref);
                      }
                    : null,
                icon: const Icon(Icons.check_circle_outline)),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              buildHereAreTheCurrentRankingsText(context),
              Expanded(
                  child: results.when(
                      data: (resultsData) => players.when(
                          data: (playersData) =>
                              buildScoringList(playersData, ref),
                          error: (error, stackTrace) {
                            return CommonErrorWidget.showDataFetchErrorMessage(
                                context, ref, playerProvider, error);
                          },
                          loading: () => const CircularProgressIndicator()),
                      error: (error, stackTrace) {
                        return CommonErrorWidget.showDataFetchErrorMessage(
                            context, ref, resultProvider, error);
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
          backgroundColor: session.value != null ? null : Colors.grey[300],
          child: const Icon(Icons.description),
        ));
  }

  Widget buildHereAreTheCurrentRankingsText(BuildContext context) {
    return Text(AppLocalizations.of(context)!.hereAreTheCurrentRankings,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal));
  }

  Widget buildScoringList(List<Player> data, WidgetRef ref) {
    return ReorderableListView.builder(
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
        ref.read(playerProvider.notifier).reorderPlayer(oldIndex, newIndex);
      },
    );
  }

  void showMoveToNextRoundDialog(BuildContext context, WidgetRef ref) {
    final players = ref.read(playerProvider);
    final session = ref.read(sessionProvider);

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
                  final newSession = ref.read(sessionProvider);
                  await ref
                      .read(resultProvider.notifier)
                      .addOrUpdateResult(players.value!, newSession.value!);

                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                } catch (e) {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                  // ignore: use_build_context_synchronously
                  CommonErrorWidget.showErrorDialog(context, e);
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
                  CommonErrorWidget.showErrorDialog(context, e);
                }
              },
              child: Text(AppLocalizations.of(context)!.yes),
            ),
          ],
        );
      },
    );
  }
}
