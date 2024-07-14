import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/result.dart';
import 'package:family_game_score/model/entity/session.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'result_history.freezed.dart';

@freezed
class ResultHistory with _$ResultHistory {
  const factory ResultHistory({
    required Player player,
    required Session session,
    required Result result,
  }) = _ResultHistory;

  factory ResultHistory.fromJson(Map<String, dynamic> json) {
    return ResultHistory(
      player: Player(
        id: json['playerId'] as int,
        name: json['playerName'] as String,
        status: json['playerStatus'] as int,
      ),
      session: Session(
        id: json['sessionId'] as int,
        round: json['round'] as int,
        begTime: json['begTime'] as String,
        endTime: json['endTime'] as String?,
      ),
      result: Result(
        id: json['resultId'] as int,
        playerId: json['playerId'] as int,
        sessionId: json['sessionId'] as int,
        score: json['score'] as int,
        rank: json['rank'] as int,
      ),
    );
  }
}
