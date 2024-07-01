import "package:family_game_score/model/player.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:sqflite/sqflite.dart';

class PlayerNotifier extends AsyncNotifier<List<Player>> {
  late Database _database;

  @override
  Future<List<Player>> build() async {
    state = const AsyncLoading();

    try {
      _database = await openDatabase(
        'family_game_score.db',
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(
            'CREATE TABLE Players(ID INTEGER PRIMARY KEY AUTOINCREMENT, Name TEXT)',
          );
        },
      );
      final List<Map<String, dynamic>> response =
          await _database.rawQuery('SELECT * FROM Players');
      return response.map((map) => Player.fromJson(map)).toList();
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return [];
    }
  }

  Future<void> createPlayer(Player player) async {
    state = const AsyncLoading();

    try {
      await _database.transaction((txn) async {
        await txn.rawInsert(
            'INSERT INTO Players(Name, TotalScore) VALUES(?, 0)',
            [player.name]);
      });
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }

    state = state.whenData((players) => [...players, player]);
  }

  Future<void> readPlayer() async {
    state = const AsyncLoading();

    try {
      final List<Map<String, dynamic>> mapList =
          await _database.rawQuery('SELECT * FROM Players');
      state = AsyncData(mapList.map((map) => Player.fromJson(map)).toList());
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> updatePlayers(Player player) async {
    state = const AsyncLoading();

    try {
      await _database.rawUpdate(
          'UPDATE Players SET Name = ? WHERE ID = ?', [player.name, player.id]);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> deletePlayers(Player player) async {
    state = const AsyncLoading();
    try {
      await _database
          .rawDelete('DELETE FROM Players WHERE ID = ?', [player.id]);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

final playerProvider = AsyncNotifierProvider<PlayerNotifier, List<Player>>(() {
  return PlayerNotifier();
});
