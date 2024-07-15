import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/session.dart';
import 'package:family_game_score/model/repository/result_repository.dart';
import 'package:family_game_score/provider/result_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

import 'result_provider_test.mocks.dart';

@GenerateMocks([Database])
void main() {
  late ProviderContainer container;
  late MockDatabase mockDatabase;
  late ResultRepository resultRepository;

  setUp(() {
    mockDatabase = MockDatabase();
    resultRepository = ResultRepository(mockDatabase);

    container = ProviderContainer(
      overrides: [
        resultProvider.overrideWith(() {
          final notifier = ResultNotifier(mockDatabase);
          notifier.resultRepository = resultRepository;
          return notifier;
        }),
      ],
    );

    when(mockDatabase.rawQuery(any, any)).thenAnswer((_) async => [
          {
            'id': 1,
            'playerId': 1,
            'sessionId': 1,
            'score': 30,
            'rank': 1,
          },
          {
            'id': 2,
            'playerId': 2,
            'sessionId': 1,
            'score': 20,
            'rank': 2,
          },
          {
            'id': 3,
            'playerId': 3,
            'sessionId': 1,
            'score': 10,
            'rank': 3,
          },
        ]);
  });

  group('Testing ResultProvider', () {
    test('Add Result', () async {
      when(mockDatabase.rawInsert(any, any)).thenAnswer((_) async => 1);
      when(mockDatabase.rawUpdate(any, any)).thenAnswer((_) async => 1);
      const players = [
        Player(id: 1, name: 'Alice', status: 0),
        Player(id: 2, name: 'Bob', status: 0),
        Player(id: 3, name: 'Charlie', status: 0),
      ];
      const session = Session(id: 1, round: 3, begTime: '2022-01-01 00:00:00');
      await container.read(resultProvider.notifier).addResult(players, session);

      verify(mockDatabase.rawInsert(
          'INSERT INTO Result(playerId, sessionId, score, rank) VALUES(?, ?, ?, 1)',
          [1, 1, 30]));
      verify(mockDatabase.rawInsert(
          'INSERT INTO Result(playerId, sessionId, score, rank) VALUES(?, ?, ?, 1)',
          [2, 1, 20]));
      verify(mockDatabase.rawInsert(
          'INSERT INTO Result(playerId, sessionId, score, rank) VALUES(?, ?, ?, 1)',
          [3, 1, 10]));
    });
  });
}
