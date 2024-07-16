import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/session.dart';
import 'package:family_game_score/model/repository/result_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

import 'result_repository_test.mocks.dart';

@GenerateMocks([Database])
void main() {
  late MockDatabase mockDatabase;
  late ResultRepository repository;

  setUp(() {
    mockDatabase = MockDatabase();
    repository = ResultRepository(mockDatabase);
  });

  group('ResultRepository - Normal cases', () {
    test('Add Result - Multiple Players', () async {
      when(mockDatabase.rawInsert(any, any)).thenAnswer((_) async => 1);
      final players = [
        const Player(id: 1, name: 'Taro', status: 0),
        const Player(id: 2, name: 'Jiro', status: 0),
        const Player(id: 3, name: 'Saburo', status: 0),
      ];
      const session = Session(id: 1, round: 2, begTime: '2020-01-01 00:00:00');

      await repository.addResult(players, session);

      verify(mockDatabase.rawInsert(
          'INSERT INTO Result(playerId, sessionId, score, rank) VALUES(?, ?, ?, 1)',
          [1, 1, 30])).called(1);
      verify(mockDatabase.rawInsert(
          'INSERT INTO Result(playerId, sessionId, score, rank) VALUES(?, ?, ?, 1)',
          [2, 1, 20])).called(1);
      verify(mockDatabase.rawInsert(
          'INSERT INTO Result(playerId, sessionId, score, rank) VALUES(?, ?, ?, 1)',
          [3, 1, 10])).called(1);
    });

    test('Get Result - Multiple Results', () async {
      when(mockDatabase.rawQuery(any, any)).thenAnswer((_) async => [
            {'id': 1, 'playerId': 1, 'sessionId': 1, 'score': 40, 'rank': 1},
            {'id': 2, 'playerId': 2, 'sessionId': 1, 'score': 30, 'rank': 2},
            {'id': 3, 'playerId': 3, 'sessionId': 1, 'score': 20, 'rank': 3},
          ]);
      const session = Session(id: 1, round: 2, begTime: '2020-01-01 00:00:00');
      final results = await repository.getResult(session);

      expect(results.length, 3);
      expect(results[0].playerId, 1);
      expect(results[0].score, 40);
      expect(results[0].rank, 1);
      expect(results[2].playerId, 3);
      expect(results[2].score, 20);
      expect(results[2].rank, 3);
      verify(mockDatabase.rawQuery(
          'SELECT * FROM Result WHERE sessionId = ? ORDER BY score DESC',
          [1])).called(1);
    });

    test('Update Result - Multiple Players', () async {
      when(mockDatabase.rawQuery(any, any)).thenAnswer((invocation) {
        final args = invocation.positionalArguments[1] as List;
        if (args[0] == 1) {
          return Future.value([
            {'id': 1, 'playerId': 1, 'sessionId': 1, 'score': 40, 'rank': 1}
          ]);
        } else if (args[0] == 2) {
          return Future.value([
            {'id': 2, 'playerId': 2, 'sessionId': 1, 'score': 30, 'rank': 2}
          ]);
        } else {
          return Future.value([
            {'id': 3, 'playerId': 3, 'sessionId': 1, 'score': 20, 'rank': 3}
          ]);
        }
      });
      when(mockDatabase.rawUpdate(any, any)).thenAnswer((_) async => 1);
      final players = [
        const Player(id: 1, name: 'Taro', status: 0),
        const Player(id: 2, name: 'Jiro', status: 0),
        const Player(id: 3, name: 'Saburo', status: 0),
      ];
      const session = Session(id: 1, round: 2, begTime: '2020-01-01 00:00:00');

      await repository.updateResult(players, session);

      verify(mockDatabase.rawUpdate(
          'UPDATE Result SET score = ? WHERE playerId = ? AND sessionId = ?',
          [70, 1, 1])).called(1);
      verify(mockDatabase.rawUpdate(
          'UPDATE Result SET score = ? WHERE playerId = ? AND sessionId = ?',
          [50, 2, 1])).called(1);
      verify(mockDatabase.rawUpdate(
          'UPDATE Result SET score = ? WHERE playerId = ? AND sessionId = ?',
          [30, 3, 1])).called(1);
    });

    test('Update Rank - Different scores', () async {
      when(mockDatabase.rawQuery(any, any)).thenAnswer((_) async => [
            {'id': 1, 'playerId': 1, 'sessionId': 1, 'score': 40, 'rank': 1},
            {'id': 2, 'playerId': 2, 'sessionId': 1, 'score': 30, 'rank': 2},
            {'id': 3, 'playerId': 3, 'sessionId': 1, 'score': 20, 'rank': 3},
          ]);
      when(mockDatabase.rawUpdate(any, any)).thenAnswer((_) async => 1);
      const session = Session(id: 1, round: 2, begTime: '2020-01-01 00:00:00');

      await repository.updateRank(session);

      verify(mockDatabase.rawUpdate(
          'UPDATE Result SET rank = ? WHERE id = ?', [1, 1])).called(1);
      verify(mockDatabase.rawUpdate(
          'UPDATE Result SET rank = ? WHERE id = ?', [2, 2])).called(1);
      verify(mockDatabase.rawUpdate(
          'UPDATE Result SET rank = ? WHERE id = ?', [3, 3])).called(1);
    });

    test('Update Rank - Same scores', () async {
      when(mockDatabase.rawQuery(any, any)).thenAnswer((_) async => [
            {'id': 1, 'playerId': 1, 'sessionId': 1, 'score': 40, 'rank': 1},
            {'id': 2, 'playerId': 2, 'sessionId': 1, 'score': 40, 'rank': 2},
            {'id': 3, 'playerId': 3, 'sessionId': 1, 'score': 20, 'rank': 3},
          ]);
      when(mockDatabase.rawUpdate(any, any)).thenAnswer((_) async => 1);
      const session = Session(id: 1, round: 2, begTime: '2020-01-01 00:00:00');

      await repository.updateRank(session);

      verify(mockDatabase.rawUpdate(
          'UPDATE Result SET rank = ? WHERE id = ?', [1, 1])).called(1);
      verify(mockDatabase.rawUpdate(
          'UPDATE Result SET rank = ? WHERE id = ?', [1, 2])).called(1);
      verify(mockDatabase.rawUpdate(
          'UPDATE Result SET rank = ? WHERE id = ?', [3, 3])).called(1);
    });
  });

  group('ResultRepository - Edge cases', () {
    test('Add Result - Single Player', () async {
      when(mockDatabase.rawInsert(any, any)).thenAnswer((_) async => 1);
      final players = [const Player(id: 1, name: 'Taro', status: 0)];
      const session = Session(id: 1, round: 2, begTime: '2020-01-01 00:00:00');

      await repository.addResult(players, session);

      verify(mockDatabase.rawInsert(
          'INSERT INTO Result(playerId, sessionId, score, rank) VALUES(?, ?, ?, 1)',
          [1, 1, 10])).called(1);
    });

    test('Get Result - No Results', () async {
      when(mockDatabase.rawQuery(any, any)).thenAnswer((_) async => []);
      const session = Session(id: 1, round: 2, begTime: '2020-01-01 00:00:00');
      final results = await repository.getResult(session);

      expect(results, isEmpty);
    });

    test('Update Result - Single Player', () async {
      when(mockDatabase.rawQuery(any, any)).thenAnswer((_) async => [
            {'id': 1, 'playerId': 1, 'sessionId': 1, 'score': 40, 'rank': 1}
          ]);
      when(mockDatabase.rawUpdate(any, any)).thenAnswer((_) async => 1);
      final players = [const Player(id: 1, name: 'Taro', status: 0)];
      const session = Session(id: 1, round: 2, begTime: '2020-01-01 00:00:00');

      await repository.updateResult(players, session);

      verify(mockDatabase.rawUpdate(
          'UPDATE Result SET score = ? WHERE playerId = ? AND sessionId = ?',
          [50, 1, 1])).called(1);
    });

    test('Update Rank - All Same Scores', () async {
      when(mockDatabase.rawQuery(any, any)).thenAnswer((_) async => [
            {'id': 1, 'playerId': 1, 'sessionId': 1, 'score': 40, 'rank': 1},
            {'id': 2, 'playerId': 2, 'sessionId': 1, 'score': 40, 'rank': 2},
            {'id': 3, 'playerId': 3, 'sessionId': 1, 'score': 40, 'rank': 3},
          ]);
      when(mockDatabase.rawUpdate(any, any)).thenAnswer((_) async => 1);
      const session = Session(id: 1, round: 2, begTime: '2020-01-01 00:00:00');

      await repository.updateRank(session);

      verify(mockDatabase.rawUpdate(
          'UPDATE Result SET rank = ? WHERE id = ?', [1, 1])).called(1);
      verify(mockDatabase.rawUpdate(
          'UPDATE Result SET rank = ? WHERE id = ?', [1, 2])).called(1);
      verify(mockDatabase.rawUpdate(
          'UPDATE Result SET rank = ? WHERE id = ?', [1, 3])).called(1);
    });
  });

  group('ResultRepository - Error cases', () {
    test('Add Result - Database Exception', () async {
      when(mockDatabase.rawInsert(any, any))
          .thenThrow(Exception('Failed to insert'));
      final players = [const Player(id: 1, name: 'Taro', status: 0)];
      const session = Session(id: 1, round: 2, begTime: '2020-01-01 00:00:00');

      expect(() => repository.addResult(players, session),
          throwsA(isA<Exception>()));
    });

    test('Get Result - Database Exception', () async {
      when(mockDatabase.rawQuery(any, any))
          .thenThrow(Exception('Failed to query'));
      const session = Session(id: 1, round: 2, begTime: '2020-01-01 00:00:00');

      expect(() => repository.getResult(session), throwsA(isA<Exception>()));
    });

    test('Update Result - Database Exception', () async {
      when(mockDatabase.rawQuery(any, any)).thenAnswer((_) async => [
            {'id': 1, 'playerId': 1, 'sessionId': 1, 'score': 40, 'rank': 1}
          ]);
      when(mockDatabase.rawUpdate(any, any))
          .thenThrow(Exception('Failed to update'));
      final players = [const Player(id: 1, name: 'Taro', status: 0)];
      const session = Session(id: 1, round: 2, begTime: '2020-01-01 00:00:00');

      expect(() => repository.updateResult(players, session),
          throwsA(isA<Exception>()));
    });

    test('Update Rank - Database Exception', () async {
      when(mockDatabase.rawQuery(any, any)).thenAnswer((_) async => [
            {'id': 1, 'playerId': 1, 'sessionId': 1, 'score': 40, 'rank': 1}
          ]);
      when(mockDatabase.rawUpdate(any, any))
          .thenThrow(Exception('Failed to update rank'));
      const session = Session(id: 1, round: 2, begTime: '2020-01-01 00:00:00');

      expect(() => repository.updateRank(session), throwsA(isA<Exception>()));
    });
  });
}
