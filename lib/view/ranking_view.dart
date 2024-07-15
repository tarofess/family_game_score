import 'package:family_game_score/main.dart';
import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/result.dart';
import 'package:family_game_score/model/entity/session.dart';
import 'package:family_game_score/provider/player_provider.dart';
import 'package:family_game_score/provider/result_provider.dart';
import 'package:family_game_score/provider/session_provider.dart';
import 'package:family_game_score/view/widget/common_error_widget.dart';
import 'package:family_game_score/view/widget/sakura_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RankingView extends HookConsumerWidget {
  const RankingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(resultProvider);
    final players = ref.read(playerProvider);
    final session = ref.read(sessionProvider);

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
        title: session.value == null
            ? Text(AppLocalizations.of(context)!.announcementOfResults)
            : Text(AppLocalizations.of(context)!.currentRanking),
        actions: [
          if (session.value == null)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                showFinishDialog(context, ref);
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          results.when(data: (data) {
            return buildRankingList(data, players);
          }, loading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }, error: (error, stackTrace) {
            return CommonErrorWidget.showDataFetchErrorMessage(
                context, ref, resultProvider, error);
          }),
          Positioned.fill(
            child: IgnorePointer(
              child: buildSakuraAnimation(session, petals),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRankingList(List<Result> data, AsyncValue<List<Player>> players) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final result = data[index];
        return Card(
          elevation: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              leading: Text(
                  '${result.rank}${AppLocalizations.of(context)!.rank}',
                  style: const TextStyle(fontSize: 14)),
              title: Text(players.value!
                  .where((player) => player.id == result.playerId)
                  .first
                  .name),
              trailing: Text(
                  '${result.score}${AppLocalizations.of(context)!.point}',
                  style: const TextStyle(fontSize: 14))),
        );
      },
    );
  }

  Widget buildSakuraAnimation(
      AsyncValue<Session?> session, ValueNotifier<List<SakuraPetal>> petals) {
    return session.value == null
        ? CustomPaint(
            painter: SakuraPainter(petals.value),
            child: Container(),
          )
        : const SizedBox();
  }

  void showFinishDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              AppLocalizations.of(context)!.finishDialogTitleInRankingView),
          content: Text(
              AppLocalizations.of(context)!.finishDialogMessageInRankingView),
          actions: [
            TextButton(
              onPressed: () {
                // ignore: unused_result
                ref.refresh(resultProvider);
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()),
                );
              },
              child: Text(AppLocalizations.of(context)!.yes),
            ),
          ],
        );
      },
    );
  }
}
