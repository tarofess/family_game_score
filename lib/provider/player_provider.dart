import 'package:family_game_score/model/player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

class PlayerNotifier extends AsyncNotifier<List<Player>> {
  late Database _database;

  @override
  Future<List<Player>> build() async {
    state = const AsyncLoading();

    try {
      await openDB();
      final List<Map<String, dynamic>> response =
          await _database.rawQuery('SELECT * FROM Player');
      final players = response.map((map) => Player.fromJson(map)).toList();
      state = AsyncData(players);
      return players;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return [];
    }
  }

  Future<void> openDB() async {
    _database = await openDatabase(
      'family_game_score.db',
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE Player(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)',
        );
        await db.execute(
          'CREATE TABLE Session(id INTEGER PRIMARY KEY AUTOINCREMENT, begTime TEXT, endTime TEXT)',
        );
        await db.execute(
          'CREATE TABLE Result(id INTEGER PRIMARY KEY AUTOINCREMENT, playerId INTEGER, sessionId INTEGER, score INTEGER)',
        );
      },
    );
  }

  Future<void> createPlayer(String inputText) async {
    state = const AsyncLoading();

    try {
      await _database.transaction((txn) async {
        int id = await txn
            .rawInsert('INSERT INTO Player(name) VALUES(?)', [inputText]);
        final player = Player(id: id, name: inputText);
        state = AsyncData([...state.value ?? [], player]);
      });
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> readPlayer() async {
    state = const AsyncLoading();

    try {
      final List<Map<String, dynamic>> mapList =
          await _database.rawQuery('SELECT * FROM Player');
      state = AsyncData(mapList.map((map) => Player.fromJson(map)).toList());
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> updatePlayer(Player player) async {
    state = const AsyncLoading();

    try {
      await _database.rawUpdate(
          'UPDATE Player SET name = ? WHERE id = ?', [player.name, player.id]);
      if (state.value != null) {
        state = AsyncData(
            state.value!.map((p) => p.id == player.id ? player : p).toList());
      } else {
        state = const AsyncData([]);
      }
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> deletePlayer(Player player) async {
    state = const AsyncLoading();
    try {
      await _database.rawDelete('DELETE FROM Player WHERE id = ?', [player.id]);
      if (state.value != null) {
        state =
            AsyncData(state.value!.where((p) => p.id != player.id).toList());
      } else {
        state = const AsyncData([]);
      }
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  void reorderPlayer(int oldIndex, int newIndex) {
    final List<Player> players = state.value ?? [];
    final playerToMove = players.removeAt(oldIndex);
    players.insert(newIndex, playerToMove);
    state = AsyncData(players);
  }
}

final playerProvider = AsyncNotifierProvider<PlayerNotifier, List<Player>>(() {
  return PlayerNotifier();
});
