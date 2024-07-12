import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/repository/player_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

import 'player_repository_test.mocks.dart';

@GenerateMocks([Database])
void main() {
  late MockDatabase mockDatabase;

  setUp(() {
    mockDatabase = MockDatabase();
  });

  group('Testing PlayerRepository', () {
    test('Add Player', () async {
      when(mockDatabase.rawInsert(any, any)).thenAnswer((_) async => 1);
      final repository = PlayerRepository(mockDatabase);
      final newPlayer = await repository.addPlayer('Taro');

      expect(newPlayer.id, 1);
      expect(newPlayer.name, 'Taro');
      expect(newPlayer.status, 0);
    });

    test('Get Player', () async {
      when(mockDatabase.rawQuery(any, any)).thenAnswer((_) async => [
            {'id': 1, 'name': 'Taro', 'status': 0},
            {'id': 2, 'name': 'Jiro', 'status': 0},
            {'id': 3, 'name': 'Saburo', 'status': 0}
          ]);
      final repository = PlayerRepository(mockDatabase);
      final players = await repository.getPlayer();

      expect(players.length, 3);
      expect(players[0].name, 'Taro');
      expect(players[1].name, 'Jiro');
      expect(players[2].name, 'Saburo');
    });

    test('Update Player', () async {
      when(mockDatabase.rawUpdate(any, any)).thenAnswer((_) async => 1);
      const player = Player(id: 4, name: 'Shiro', status: 0);
      final repository = PlayerRepository(mockDatabase);
      await repository.updatePlayer(player);

      verify(mockDatabase.rawUpdate('UPDATE Player SET name = ? WHERE id = ?',
          [player.name, player.id])).called(1);
    });

    test('Delete Player', () async {
      when(mockDatabase.rawUpdate(any, any)).thenAnswer((_) async => 1);
      const player = Player(id: 5, name: 'Goro', status: 0);
      final repository = PlayerRepository(mockDatabase);
      await repository.deletePlayer(player);

      verify(mockDatabase.rawUpdate(
          'UPDATE Player SET status = -1 WHERE id = ?', [player.id])).called(1);
    });
  });

  group('Testing PlayerRepository - Exception', () {
    test('Add Player - Throws Exception', () async {
      when(mockDatabase.rawInsert(any, any))
          .thenThrow(Exception('Failed to insert'));
      final repository = PlayerRepository(mockDatabase);

      expect(() => repository.addPlayer('Taro'), throwsException);
    });

    test('Get Player - Throws Exception', () async {
      when(mockDatabase.rawQuery(any, any))
          .thenThrow(Exception('Failed to fetch'));
      final repository = PlayerRepository(mockDatabase);

      expect(() async => await repository.getPlayer(), throwsException);
    });

    test('Update Player - Throws Exception', () async {
      when(mockDatabase.rawUpdate(any, any))
          .thenThrow(Exception('Failed to update'));
      const player = Player(id: 4, name: 'Shiro', status: 0);
      final repository = PlayerRepository(mockDatabase);

      expect(
          () async => await repository.updatePlayer(player), throwsException);
    });

    test('Delete Player - Throws Exception', () async {
      when(mockDatabase.rawUpdate(any, any))
          .thenThrow(Exception('Failed to delete'));
      const player = Player(id: 5, name: 'Goro', status: 0);
      final repository = PlayerRepository(mockDatabase);

      expect(
          () async => await repository.deletePlayer(player), throwsException);
    });
  });
}
