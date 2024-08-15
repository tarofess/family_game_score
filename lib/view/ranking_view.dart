import 'package:family_game_score/main.dart';
import 'package:family_game_score/model/entity/result.dart';
import 'package:family_game_score/service/dialog_service.dart';
import 'package:family_game_score/service/navigation_service.dart';
import 'package:family_game_score/viewmodel/provider/player_provider.dart';
import 'package:family_game_score/viewmodel/provider/result_provider.dart';
import 'package:family_game_score/view/widget/common_async_widget.dart';
import 'package:family_game_score/viewmodel/ranking_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RankingView extends HookConsumerWidget {
  final DialogService dialogService = getIt<DialogService>();
  final NavigationService navigationService = getIt<NavigationService>();

  RankingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(rankingViewModelProvider);
    final isVisibleFloatingActionButton = useState(vm.isEndTimeNull());

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
          () async {
            final isSuccess =
                await dialogService.showReturnToHomeDialog(context, ref);
            if (isSuccess) {
              if (context.mounted) {
                navigationService.pushReplacement(context, const MyApp());
              }
            }
          },
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
    return vm.activePlayers.when(
      data: (data) => ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) =>
            vm.getResultListCard(index, results, data),
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
          final isSuccess =
              await dialogService.showAddGameTypeDialog(context, ref);
          if (isSuccess) {
            if (context.mounted) {
              await dialogService.showMessageDialog(context, 'ゲームの種類を記録しました！');
            }
            isVisibleFloatingActionButton.value = false;
          }
        },
        child: const Icon(Icons.mode_edit),
      ),
    );
  }
}
