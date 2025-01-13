import 'package:family_game_score/application/state/player_notifier.dart';
import 'package:family_game_score/domain/result.dart';

class StartGameUsecase {
  final PlayerNotifier _playerNotifier;

  StartGameUsecase(this._playerNotifier);

  Future<Result> execute() async {
    try {
      await _playerNotifier.getActivePlayer();
      return const Success(null);
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
