import 'package:family_game_score/application/state/session_notifier.dart';
import 'package:family_game_score/domain/result.dart';

class AddGameTypeUsecase {
  final SessionNotifier _sessionNotifier;

  AddGameTypeUsecase(this._sessionNotifier);

  Future<Result> execute(String result) async {
    try {
      await _sessionNotifier.addGameType(result);
      return const Success(null);
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
