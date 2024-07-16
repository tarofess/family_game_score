import 'package:family_game_score/model/repository/result_history_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

import 'result_history_repository_test.mocks.dart';

@GenerateMocks([Database])
void main() {
  late MockDatabase mockDatabase;
  late ResultHistoryRepository repository;

  setUp(() {
    mockDatabase = MockDatabase();
    repository = ResultHistoryRepository(mockDatabase);
  });

  group('Testing ResultHistoryRepository', () {
    test('Get ResultHistory - Normal case with multiple results', () async {
      when(mockDatabase.rawQuery(any)).thenAnswer((_) async => [
            {
              'resultId': 1,
              'playerId': 1,
              'sessionId': 1,
              'score': 50,
              'rank': 1,
              'playerName': 'Taro',
              'playerStatus': 0,
              'round': 2,
              'begTime': '2020-01-01 00:00:00',
              'endTime': '2020-01-01 12:00:00'
            },
            {
              'resultId': 2,
              'playerId': 2,
              'sessionId': 1,
              'score': 40,
              'rank': 2,
              'playerName': 'Hanako',
              'playerStatus': 1,
              'round': 2,
              'begTime': '2020-01-01 00:00:00',
              'endTime': '2020-01-01 12:00:00'
            }
          ]);

      final results = await repository.getResultHistory();

      expect(results.length, 2);

      expect(results[0].player.id, 1);
      expect(results[0].player.name, 'Taro');
      expect(results[0].player.status, 0);
      expect(results[0].session.id, 1);
      expect(results[0].session.round, 2);
      expect(results[0].session.begTime, '2020-01-01 00:00:00');
      expect(results[0].session.endTime, '2020-01-01 12:00:00');
      expect(results[0].result.id, 1);
      expect(results[0].result.playerId, 1);
      expect(results[0].result.sessionId, 1);
      expect(results[0].result.score, 50);
      expect(results[0].result.rank, 1);

      expect(results[1].player.id, 2);
      expect(results[1].player.name, 'Hanako');
      expect(results[1].player.status, 1);
      expect(results[1].result.score, 40);
      expect(results[1].result.rank, 2);
    });

    test('Get ResultHistory - Empty result', () async {
      when(mockDatabase.rawQuery(any)).thenAnswer((_) async => []);

      final results = await repository.getResultHistory();

      expect(results, isEmpty);
    });
  });

  group('Testing ResultHistoryRepository - Exception handling', () {
    test('Get ResultHistory - Database exception', () async {
      when(mockDatabase.rawQuery(any)).thenThrow(Exception('Database error'));

      expect(() => repository.getResultHistory(), throwsA(isA<Exception>()));
    });

    test('Get ResultHistory - General exception', () async {
      when(mockDatabase.rawQuery(any)).thenThrow(Exception('General error'));

      expect(() => repository.getResultHistory(), throwsException);
    });
  });

  group('Testing ResultHistoryRepository - Edge cases', () {
    test('Get ResultHistory - Large number of results', () async {
      final largeResultSet = List.generate(
          1000,
          (index) => {
                'resultId': index,
                'playerId': index % 10,
                'sessionId': index % 5,
                'score': index * 10,
                'rank': (index % 10) + 1,
                'playerName': 'Player $index',
                'playerStatus': index % 2,
                'round': (index % 3) + 1,
                'begTime': '2020-01-01 00:00:00',
                'endTime': '2020-01-01 12:00:00'
              });

      when(mockDatabase.rawQuery(any)).thenAnswer((_) async => largeResultSet);

      final results = await repository.getResultHistory();

      expect(results.length, 1000);
      expect(results.last.player.name, 'Player 999');
    });

    test('Get ResultHistory - Unexpected column in result', () async {
      when(mockDatabase.rawQuery(any)).thenAnswer((_) async => [
            {
              'resultId': 1,
              'playerId': 1,
              'sessionId': 1,
              'score': 50,
              'rank': 1,
              'playerName': 'Taro',
              'playerStatus': 0,
              'round': 2,
              'begTime': '2020-01-01 00:00:00',
              'endTime': '2020-01-01 12:00:00',
              'unexpectedColumn': 'Some value'
            }
          ]);

      final results = await repository.getResultHistory();

      expect(results.length, 1);
      // Verify that the unexpected column doesn't cause any issues
      expect(results[0].player.name, 'Taro');
      expect(results[0].result.score, 50);
      expect(results[0].session.round, 2);
    });
  });
}
