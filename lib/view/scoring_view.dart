import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/viewmodel/provider/player_provider.dart';
import 'package:family_game_score/viewmodel/provider/result_provider.dart';
import 'package:family_game_score/view/widget/common_async_widget.dart';
import 'package:family_game_score/viewmodel/scoring_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ScoringView extends ConsumerWidget {
  const ScoringView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(scoringViewModelProvider);

    return Scaffold(
        appBar: buildAppBar(context, ref, vm),
        body: buildBody(context, ref, vm),
        floatingActionButton: buildFloatingActionButton(context, ref, vm));
  }

  AppBar buildAppBar(BuildContext context, WidgetRef ref, ScoringViewModel vm) {
    return AppBar(
      centerTitle: true,
      title: vm.getAppBarTitle(context),
      leading: IconButton(
          icon: const Icon(Icons.exit_to_app),
          onPressed: vm.getExitButtonCallback(context, ref)),
      actions: [
        IconButton(
            onPressed: vm.getCheckButtonCallback(context, ref),
            icon: const Icon(Icons.check_circle_outline)),
      ],
    );
  }

  Widget buildBody(BuildContext context, WidgetRef ref, ScoringViewModel vm) {
    return Center(
      child: Column(
        children: [
          buildHereAreTheCurrentRankingsText(context),
          Expanded(
              child: vm.results.when(
                  data: (data) => buildPlayers(context, ref, vm),
                  loading: () => CommonAsyncWidgets.showLoading(),
                  error: (error, stackTrace) =>
                      CommonAsyncWidgets.showDataFetchErrorMessage(
                          context, ref, resultProvider, error))),
        ],
      ),
    );
  }

  FloatingActionButton buildFloatingActionButton(
      BuildContext context, WidgetRef ref, ScoringViewModel vm) {
    return FloatingActionButton(
      onPressed: vm.getFloatingActionButtonCallback(context, ref),
      backgroundColor: vm.getFloatingActionButtonColor(),
      child: const Icon(Icons.description),
    );
  }

  Widget buildPlayers(
      BuildContext context, WidgetRef ref, ScoringViewModel vm) {
    return vm.players.when(
        data: (data) => buildScoringList(data, ref),
        loading: () => CommonAsyncWidgets.showLoading(),
        error: (error, stackTrace) =>
            CommonAsyncWidgets.showDataFetchErrorMessage(
                context, ref, playerProvider, error));
  }

  Widget buildHereAreTheCurrentRankingsText(BuildContext context) {
    return const Text('現在の順位はこちら↓',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal));
  }

  Widget buildScoringList(List<Player> data, WidgetRef ref) {
    return ReorderableListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) => buildListTile(context, data, index),
      onReorder: (oldIndex, newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        ref.read(playerProvider.notifier).reorderPlayer(oldIndex, newIndex);
      },
    );
  }

  Widget buildListTile(BuildContext context, List<Player> data, int index) {
    return ListTile(
      key: Key(data[index].id.toString()),
      title: Text(
        data[index].name,
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
      leading: Text(
        '${index + 1}位',
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
      trailing: ReorderableDragStartListener(
        index: index,
        child: const Icon(Icons.drag_handle),
      ),
    );
  }
}
