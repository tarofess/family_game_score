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
    test('Get ResultHistory', () async {
      when(mockDatabase.rawQuery(any, any)).thenAnswer((_) async => [
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
            }
          ]);
      final results = await repository.getResultHistory();

      expect(results[0].player.id, 1);
      expect(results[0].player.name, 'Taro');
      expect(results[0].session.id, 1);
      expect(results[0].session.begTime, '2020-01-01 00:00:00');
      expect(results[0].result.score, 50);
      expect(results[0].result.rank, 1);
    });
  });

  group('Testing ResultHistoryRepository - Exception', () {
    test('Get ResultHistory - Exception', () async {
      when(mockDatabase.rawQuery(any)).thenThrow(Exception('Error'));
      expect(() async => await repository.getResultHistory(), throwsException);
    });
  });
}
