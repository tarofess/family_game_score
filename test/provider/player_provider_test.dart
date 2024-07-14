import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/repository/player_repository.dart';
import 'package:family_game_score/provider/player_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

import 'player_provider_test.mocks.dart';

@GenerateMocks([Database])
void main() {
  late ProviderContainer container;
  late MockDatabase mockDatabase;
  late PlayerRepository playerRepository;

  setUp(() {
    mockDatabase = MockDatabase();
    playerRepository = PlayerRepository(mockDatabase);

    container = ProviderContainer(
      overrides: [
        playerProvider.overrideWith(() {
          final notifier = PlayerNotifier(mockDatabase);
          notifier.playerRepository = playerRepository;
          return notifier;
        }),
      ],
    );
  });

  group('Testing PlayerProvider', () {
    test('Initial state is loading', () {
      expect(container.read(playerProvider),
          const AsyncValue<List<Player>>.loading());
    });

    test('Build', () async {
      when(mockDatabase.rawQuery(any, any)).thenAnswer((_) async => [
            {'id': 1, 'name': 'Taro', 'status': 0},
            {'id': 2, 'name': 'Jiro', 'status': 0},
            {'id': 3, 'name': 'Saburo', 'status': 0}
          ]);
      await container.read(playerProvider.future);

      expect(
          container.read(playerProvider),
          isA<AsyncData<List<Player>>>()
              .having((d) => d.value.length, 'player count', 3));
    });

    test('Add Player', () async {
      when(mockDatabase.rawQuery(any, any)).thenAnswer((_) async => [
            {'id': 1, 'name': 'Taro', 'status': 0},
            {'id': 2, 'name': 'Jiro', 'status': 0},
            {'id': 3, 'name': 'Saburo', 'status': 0}
          ]);
      when(mockDatabase.rawInsert(any, any)).thenAnswer((_) async => 1);
      await container.read(playerProvider.future);
      await container.read(playerProvider.notifier).addPlayer('New Player');

      verify(mockDatabase.rawInsert(
              'INSERT INTO Player(name, status) VALUES(?, 0)', ['New Player']))
          .called(1);
      expect(
          container.read(playerProvider),
          isA<AsyncData<List<Player>>>()
              .having((d) => d.value.length, 'player count', 4));
      expect(
          container.read(playerProvider),
          isA<AsyncData<List<Player>>>()
              .having((d) => d.value[3].name, 'player name', 'New Player'));
    });

    test('Get Player', () async {
      when(mockDatabase.rawQuery(any, any)).thenAnswer((_) async => [
            {'id': 1, 'name': 'Taro', 'status': 0},
            {'id': 2, 'name': 'Jiro', 'status': 0},
            {'id': 3, 'name': 'Saburo', 'status': 0}
          ]);
      await container.read(playerProvider.notifier).getPlayer();

      verify(mockDatabase.rawQuery('SELECT * FROM Player WHERE status = 0'))
          .called(2);
      expect(
          container.read(playerProvider),
          isA<AsyncData<List<Player>>>()
              .having((d) => d.value[0].name, 'player name', 'Taro'));
      expect(
          container.read(playerProvider),
          isA<AsyncData<List<Player>>>()
              .having((d) => d.value[1].name, 'player name', 'Jiro'));
      expect(
          container.read(playerProvider),
          isA<AsyncData<List<Player>>>()
              .having((d) => d.value[2].name, 'player name', 'Saburo'));
    });

    test('Update Player', () async {
      when(mockDatabase.rawQuery(any, any)).thenAnswer((_) async => [
            {'id': 1, 'name': 'Taro', 'status': 0},
            {'id': 2, 'name': 'Jiro', 'status': 0},
            {'id': 3, 'name': 'Saburo', 'status': 0}
          ]);
      when(mockDatabase.rawUpdate(any, any)).thenAnswer((_) async => 1);
      const player = Player(id: 1, name: 'Shiro', status: 0);
      await container.read(playerProvider.future);
      await container.read(playerProvider.notifier).updatePlayer(player);

      verify(mockDatabase.rawUpdate('UPDATE Player SET name = ? WHERE id = ?',
          [player.name, player.id])).called(1);
      expect(
        container.read(playerProvider),
        isA<AsyncData<List<Player>>>()
            .having((d) => d.value.length, 'player count', 3)
            .having((d) => d.value[0].name, 'updated player name', 'Shiro'),
      );
    });

    test('Delete Player', () async {
      when(mockDatabase.rawQuery(any, any)).thenAnswer((_) async => [
            {'id': 1, 'name': 'Taro', 'status': 0},
            {'id': 2, 'name': 'Jiro', 'status': 0},
            {'id': 3, 'name': 'Saburo', 'status': 0}
          ]);
      when(mockDatabase.rawUpdate(any, any)).thenAnswer((_) async => 1);
      const player = Player(id: 1, name: 'Taro', status: 0);
      await container.read(playerProvider.future);
      await container.read(playerProvider.notifier).deletePlayer(player);

      verify(mockDatabase.rawUpdate(
          'UPDATE Player SET status = -1 WHERE id = ?', [player.id])).called(1);
      expect(
        container.read(playerProvider),
        isA<AsyncData<List<Player>>>()
            .having((d) => d.value.length, 'player count', 2)
            .having((d) => d.value[0].name, 'player name', 'Jiro'),
      );
    });

    test('Reorder Player', () async {
      when(mockDatabase.rawQuery(any, any)).thenAnswer((_) async => [
            {'id': 1, 'name': 'Taro', 'status': 0},
            {'id': 2, 'name': 'Jiro', 'status': 0},
            {'id': 3, 'name': 'Saburo', 'status': 0}
          ]);
      await container.read(playerProvider.future);
      container.read(playerProvider.notifier).reorderPlayer(0, 2);

      expect(container.read(playerProvider).value![0].name, 'Jiro');
      expect(container.read(playerProvider).value![1].name, 'Saburo');
      expect(container.read(playerProvider).value![2].name, 'Taro');
    });

    test('Reset Player', () async {
      when(mockDatabase.rawQuery(any, any)).thenAnswer((_) async => [
            {'id': 2, 'name': 'Jiro', 'status': 0},
            {'id': 3, 'name': 'Saburo', 'status': 0},
            {'id': 1, 'name': 'Taro', 'status': 0},
          ]);
      await container.read(playerProvider.future);
      container.read(playerProvider.notifier).resetOrder();

      expect(container.read(playerProvider).value![0].name, 'Taro');
      expect(container.read(playerProvider).value![1].name, 'Jiro');
      expect(container.read(playerProvider).value![2].name, 'Saburo');
    });
  });

  group('Testing PlayerProvider - Exception', () {
    test('Add Player - Throws Exception', () async {
      when(mockDatabase.rawQuery(any, any)).thenAnswer((_) async => [
            {'id': 1, 'name': 'Taro', 'status': 0},
            {'id': 2, 'name': 'Jiro', 'status': 0},
            {'id': 3, 'name': 'Saburo', 'status': 0}
          ]);
      when(mockDatabase.rawInsert(any, any))
          .thenThrow(Exception('Failed to insert'));
      await container.read(playerProvider.future);
      await container.read(playerProvider.notifier).addPlayer('New Player');

      expect(container.read(playerProvider), isA<AsyncError>());
    });

    test('Get Player - Throws Exception', () async {
      when(mockDatabase.rawQuery(any, any))
          .thenThrow(Exception('Failed to get'));
      await container.read(playerProvider.notifier).getPlayer();

      expect(container.read(playerProvider), isA<AsyncError>());
    });

    test('Update Player - Throws Exception', () async {
      when(mockDatabase.rawQuery(any, any)).thenAnswer((_) async => [
            {'id': 1, 'name': 'Taro', 'status': 0},
            {'id': 2, 'name': 'Jiro', 'status': 0},
            {'id': 3, 'name': 'Saburo', 'status': 0}
          ]);
      when(mockDatabase.rawUpdate(any, any))
          .thenThrow(Exception('Failed to update'));
      await container.read(playerProvider.future);
      await container
          .read(playerProvider.notifier)
          .updatePlayer(const Player(id: 1, name: 'Shiro', status: 0));

      expect(container.read(playerProvider), isA<AsyncError>());
    });

    test('Delete Player - Throws Exception', () async {
      when(mockDatabase.rawQuery(any, any)).thenAnswer((_) async => [
            {'id': 1, 'name': 'Taro', 'status': 0},
            {'id': 2, 'name': 'Jiro', 'status': 0},
            {'id': 3, 'name': 'Saburo', 'status': 0}
          ]);
      when(mockDatabase.rawUpdate(any, any))
          .thenThrow(Exception('Failed to delete'));
      await container.read(playerProvider.future);
      await container
          .read(playerProvider.notifier)
          .deletePlayer(const Player(id: 1, name: 'Taro', status: 0));

      expect(container.read(playerProvider), isA<AsyncError>());
    });
  });
}
