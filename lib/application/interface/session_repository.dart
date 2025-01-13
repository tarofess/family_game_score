import 'package:sqflite/sqflite.dart';

import 'package:family_game_score/domain/entity/session.dart';

abstract class SessionRepository {
  Future<Session> addSession(int id, Transaction txc);
  Future<Session?> getSession();
  Future<int> getMaxID(Transaction txc);
  Future<Session> updateRound(Session session, Transaction txc);
  Future<Session> updateEndTime(Session session);
  Future<void> updateGameType(Session session, String gameType);
}
