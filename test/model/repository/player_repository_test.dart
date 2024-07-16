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
  late PlayerRepository playerRepository;

  setUp(() {
    mockDatabase = MockDatabase();
    playerRepository = PlayerRepository(mockDatabase);
  });

  group('PlayerRepository', () {
    group('addPlayer', () {
      test('should add a new player successfully', () async {
        when(mockDatabase.rawInsert(any, any)).thenAnswer((_) async => 1);

        final result = await playerRepository.addPlayer('John Doe');

        expect(result, isA<Player>());
        expect(result.id, 1);
        expect(result.name, 'John Doe');
        expect(result.status, 0);

        verify(mockDatabase.rawInsert(
            'INSERT INTO Player(name, status) VALUES(?, 0)', ['John Doe']));
      });

      test('should throw an exception when insertion fails', () async {
        when(mockDatabase.rawInsert(any, any))
            .thenThrow(Exception('Insertion failed'));

        expect(() => playerRepository.addPlayer('John Doe'),
            throwsA(isA<Exception>()));
      });
    });

    group('getPlayer', () {
      test('should return a list of active players', () async {
        when(mockDatabase.rawQuery(any)).thenAnswer((_) async => [
              {'id': 1, 'name': 'John Doe', 'status': 0},
              {'id': 2, 'name': 'Jane Doe', 'status': 0},
            ]);

        final result = await playerRepository.getPlayer();

        expect(result, isA<List<Player>>());
        expect(result.length, 2);
        expect(result[0].id, 1);
        expect(result[0].name, 'John Doe');
        expect(result[0].status, 0);
        expect(result[1].id, 2);
        expect(result[1].name, 'Jane Doe');
        expect(result[1].status, 0);

        verify(mockDatabase.rawQuery('SELECT * FROM Player WHERE status = 0'));
      });

      test('should return an empty list when no active players', () async {
        when(mockDatabase.rawQuery(any)).thenAnswer((_) async => []);

        final result = await playerRepository.getPlayer();

        expect(result, isEmpty);
      });

      test('should throw an exception when query fails', () async {
        when(mockDatabase.rawQuery(any)).thenThrow(Exception('Query failed'));

        expect(() => playerRepository.getPlayer(), throwsA(isA<Exception>()));
      });
    });

    group('updatePlayer', () {
      test('should update player successfully', () async {
        when(mockDatabase.rawUpdate(any, any)).thenAnswer((_) async => 1);

        const player = Player(id: 1, name: 'Updated John', status: 0);
        await playerRepository.updatePlayer(player);

        verify(mockDatabase.rawUpdate(
            'UPDATE Player SET name = ? WHERE id = ?', ['Updated John', 1]));
      });

      test('should throw an exception when update fails', () async {
        when(mockDatabase.rawUpdate(any, any))
            .thenThrow(Exception('Update failed'));

        const player = Player(id: 1, name: 'Updated John', status: 0);
        expect(() => playerRepository.updatePlayer(player),
            throwsA(isA<Exception>()));
      });
    });

    group('deletePlayer', () {
      test('should mark player as deleted successfully', () async {
        when(mockDatabase.rawUpdate(any, any)).thenAnswer((_) async => 1);

        const player = Player(id: 1, name: 'John Doe', status: 0);
        await playerRepository.deletePlayer(player);

        verify(mockDatabase
            .rawUpdate('UPDATE Player SET status = -1 WHERE id = ?', [1]));
      });

      test('should throw an exception when delete fails', () async {
        when(mockDatabase.rawUpdate(any, any))
            .thenThrow(Exception('Delete failed'));

        const player = Player(id: 1, name: 'John Doe', status: 0);
        expect(() => playerRepository.deletePlayer(player),
            throwsA(isA<Exception>()));
      });
    });
  });
}
