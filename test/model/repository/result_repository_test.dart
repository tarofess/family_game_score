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

  group('Testing ResultRepository', () {
    test('Add Result', () async {
      when(mockDatabase.rawInsert(any, any)).thenAnswer((_) async => 1);
      const players = [
        Player(id: 1, name: 'Taro', status: 0),
        Player(id: 2, name: 'Jiro', status: 0)
      ];
      const session = Session(id: 1, round: 2, begTime: '2020-01-01 00:00:00');
      await repository.addResult(players, session);

      verify(mockDatabase.rawInsert(
          'INSERT INTO Result(playerId, sessionId, score, rank) VALUES(?, ?, ?, 1)',
          [1, 1, 20])).called(1);
      verify(mockDatabase.rawInsert(
          'INSERT INTO Result(playerId, sessionId, score, rank) VALUES(?, ?, ?, 1)',
          [2, 1, 10])).called(1);
    });

    test('Get Result', () async {
      when(mockDatabase.rawQuery(any, any)).thenAnswer((_) async => [
            {'id': 1, 'playerId': 1, 'sessionId': 1, 'score': 40, 'rank': 1},
            {'id': 2, 'playerId': 2, 'sessionId': 1, 'score': 20, 'rank': 2},
          ]);
      final repository = ResultRepository(mockDatabase);
      const session = Session(id: 1, round: 2, begTime: '2020-01-01 00:00:00');
      final results = await repository.getResult(session);

      expect(results[0].playerId, 1);
      expect(results[0].score, 40);
      expect(results[0].rank, 1);
      expect(results[1].playerId, 2);
      expect(results[1].score, 20);
      expect(results[1].rank, 2);
    });

    test('Update Result', () async {
      when(mockDatabase
          .rawQuery('SELECT * FROM Result WHERE playerId = ? AND sessionId = ?',
              [1, 1])).thenAnswer((_) async => [
            {'id': 1, 'playerId': 1, 'sessionId': 1, 'score': 40, 'rank': 1}
          ]);
      when(mockDatabase
          .rawQuery('SELECT * FROM Result WHERE playerId = ? AND sessionId = ?',
              [2, 1])).thenAnswer((_) async => [
            {'id': 2, 'playerId': 2, 'sessionId': 1, 'score': 20, 'rank': 3}
          ]);
      when(mockDatabase
          .rawQuery('SELECT * FROM Result WHERE playerId = ? AND sessionId = ?',
              [3, 1])).thenAnswer((_) async => [
            {'id': 3, 'playerId': 3, 'sessionId': 1, 'score': 30, 'rank': 2}
          ]);
      when(mockDatabase.rawUpdate(any, any)).thenAnswer((_) async => 1);
      const players = [
        Player(id: 1, name: 'Taro', status: 0),
        Player(id: 2, name: 'Jiro', status: 0),
        Player(id: 3, name: 'Saburo', status: 0),
      ];
      const session = Session(id: 1, round: 2, begTime: '2020-01-01 00:00:00');
      final repository = ResultRepository(mockDatabase);
      await repository.updateResult(players, session);

      verify(mockDatabase.rawUpdate(
          'UPDATE Result SET score = ? WHERE playerId = ? AND sessionId = ?',
          [70, 1, 1])).called(1);
      verify(mockDatabase.rawUpdate(
          'UPDATE Result SET score = ? WHERE playerId = ? AND sessionId = ?',
          [40, 2, 1])).called(1);
      verify(mockDatabase.rawUpdate(
          'UPDATE Result SET score = ? WHERE playerId = ? AND sessionId = ?',
          [40, 3, 1])).called(1);
    });

    test('Update Rank - Different scores', () async {
      when(mockDatabase.rawQuery(any, any)).thenAnswer((_) async => [
            {'id': 1, 'playerId': 1, 'sessionId': 1, 'score': 40, 'rank': 1},
            {'id': 2, 'playerId': 2, 'sessionId': 1, 'score': 20, 'rank': 2},
            {'id': 3, 'playerId': 3, 'sessionId': 1, 'score': 30, 'rank': 3},
          ]);
      when(mockDatabase.rawUpdate(any, any)).thenAnswer((_) async => 1);
      final repository = ResultRepository(mockDatabase);
      const session = Session(id: 1, round: 2, begTime: '2020-01-01 00:00:00');
      await repository.updateRank(session);

      verify(mockDatabase.rawUpdate(
          'UPDATE Result SET rank = ? WHERE id = ?', [1, 1])).called(1);
      verify(mockDatabase.rawUpdate(
          'UPDATE Result SET rank = ? WHERE id = ?', [2, 2])).called(1);
    });

    test('Update Rank - Same scores', () async {
      when(mockDatabase.rawQuery(any, any)).thenAnswer((_) async => [
            {'id': 1, 'playerId': 1, 'sessionId': 1, 'score': 40, 'rank': 1},
            {'id': 2, 'playerId': 2, 'sessionId': 1, 'score': 40, 'rank': 2},
            {'id': 3, 'playerId': 3, 'sessionId': 1, 'score': 20, 'rank': 3},
          ]);
      when(mockDatabase.rawUpdate(any, any)).thenAnswer((_) async => 1);
      final repository = ResultRepository(mockDatabase);
      const session = Session(id: 1, round: 2, begTime: '2020-01-01 00:00:00');
      await repository.updateRank(session);

      verify(mockDatabase.rawUpdate(
          'UPDATE Result SET rank = ? WHERE id = ?', [1, 1])).called(1);
      verify(mockDatabase.rawUpdate(
          'UPDATE Result SET rank = ? WHERE id = ?', [1, 2])).called(1);
    });
  });

  group('Testing ResultRepository - Exception', () {
    test('Add Result - Throws exception', () {
      when(mockDatabase.rawInsert(any, any)).thenThrow(Exception());
      const players = [
        Player(id: 1, name: 'Taro', status: 0),
        Player(id: 2, name: 'Jiro', status: 0)
      ];
      const session = Session(id: 1, round: 2, begTime: '2020-01-01 00:00:00');

      expect(() async => await repository.addResult(players, session),
          throwsException);
    });

    test('Get Result - Throws Exception', () async {
      when(mockDatabase.rawQuery(any, any))
          .thenThrow(Exception('Failed to fetch'));
      const session = Session(id: 1, round: 2, begTime: '2020-01-01 00:00:00');

      expect(() async => await repository.getResult(session), throwsException);
    });

    test("Update Result - Throws Exception", () {
      when(mockDatabase.rawQuery(any, any)).thenAnswer((_) async => [
            {'id': 1, 'playerId': 1, 'sessionId': 1, 'score': 40, 'rank': 1},
            {'id': 2, 'playerId': 2, 'sessionId': 1, 'score': 20, 'rank': 2},
          ]);
      when(mockDatabase.rawQuery(any, any))
          .thenThrow(Exception('Database error'));
      const players = [
        Player(id: 1, name: 'Taro', status: 0),
        Player(id: 2, name: 'Jiro', status: 0)
      ];
      const session = Session(id: 1, round: 2, begTime: '2020-01-01 00:00:00');

      expect(() async => await repository.updateResult(players, session),
          throwsException);
    });

    test('Update Rank - Throws Exception', () async {
      when(mockDatabase.rawQuery(any, any)).thenAnswer((_) async => [
            {'id': 1, 'playerId': 1, 'sessionId': 1, 'score': 40, 'rank': 1},
            {'id': 2, 'playerId': 2, 'sessionId': 1, 'score': 20, 'rank': 2},
          ]);
      when(mockDatabase.rawUpdate(any, any))
          .thenThrow(Exception('Database error'));
      final repository = ResultRepository(mockDatabase);
      const session = Session(id: 1, round: 2, begTime: '2020-01-01 00:00:00');

      expect(() => repository.updateRank(session), throwsException);
    });
  });
}
