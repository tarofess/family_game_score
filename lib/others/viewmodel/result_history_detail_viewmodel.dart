import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/domain/entity/result_history.dart';
import 'package:family_game_score/domain/entity/session.dart';
import 'package:family_game_score/application/state/player_provider.dart';
import 'package:family_game_score/application/state/result_history_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class ResultHistoryDetailViewModel {
  final Ref ref;
  final DateTime selectedDay;

  ResultHistoryDetailViewModel(this.ref, this.selectedDay);

  AsyncValue<List<ResultHistory>> get resultHistories =>
      ref.watch(resultHistoryProvider);

  AsyncValue<List<Player>> get players => ref.watch(playerProvider);

  List<ResultHistorySection> get resultHistorySections {
    if (resultHistories.value != null) {
      final filteredResultHistoryies = resultHistories.value!.where((element) {
        final elementDate = DateTime.parse(element.session.endTime!);
        return isSameDay(elementDate, selectedDay);
      }).toList();

      if (filteredResultHistoryies.isNotEmpty) {
        final convertedResultHistorySection =
            convertToResultHistorySection(filteredResultHistoryies);
        return convertedResultHistorySection;
      }
    }
    return [];
  }

  bool isGameTypeNull(Session session) {
    return session.gameType == null ? true : false;
  }

  bool isPlayerHasBeenDeleted(int index, int itemIndex) {
    return resultHistorySections[index].items[itemIndex].player.status == -1
        ? true
        : false;
  }

  List<ResultHistorySection> convertToResultHistorySection(
      List<ResultHistory> resultHistories) {
    Map<int, List<ResultHistoryItems>> sessionItemsMap = {};

    for (var resultHistory in resultHistories) {
      int sessionId = resultHistory.session.id;
      if (!sessionItemsMap.containsKey(sessionId)) {
        sessionItemsMap[sessionId] = [];
      }
      sessionItemsMap[sessionId]!.add(ResultHistoryItems(
        player: resultHistory.player,
        result: resultHistory.result,
      ));
    }

    List<ResultHistorySection> sessionResultHistories = [];
    for (var entry in sessionItemsMap.entries) {
      int sessionId = entry.key;
      List<ResultHistoryItems> items = entry.value;

      Session session = resultHistories
          .firstWhere((history) => history.session.id == sessionId)
          .session;

      sessionResultHistories.add(ResultHistorySection(
        session: session,
        items: items,
      ));
    }

    return sessionResultHistories;
  }
}

final resultHistoryViewModelProvider =
    Provider.family<ResultHistoryDetailViewModel, DateTime>(
        (ref, selectedDay) => ResultHistoryDetailViewModel(ref, selectedDay));
