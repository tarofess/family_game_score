import 'package:family_game_score/viewmodel/provider/result_history_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ResultHistoryViewModel {
  final Ref ref;

  ResultHistoryViewModel(this.ref);

  // get resultHistory => ref.watch(resultHistoryProvider);
}

final resultHistoryViewModelProvider =
    AutoDisposeProvider((ref) => ResultHistoryViewModel(ref));
