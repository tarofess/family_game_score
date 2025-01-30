import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/domain/entity/result.dart';
import 'package:family_game_score/domain/entity/session.dart';

class ScoreCalculator {
  List<Result> calculateScores(List<Player> players, Session session) {
    int x = players.length; // 順位ごとにscoreに10ポイントずつ差をつけるための変数
    List<Result> results = [];

    for (final player in players) {
      results.add(
        Result(
          playerId: player.id,
          sessionId: session.id,
          score: x * 10,
          rank: 0, // デフォルト値
        ),
      );
      x -= 1;
    }

    updateRanks(results);

    return results;
  }

  List<Result> calculateUpdatedScores(
    List<Player> players,
    Session session,
    List<Result> existingResults,
  ) {
    int x = players.length; // 順位ごとにscoreに10ポイントずつ差をつけるための変数
    List<Result> updatedResults = [];

    // プレイヤーの順番順に上からスコア付け
    for (final player in players) {
      final existingResult = existingResults.firstWhere(
        (result) =>
            result.playerId == player.id && result.sessionId == session.id,
        orElse: () => throw Exception('プレイヤーの結果が見つかりません'),
      );

      updatedResults.add(
        existingResult.copyWith(score: existingResult.score + (x * 10)),
      );

      x -= 1;
    }

    updateRanks(updatedResults);

    return updatedResults;
  }

  void updateRanks(List<Result> results) {
    results.sort((a, b) => b.score.compareTo(a.score));
    int rank = 1;

    for (int i = 0; i < results.length; i++) {
      if (i >= 1 && results[i].score == results[i - 1].score) {
        // 同じスコアの場合は一つ前と同じ順位にする
        results[i] = results[i].copyWith(rank: results[i - 1].rank);
      } else {
        results[i] = results[i].copyWith(rank: rank);
      }
      rank++;
    }
  }
}
