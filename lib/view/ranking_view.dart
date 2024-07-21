import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/result.dart';
import 'package:family_game_score/view/widget/result_card.dart';
import 'package:family_game_score/viewmodel/provider/player_provider.dart';
import 'package:family_game_score/viewmodel/provider/result_provider.dart';
import 'package:family_game_score/view/widget/common_async_widget.dart';
import 'package:family_game_score/view/widget/sakura_painter.dart';
import 'package:family_game_score/viewmodel/ranking_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RankingView extends HookConsumerWidget {
  const RankingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(rankingViewModelProvider);

    final animationController = useAnimationController(
      duration: const Duration(seconds: 10),
    )..repeat();

    final petals = useState(List.generate(35, (index) => SakuraPetal()));

    useEffect(() {
      void listener() {
        petals.value = petals.value.map((petal) {
          petal.update();
          return petal;
        }).toList();
      }

      animationController.addListener(listener);
      return () => animationController.removeListener(listener);
    }, [animationController]);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: vm.getAppBarTitle(context),
        actions: [
          vm.getIconButton(context, ref),
        ],
      ),
      body: Stack(
        children: [
          vm.results.when(
              data: (data) {
                return buildRankingList(data, vm.players, context, ref);
              },
              loading: () => CommonAsyncWidgets.showLoading(),
              error: (error, stackTrace) =>
                  CommonAsyncWidgets.showDataFetchErrorMessage(
                      context, ref, resultProvider, error)),
          Positioned.fill(
            child: IgnorePointer(
              child: vm.getSakuraAnimation(petals),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRankingList(List<Result> data, AsyncValue<List<Player>> players,
      BuildContext context, WidgetRef ref) {
    return players.when(
        data: (playersData) => ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final result = data[index];
                final player =
                    playersData.firstWhere((p) => p.id == result.playerId);
                return ResultCard(player: player, result: result);
              },
            ),
        loading: () => CommonAsyncWidgets.showLoading(),
        error: (error, stackTrace) =>
            CommonAsyncWidgets.showDataFetchErrorMessage(
                context, ref, playerProvider, error));
  }
}
