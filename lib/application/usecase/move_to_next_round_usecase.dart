import 'package:family_game_score/application/state/result_notifier.dart';
import 'package:family_game_score/application/state/session_notifier.dart';
import 'package:family_game_score/domain/result.dart';
import 'package:family_game_score/infrastructure/repository/database_helper.dart';

class MoveToNextRoundUsecase {
  final SessionNotifier _sessionNotifier;
  final ResultNotifier _resultNotifier;

  MoveToNextRoundUsecase(this._sessionNotifier, this._resultNotifier);

  Future<Result> execute() async {
    try {
      await DatabaseHelper.instance.database.transaction((txc) async {
        await _sessionNotifier.addSession(txc);
        await _sessionNotifier.updateRound(txc);
        await _resultNotifier.addOrUpdateResult(txc);
      });
      return const Success(null);
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
