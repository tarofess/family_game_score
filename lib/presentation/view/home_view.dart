import 'package:family_game_score/main.dart';
import 'package:family_game_score/infrastructure/service/dialog_service.dart';
import 'package:family_game_score/others/service/navigation_service.dart';
import 'package:family_game_score/others/service/snackbar_service.dart';
import 'package:family_game_score/presentation/view/scoring_view.dart';
import 'package:family_game_score/presentation/widget/loading_overlay.dart';
import 'package:family_game_score/others/viewmodel/home_viewmodel.dart';
import 'package:family_game_score/application/state/player_provider.dart';
import 'package:family_game_score/application/state/session_provider.dart';
import 'package:family_game_score/presentation/widget/common_async_widget.dart';
import 'package:family_game_score/presentation/widget/gradient_circle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeView extends ConsumerWidget {
  final NavigationService navigationService = getIt<NavigationService>();
  final DialogService dialogService = getIt<DialogService>();
  final SnackbarService snackbarService = getIt<SnackbarService>();

  HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(homeViewModelProvider);

    return Scaffold(
      body: buildBody(context, ref, vm),
    );
  }

  Widget buildBody(BuildContext context, WidgetRef ref, HomeViewModel vm) {
    return vm.session.when(
      data: (_) => buildPlayers(context, ref, vm),
      loading: () => CommonAsyncWidgets.showLoading(),
      error: (error, stackTrace) =>
          CommonAsyncWidgets.showDataFetchErrorMessage(
              context, ref, sessionProvider, error),
    );
  }

  Widget buildPlayers(BuildContext context, WidgetRef ref, HomeViewModel vm) {
    return vm.players.when(
      data: (_) {
        return Center(child: buildCenterCircleButton(context, ref, vm));
      },
      loading: () => CommonAsyncWidgets.showLoading(),
      error: (error, stackTrace) =>
          CommonAsyncWidgets.showDataFetchErrorMessage(
              context, ref, playerProvider, error),
    );
  }

  Widget buildCenterCircleButton(
      BuildContext context, WidgetRef ref, HomeViewModel vm) {
    return GradientCircleButton(
      onPressed: vm.handleButtonPress(
        onStartGame: () async {
          try {
            await LoadingOverlay.of(context).during(
                () => ref.read(playerProvider.notifier).getActivePlayer());
            if (context.mounted) {
              navigationService.pushReplacementWithAnimationFromBottom(
                  context, ScoringView());
            }
          } catch (e) {
            if (context.mounted) {
              dialogService.showErrorDialog(context, e.toString());
            }
          }
        },
        onShowSnackbar: () => snackbarService.showHomeViewSnackBar(context),
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
}
