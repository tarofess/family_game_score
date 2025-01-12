import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:family_game_score/main.dart';
import 'package:family_game_score/infrastructure/service/dialog_service.dart';
import 'package:family_game_score/presentation/widget/loading_overlay.dart';
import 'package:family_game_score/others/viewmodel/home_viewmodel.dart';
import 'package:family_game_score/application/state/player_provider.dart';
import 'package:family_game_score/application/state/session_provider.dart';
import 'package:family_game_score/presentation/widget/common_async_widget.dart';
import 'package:family_game_score/presentation/widget/gradient_circle_button.dart';

class HomeView extends HookConsumerWidget {
  final DialogService dialogService = getIt<DialogService>();

  HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSnackbarVisible = useState(false);
    final vm = ref.watch(homeViewModelProvider);

    return Scaffold(
      body: buildBody(context, ref, vm, isSnackbarVisible),
    );
  }

  Widget buildBody(
    BuildContext context,
    WidgetRef ref,
    HomeViewModel vm,
    ValueNotifier<bool> isSnackbarVisible,
  ) {
    return vm.session.when(
      data: (_) => buildPlayers(context, ref, vm, isSnackbarVisible),
      loading: () => CommonAsyncWidgets.showLoading(),
      error: (error, stackTrace) =>
          CommonAsyncWidgets.showDataFetchErrorMessage(
              context, ref, sessionProvider, error),
    );
  }

  Widget buildPlayers(
    BuildContext context,
    WidgetRef ref,
    HomeViewModel vm,
    ValueNotifier<bool> isSnackbarVisible,
  ) {
    return vm.players.when(
      data: (_) {
        return Center(
          child: buildCenterCircleButton(
            context,
            ref,
            vm,
            isSnackbarVisible,
          ),
        );
      },
      loading: () => CommonAsyncWidgets.showLoading(),
      error: (error, stackTrace) =>
          CommonAsyncWidgets.showDataFetchErrorMessage(
              context, ref, playerProvider, error),
    );
  }

  Widget buildCenterCircleButton(
    BuildContext context,
    WidgetRef ref,
    HomeViewModel vm,
    ValueNotifier<bool> isSnackbarVisible,
  ) {
    return GradientCircleButton(
      onPressed: vm.handleButtonPress(
        onStartGame: () async {
          try {
            await LoadingOverlay.of(context).during(
                () => ref.read(playerProvider.notifier).getActivePlayer());
            if (context.mounted) {
              context.go('/scoring_view');
            }
          } catch (e) {
            if (context.mounted) {
              dialogService.showErrorDialog(context, e.toString());
            }
          }
        },
        onShowSnackbar: () => showHomeViewSnackBar(context, isSnackbarVisible),
      ),
      text: vm.getButtonText(),
      size: 200.r,
      gradientColors: vm.getGradientColors(),
      textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  void showHomeViewSnackBar(
    BuildContext context,
    ValueNotifier<bool> isSnackbarVisible,
  ) {
    if (isSnackbarVisible.value) return;

    isSnackbarVisible.value = true;

    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: Text(
              '有効なプレイヤーが2名以上登録されていません。\n'
              'プレイヤー設定画面でプレイヤーを登録してください。',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ),
        )
        .closed
        .then((_) => isSnackbarVisible.value = false);
  }
}
