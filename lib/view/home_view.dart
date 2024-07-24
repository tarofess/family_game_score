import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/session.dart';
import 'package:family_game_score/viewmodel/home_viewmodel.dart';
import 'package:family_game_score/viewmodel/provider/player_provider.dart';
import 'package:family_game_score/viewmodel/provider/session_provider.dart';
import 'package:family_game_score/view/widget/common_async_widget.dart';
import 'package:family_game_score/view/widget/gradient_circle_button.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(homeViewModelProvider);

    return Scaffold(
      body: vm.session.when(
        data: (data) => buildPlayers(context, ref, data, vm),
        loading: () => CommonAsyncWidgets.showLoading(),
        error: (error, stackTrace) =>
            CommonAsyncWidgets.showDataFetchErrorMessage(
                context, ref, sessionProvider, error),
      ),
    );
  }

  Widget buildPlayers(
      BuildContext context, WidgetRef ref, Session? session, HomeViewModel vm) {
    return vm.players.when(
        data: (data) {
          return Center(
              child: buildCenterCircleButton(context, ref, session, data, vm));
        },
        loading: () => CommonAsyncWidgets.showLoading(),
        error: (error, stackTrace) =>
            CommonAsyncWidgets.showDataFetchErrorMessage(
                context, ref, playerProvider, error));
  }

  Widget buildCenterCircleButton(BuildContext context, WidgetRef ref,
      Session? session, List<Player> players, HomeViewModel vm) {
    return GradientCircleButton(
      onPressed: () async {
        vm.handleButtonPress(context);
      },
      text: vm.getButtonText(context),
      size: 200.0,
      gradientColors: vm.getGradientColors(),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Gill Sans',
      ),
    );
  }
}
