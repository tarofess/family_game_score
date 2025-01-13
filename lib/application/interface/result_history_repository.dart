import 'package:family_game_score/domain/entity/result_history.dart';

abstract class ResultHistoryRepository {
  Future<List<ResultHistory>> getResultHistory();
}
