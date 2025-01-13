import 'package:family_game_score/application/state/result_history_notifier.dart';
import 'package:family_game_score/domain/entity/session.dart';
import 'package:family_game_score/domain/result.dart';

class UpdateGameTypeUsecase {
  final ResultHistoryNotifier _resultHistoryNotifier;

  UpdateGameTypeUsecase(this._resultHistoryNotifier);

  Future<Result> execute(Session session, String gameType) async {
    try {
      await _resultHistoryNotifier.updateSessionGameType(session, gameType);
      return const Success(null);
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
