import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:family_game_score/application/state/result_history_notifier.dart';
import 'package:family_game_score/domain/entity/result_history.dart';
import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/presentation/widget/async_error_widget.dart';
import 'package:family_game_score/presentation/widget/list_card/result_list_card.dart';
import 'package:family_game_score/presentation/dialog/input_dialog.dart';
import 'package:family_game_score/domain/result.dart';
import 'package:family_game_score/presentation/dialog/error_dialog.dart';
import 'package:family_game_score/presentation/provider/update_game_type_usecase_provider.dart';
import 'package:family_game_score/presentation/viewmodel/result_history_detail_viewmodel.dart';
import 'package:family_game_score/presentation/widget/loading_overlay.dart';

class ResultHistoryDetailPage extends ConsumerWidget {
  final DateTime selectedDay;

  const ResultHistoryDetailPage({super.key, required this.selectedDay});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultHistoryState = ref.watch(resultHistoryNotifierProvider);
    final vm = ref.watch(resultHistoryViewModelProvider(selectedDay));

    return Scaffold(
      appBar: AppBar(
        title: const Text('成績の詳細'),
      ),
      body: resultHistoryState.when(
        data: (resultHistories) {
          return ListView.builder(
            itemCount: vm.resultHistorySections.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSectionHeader(context, ref, resultHistories, index, vm),
                  buildSectionItems(context, ref, resultHistories, index, vm),
                ],
              );
            },
          );
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
        error: (error, stackTrace) {
          return AsyncErrorWidget(
            error: error,
            retry: () => resultHistoryState,
          );
        },
      ),
    );
  }

  Widget buildSectionHeader(
    BuildContext context,
    WidgetRef ref,
    List<ResultHistory> resultHistories,
    int index,
    ResultHistoryDetailViewModel vm,
  ) {
    return GestureDetector(
      onTap: () async {
        final gameType = await showInputDialog(
          context: context,
          title: '遊んだゲームの種類を編集できます',
          hintText: '例：大富豪',
        );

        if (gameType == null || !context.mounted) return;

        final result = await LoadingOverlay.of(context).during(
          () => ref.read(updateGameTypeUsecaseProvider).execute(
                vm.resultHistorySections[index].session,
                gameType,
              ),
        );

        switch (result) {
          case Success():
            break;
          case Failure(message: final message):
            if (context.mounted) showErrorDialog(context, message);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 139, 218, 255),
                Color.fromARGB(255, 54, 154, 255),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: vm.isGameTypeNull(vm.resultHistorySections[index].session)
                ? const Text('')
                : Text(
                    '${vm.resultHistorySections[index].session.gameType}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.white, fontSize: 20.sp),
                  ),
          ),
        ),
      ),
    );
  }

  Widget buildSectionItems(
    BuildContext context,
    WidgetRef ref,
    List<ResultHistory> resultHistories,
    int index,
    ResultHistoryDetailViewModel vm,
  ) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: vm.resultHistorySections[index].items.length,
      itemBuilder: (context, itemIndex) {
        return vm.isPlayerHasBeenDeleted(index, itemIndex)
            ? buildPlayerHasBeenDeletedCard(
                context,
                vm.resultHistorySections[index].items[itemIndex].player,
              )
            : ResultListCard(
                key: ValueKey(
                  vm.resultHistorySections[index].items[itemIndex].result.id,
                ),
                player: vm.resultHistorySections[index].items[itemIndex].player,
                result: vm.resultHistorySections[index].items[itemIndex].result,
              );
      },
    );
  }

  Widget buildPlayerHasBeenDeletedCard(BuildContext context, Player player) {
    return Card(
      elevation: 1.r,
      margin: EdgeInsets.symmetric(horizontal: 10.r, vertical: 6.r),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 10.r),
        title: Text(
          'プレイヤー：${player.name}は削除されました。',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
