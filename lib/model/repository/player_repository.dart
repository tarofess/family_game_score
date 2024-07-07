import 'package:family_game_score/model/entity/player.dart';
import 'package:sqflite/sqflite.dart';

class PlayerRepository {
  Future<Database> openDB() async {
    return await openDatabase(
      'family_game_score.db',
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE Player(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, status INTEGER)',
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

  Future<Player> addPlayer(String inputText) async {
    Database? database;

    try {
      database = await openDB();

      int id = await database.rawInsert(
          'INSERT INTO Player(name, status) VALUES(?, 0)', [inputText]);
      final newPlayer = Player(id: id, name: inputText, status: 0);

      return newPlayer;
    } catch (e) {
      rethrow;
    } finally {
      database?.close();
    }
  }

  Future<List<Player>> getPlayer() async {
    Database? database;

    try {
      database = await openDB();

      final List<Map<String, dynamic>> response =
          await database.rawQuery('SELECT * FROM Player WHERE status = 0');
      final players = response.map((map) => Player.fromJson(map)).toList();

      return players;
    } catch (e) {
      rethrow;
    } finally {
      database?.close();
    }
  }

  Future<void> updatePlayer(Player player) async {
    Database? database;

    try {
      database = await openDB();

      await database.rawUpdate(
          'UPDATE Player SET name = ? WHERE id = ?', [player.name, player.id]);
    } catch (e) {
      rethrow;
    } finally {
      database?.close();
    }
  }

  Future<void> deletePlayer(Player player) async {
    Database? database;

    try {
      database = await openDB();

      await database
          .rawUpdate('UPDATE Player SET status = -1 WHERE id = ?', [player.id]);
    } catch (e) {
      rethrow;
    } finally {
      database?.close();
    }
  }
}
