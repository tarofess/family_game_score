import 'package:family_game_score/main.dart';
import 'package:family_game_score/model/entity/result.dart';
import 'package:family_game_score/service/dialog_service.dart';
import 'package:family_game_score/view/widget/list_card/result_list_card.dart';
import 'package:family_game_score/viewmodel/provider/player_provider.dart';
import 'package:family_game_score/viewmodel/provider/result_provider.dart';
import 'package:family_game_score/view/widget/common_async_widget.dart';
import 'package:family_game_score/viewmodel/ranking_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RankingView extends HookConsumerWidget {
  final DialogService dialogService = getIt<DialogService>();

  RankingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(rankingViewModelProvider);
    final isVisibleFloatingActionButton =
        useState(vm.session.value?.endTime == null ? false : true);

    return Scaffold(
      appBar: buildAppBar(context, ref, vm),
      body: buildBody(context, ref, vm),
      floatingActionButton: buildFloatingActionButton(
          context, ref, isVisibleFloatingActionButton),
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

  Visibility buildFloatingActionButton(BuildContext context, WidgetRef ref,
      ValueNotifier<bool> isVisibleFloatingActionButton) {
    return Visibility(
      visible: isVisibleFloatingActionButton.value,
      child: FloatingActionButton(
        onPressed: () async {
          try {
            final isSuccess =
                await dialogService.showAddGameTypeDialog(context, ref);
            if (isSuccess) {
              if (context.mounted) {
                await dialogService.showMessageDialog(
                    context, '', 'ゲームの種類を記録しました！');
              }
              isVisibleFloatingActionButton.value = false;
            }
          } catch (e) {
            if (context.mounted) {
              await dialogService.showErrorDialog(context, e.toString());
            }
          }
        },
        child: const Icon(Icons.mode_edit),
      ),
    );
  }
}
