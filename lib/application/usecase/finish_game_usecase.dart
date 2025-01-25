import 'package:family_game_score/application/state/session_notifier.dart';
import 'package:family_game_score/domain/result.dart';

class FinishGameUsecase {
  final SessionNotifier _sessionNotifier;

  FinishGameUsecase(this._sessionNotifier);

  Future<Result> execute() async {
    try {
      await _sessionNotifier.updateEndTime();
      return const Success();
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
