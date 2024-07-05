import 'package:family_game_score/model/player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

class PlayerNotifier extends AsyncNotifier<List<Player>> {
  @override
  Future<List<Player>> build() async {
    try {
      final players = await getAllPlayersFromDB();
      state = AsyncData(players);

      return players;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<Database> openDB() async {
    return await openDatabase(
      'family_game_score.db',
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE Player(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)',
        );
        await db.execute(
          'CREATE TABLE Session(id INTEGER PRIMARY KEY AUTOINCREMENT, round INTEGER, begTime TEXT, endTime TEXT)',
        );
        await db.execute(
          'CREATE TABLE Result(id INTEGER PRIMARY KEY AUTOINCREMENT, playerId INTEGER, sessionId INTEGER, score INTEGER, rank INTEGER)',
        );
      },
    );
  }

  Future<void> createPlayer(String inputText) async {
    Database? database;

    state = const AsyncLoading();

    try {
      database = await openDB();

      int id = await database
          .rawInsert('INSERT INTO Player(name) VALUES(?)', [inputText]);
      final player = Player(id: id, name: inputText);
      state = AsyncData([...state.value ?? [], player]);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    } finally {
      database?.close();
    }
  }

  Future<void> readPlayer() async {
    Database? database;
    state = const AsyncLoading();

    try {
      database = await openDB();

      final players = await getAllPlayersFromDB();
      state = AsyncData(players);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    } finally {
      database?.close();
    }
  }

  Future<void> updatePlayer(Player player) async {
    Database? database;
    state = const AsyncLoading();

    try {
      database = await openDB();

      await database.rawUpdate(
          'UPDATE Player SET name = ? WHERE id = ?', [player.name, player.id]);

      if (state.value != null) {
        state = AsyncData(
            state.value!.map((p) => p.id == player.id ? player : p).toList());
      } else {
        state = const AsyncData([]);
      }
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    } finally {
      database?.close();
    }
  }

  Future<void> deletePlayer(Player player) async {
    Database? database;
    state = const AsyncLoading();

    try {
      database = await openDB();

      await database.rawDelete('DELETE FROM Player WHERE id = ?', [player.id]);

      if (state.value != null) {
        state =
            AsyncData(state.value!.where((p) => p.id != player.id).toList());
      } else {
        state = const AsyncData([]);
      }
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    } finally {
      database?.close();
    }
  }

  void reorderPlayer(int oldIndex, int newIndex) {
    final List<Player> players = state.value ?? [];
    final playerToMove = players.removeAt(oldIndex);
    players.insert(newIndex, playerToMove);
    state = AsyncData(players);
  }

  void resetOrder() {
    final List<Player> players = state.value ?? [];
    players.sort((a, b) => a.id.compareTo(b.id));
    state = AsyncData(players);
  }

  Future<List<Player>> getAllPlayersFromDB() async {
    Database? database;

    try {
      database = await openDB();

      final List<Map<String, dynamic>> response =
          await database.rawQuery('SELECT * FROM Player');
      final players = response.map((map) => Player.fromJson(map)).toList();

      return players;
    } catch (e) {
      rethrow;
    } finally {
      database?.close();
    }
  }
}

final playerProvider = AsyncNotifierProvider<PlayerNotifier, List<Player>>(() {
  return PlayerNotifier();
});
