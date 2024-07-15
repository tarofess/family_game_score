import 'package:family_game_score/model/repository/result_history_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:sqflite/sqflite.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:family_game_score/model/entity/result_history.dart';
import 'package:family_game_score/provider/result_history_provider.dart';

import 'result_history_provider_test.mocks.dart';

@GenerateMocks([Database])
void main() {
  late ProviderContainer container;
  late MockDatabase mockDatabase;
  late ResultHistoryRepository resultHistoryRepository;

  setUp(() {
    mockDatabase = MockDatabase();
    resultHistoryRepository = ResultHistoryRepository(mockDatabase);

    container = ProviderContainer(
      overrides: [
        resultHistoryProvider.overrideWith(() {
          final notifier = ResultHistoryNotifier(mockDatabase);
          notifier.resultHistoryRepository = resultHistoryRepository;
          return notifier;
        }),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('ResultHistoryNotifier Tests', () {
    test('Normal case: Should return list of ResultHistory', () async {
      // Arrange
      final mockData = [
        {
          'resultId': 1,
          'playerId': 1,
          'sessionId': 1,
          'score': 100,
          'rank': 1,
          'playerName': 'Player 1',
          'playerStatus': 1,
          'round': 1,
          'begTime': '2023-01-01 10:00:00',
          'endTime': '2023-01-01 11:00:00',
        },
        {
          'resultId': 2,
          'playerId': 2,
          'sessionId': 1,
          'score': 90,
          'rank': 2,
          'playerName': 'Player 2',
          'playerStatus': 1,
          'round': 1,
          'begTime': '2023-01-01 10:00:00',
          'endTime': '2023-01-01 11:00:00',
        },
      ];

      when(mockDatabase.rawQuery(any)).thenAnswer((_) async => mockData);

      // Act
      final result = await container.read(resultHistoryProvider.future);

      // Assert
      expect(result, isA<List<ResultHistory>>());
      expect(result.length, 2);
      expect(result[0].result.id, 1);
      expect(result[1].result.id, 2);
      expect(result[0].player.name, 'Player 1');
      expect(result[1].player.name, 'Player 2');
    });

    test('Error case: Should throw an exception', () async {
      // Arrange
      when(mockDatabase.rawQuery(any)).thenThrow(Exception('Database error'));

      // Act & Assert
      expect(
        () => container.read(resultHistoryProvider.future),
        throwsException,
      );
    });

    test('Edge case: Empty result', () async {
      // Arrange
      when(mockDatabase.rawQuery(any)).thenAnswer((_) async => []);

      // Act
      final result = await container.read(resultHistoryProvider.future);

      // Assert
      expect(result, isA<List<ResultHistory>>());
      expect(result.isEmpty, true);
    });

    test('Edge case: Empty string values in result', () async {
      // Arrange
      final mockData = [
        {
          'resultId': 1,
          'playerId': 1,
          'sessionId': 1,
          'score': 0,
          'rank': 1,
          'playerName': '',
          'playerStatus': 0,
          'round': 1,
          'begTime': '2023-01-01 10:00:00',
          'endTime': null,
        },
      ];

      when(mockDatabase.rawQuery(any)).thenAnswer((_) async => mockData);

      // Act
      final result = await container.read(resultHistoryProvider.future);

      // Assert
      expect(result, isA<List<ResultHistory>>());
      expect(result.length, 1);
      expect(result[0].player.name, ''); // 空文字を期待
      expect(result[0].session.endTime, isNull);
      expect(result[0].result.id, 1);
      expect(result[0].player.id, 1);
      expect(result[0].session.id, 1);
      expect(result[0].result.score, 0);
    });
  });
}
