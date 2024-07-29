import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/result_history.dart';
import 'package:family_game_score/viewmodel/provider/player_provider.dart';
import 'package:family_game_score/viewmodel/provider/result_history_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ResultHistoryDetailViewModel {
  final Ref ref;

  ResultHistoryDetailViewModel(this.ref);

  AsyncValue<List<ResultHistory>> get resultHistory =>
      ref.watch(resultHistoryProvider);
  AsyncValue<List<Player>> get players => ref.watch(playerProvider);
}

final resultHistoryViewModelProvider =
    Provider((ref) => ResultHistoryDetailViewModel(ref));
