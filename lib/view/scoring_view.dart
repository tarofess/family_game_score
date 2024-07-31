import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/service/camera_service.dart';
import 'package:family_game_score/service/dialog_service.dart';
import 'package:family_game_score/service/navigation_service.dart';
import 'package:family_game_score/view/ranking_view.dart';
import 'package:family_game_score/view/widget/list_card/scoring_list_card.dart';
import 'package:family_game_score/viewmodel/provider/player_provider.dart';
import 'package:family_game_score/viewmodel/provider/result_provider.dart';
import 'package:family_game_score/view/widget/common_async_widget.dart';
import 'package:family_game_score/viewmodel/scoring_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ScoringView extends ConsumerWidget {
  final DialogService dialogService;
  final NavigationService navigationService;
  final CameraService cameraService;

  const ScoringView(
      {super.key,
      required this.dialogService,
      required this.navigationService,
      required this.cameraService});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(scoringViewModelProvider);

    return Scaffold(
      appBar: buildAppBar(context, ref, vm),
      body: buildBody(context, ref, vm),
      floatingActionButton: buildFloatingActionButton(context, ref, vm),
    );
  }

  AppBar buildAppBar(BuildContext context, WidgetRef ref, ScoringViewModel vm) {
    return AppBar(
      centerTitle: true,
      title: vm.getAppBarTitle(),
      leading: IconButton(
        icon: const Icon(Icons.exit_to_app),
        onPressed: vm.getExitButtonCallback(
          () => dialogService.showFinishGameDialog(context, ref),
        ),
      ),
      actions: [
        IconButton(
          onPressed: vm.getCheckButtonCallback(
            () => dialogService.showMoveToNextRoundDialog(context, ref),
          ),
          icon: const Icon(Icons.check_circle_outline),
        ),
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
                      context, ref, resultProvider, error),
            ),
          ),
        ],
      ),
    );
  }

  FloatingActionButton buildFloatingActionButton(
      BuildContext context, WidgetRef ref, ScoringViewModel vm) {
    return FloatingActionButton(
      onPressed: vm.getFloatingActionButtonCallback(
        () => navigationService.push(
          context,
          RankingView(
            dialogService: DialogService(
              NavigationService(),
            ),
          ),
        ),
      ),
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
              context, ref, playerProvider, error),
    );
  }

  Widget buildHereAreTheCurrentRankingsText(BuildContext context) {
    return const Text('現在の順位はこちら↓',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal));
  }

  Widget buildScoringList(List<Player> players, WidgetRef ref) {
    return ReorderableListView.builder(
      itemCount: players.length,
      itemBuilder: (context, index) => ScoringListCard(
          key: Key(players[index].id.toString()),
          players: players,
          index: index,
          navigationService: navigationService,
          cameraService: cameraService),
      onReorder: (oldIndex, newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        ref.read(playerProvider.notifier).reorderPlayer(oldIndex, newIndex);
      },
    );
  }
}
