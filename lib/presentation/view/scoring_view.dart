import 'package:family_game_score/main.dart';
import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/infrastructure/service/camera_service.dart';
import 'package:family_game_score/infrastructure/service/dialog_service.dart';
import 'package:family_game_score/others/service/navigation_service.dart';
import 'package:family_game_score/presentation/view/ranking_view.dart';
import 'package:family_game_score/presentation/widget/list_card/scoring_list_card.dart';
import 'package:family_game_score/application/state/player_provider.dart';
import 'package:family_game_score/application/state/result_provider.dart';
import 'package:family_game_score/presentation/widget/common_async_widget.dart';
import 'package:family_game_score/others/viewmodel/scoring_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ScoringView extends ConsumerWidget {
  final DialogService dialogService = getIt<DialogService>();
  final NavigationService navigationService = getIt<NavigationService>();
  final CameraService cameraService = getIt<CameraService>();

  ScoringView({super.key});

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
      title: Text(vm.getAppBarTitle(), style: TextStyle(fontSize: 20.sp)),
      toolbarHeight: 56.r,
      leading: IconButton(
        icon: Icon(Icons.exit_to_app, size: 24.r),
        onPressed: vm.getExitButtonCallback(
          () async {
            final isSuccess =
                await dialogService.showFinishGameDialog(context, ref);
            if (isSuccess) {
              if (context.mounted) {
                navigationService.pushAndRemoveUntil(context, RankingView());
              }
            }
          },
        ),
      ),
      actions: [
        IconButton(
          onPressed: vm.getCheckButtonCallback(() async {
            await dialogService.showMoveToNextRoundDialog(context, ref);
          }),
          icon: Icon(Icons.check_circle_outline, size: 24.r),
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
              data: (_) => buildPlayers(context, ref, vm),
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
          RankingView(),
        ),
      ),
      backgroundColor: vm.getFloatingActionButtonColor(),
      child: Icon(Icons.description, size: 24.r),
    );
  }

  Widget buildPlayers(
      BuildContext context, WidgetRef ref, ScoringViewModel vm) {
    return vm.activePlayers.when(
      data: (data) => buildScoringList(data, ref),
      loading: () => CommonAsyncWidgets.showLoading(),
      error: (error, stackTrace) =>
          CommonAsyncWidgets.showDataFetchErrorMessage(
              context, ref, playerProvider, error),
    );
  }

  Widget buildHereAreTheCurrentRankingsText(BuildContext context) {
    return Text(
      '現在の順位はこちら↓',
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  Widget buildScoringList(List<Player> players, WidgetRef ref) {
    return ReorderableListView.builder(
      itemCount: players.length,
      itemBuilder: (context, index) => ScoringListCard(
        key: ValueKey(players[index].id),
        players: players,
        index: index,
      ),
      onReorder: (oldIndex, newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        ref.read(playerProvider.notifier).reorderPlayer(oldIndex, newIndex);
      },
    );
  }
}
