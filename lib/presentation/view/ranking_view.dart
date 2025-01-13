import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';

import 'package:family_game_score/main.dart';
import 'package:family_game_score/domain/entity/result.dart';
import 'package:family_game_score/infrastructure/service/dialog_service.dart';
import 'package:family_game_score/application/state/player_notifier.dart';
import 'package:family_game_score/application/state/result_notifier.dart';
import 'package:family_game_score/presentation/widget/common_async_widget.dart';
import 'package:family_game_score/others/viewmodel/ranking_viewmodel.dart';

class RankingView extends HookConsumerWidget {
  final DialogService dialogService = getIt<DialogService>();

  RankingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(rankingViewModelProvider);
    final isVisibleFloatingActionButton = useState(vm.isFinishedGame());

    useEffect(() {
      Future.microtask(() async {
        try {
          final InAppReview inAppReview = InAppReview.instance;
          if (await vm.shouldShowInAppReview(inAppReview)) {
            await inAppReview.requestReview();
          }
          // ignore: empty_catches
        } catch (e) {}
      });
      return null;
    }, []);

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
      title: Text(vm.getAppBarTitle(), style: TextStyle(fontSize: 20.sp)),
      toolbarHeight: 56.r,
      actions: [
        vm.getIconButton(
          () async {
            final isSuccess =
                await dialogService.showReturnToHomeDialog(context, ref);
            if (isSuccess) {
              if (context.mounted) {
                context.pushReplacement('/');
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
                  context, ref, resultNotifierProvider, error),
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
              context, ref, playerNotifierProvider, error),
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
              await dialogService.showMessageDialog(context, 'ゲームの種類を記録しました。');
            }
            isVisibleFloatingActionButton.value = false;
          }
        },
        child: Icon(Icons.mode_edit, size: 24.r),
      ),
    );
  }
}
