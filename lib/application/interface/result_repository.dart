import 'package:sqflite/sqflite.dart';

import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/domain/entity/session.dart';
import 'package:family_game_score/domain/entity/result.dart';

abstract class ResultRepository {
  Future<void> addResult(Result result, Transaction txc);
  Future<List<Result>> getResult(Session session, Transaction? txc);
  Future<int> getTotalScore(Player player);
  Future<void> updateResult(Result result, Transaction txc);
  Future<void> updateRank(Result result, Transaction txc);
}
