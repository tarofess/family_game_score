import 'package:family_game_score/main.dart';
import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/infrastructure/service/dialog_service.dart';
import 'package:family_game_score/presentation/widget/list_card/result_list_card.dart';
import 'package:family_game_score/others/viewmodel/result_history_detail_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ResultHistoryDetailView extends ConsumerWidget {
  final DateTime selectedDay;
  final dialogService = getIt<DialogService>();

  ResultHistoryDetailView({super.key, required this.selectedDay});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(resultHistoryViewModelProvider(selectedDay));

    return Scaffold(
      appBar: buildAppBar(context, vm),
      body: buildBody(context, vm, ref),
    );
  }

  AppBar buildAppBar(BuildContext context, ResultHistoryDetailViewModel vm) {
    return AppBar(
      centerTitle: true,
      toolbarHeight: 56.r,
      title: Text('成績の詳細', style: TextStyle(fontSize: 20.sp)),
    );
  }

  Widget buildBody(
      BuildContext context, ResultHistoryDetailViewModel vm, WidgetRef ref) {
    return ListView.builder(
      itemCount: vm.resultHistorySections.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionHeader(context, index, vm, ref),
            buildSectionItems(index, vm, ref),
          ],
        );
      },
    );
  }

  Widget buildSectionHeader(BuildContext context, int index,
      ResultHistoryDetailViewModel vm, WidgetRef ref) {
    return GestureDetector(
      onTap: () async => await dialogService.showEditGameTypeDialog(
          context, ref, vm.resultHistorySections[index].session),
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
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.white,
                          fontSize: 20.sp,
                        ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget buildSectionItems(
      int index, ResultHistoryDetailViewModel vm, WidgetRef ref) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: vm.resultHistorySections[index].items.length,
      itemBuilder: (context, itemIndex) {
        return vm.isPlayerHasBeenDeleted(index, itemIndex)
            ? buildPlayerHasBeenDeletedCard(
                vm.resultHistorySections[index].items[itemIndex].player)
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

  Widget buildPlayerHasBeenDeletedCard(Player player) {
    return Card(
      elevation: 2.r,
      margin: EdgeInsets.symmetric(horizontal: 10.r, vertical: 6.r),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 10.r),
        title: Text(
          'プレイヤー：${player.name}は削除されました。',
          style: TextStyle(fontSize: 14.sp),
        ),
      ),
    );
  }
}
