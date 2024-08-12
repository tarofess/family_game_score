import 'package:family_game_score/main.dart';
import 'package:family_game_score/model/entity/result.dart';
import 'package:family_game_score/service/dialog_service.dart';
import 'package:family_game_score/view/widget/list_card/result_list_card.dart';
import 'package:family_game_score/viewmodel/provider/player_provider.dart';
import 'package:family_game_score/viewmodel/provider/result_provider.dart';
import 'package:family_game_score/view/widget/common_async_widget.dart';
import 'package:family_game_score/viewmodel/ranking_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RankingView extends ConsumerWidget {
  final DialogService dialogService = getIt<DialogService>();

  RankingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(rankingViewModelProvider);

    return Scaffold(
      appBar: buildAppBar(context, ref, vm),
      body: buildBody(context, ref, vm),
      floatingActionButton: vm.session.value?.endTime == null
          ? null
          : buildFloatingActionButton(context, ref),
    );
  }

  AppBar buildAppBar(BuildContext context, WidgetRef ref, RankingViewModel vm) {
    return AppBar(
      centerTitle: true,
      title: vm.getAppBarTitle(),
      actions: [
        vm.getIconButton(
          () async => await dialogService.showReturnToHomeDialog(context, ref),
        )
      ],
    );
  }

  Widget buildBody(BuildContext context, WidgetRef ref, RankingViewModel vm) {
    return Stack(
      children: [
        vm.results.when(
          data: (data) {
            return buildRankingList(data, vm, context, ref);
          },
          loading: () => CommonAsyncWidgets.showLoading(),
          error: (error, stackTrace) =>
              CommonAsyncWidgets.showDataFetchErrorMessage(
                  context, ref, resultProvider, error),
        ),
        vm.getSakuraAnimation(),
      ],
    );
  }

  Widget buildRankingList(List<Result> results, RankingViewModel vm,
      BuildContext context, WidgetRef ref) {
    return vm.players.when(
      data: (data) => ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final result = results[index];
          final player = data.firstWhere((p) => p.id == result.playerId);
          return ResultListCard(player: player, result: result);
        },
      ),
      loading: () => CommonAsyncWidgets.showLoading(),
      error: (error, stackTrace) =>
          CommonAsyncWidgets.showDataFetchErrorMessage(
              context, ref, playerProvider, error),
    );
  }

  FloatingActionButton buildFloatingActionButton(
      BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () async {
        try {
          await dialogService.showAddGameTypeDialog(context, ref);
          // ボタンを無効化にする処理
        } catch (e) {
          if (context.mounted) {
            await dialogService.showErrorDialog(context, e.toString());
          }
        }
      },
      child: const Icon(Icons.add),
    );
  }
}
