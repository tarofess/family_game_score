import 'package:family_game_score/model/entity/player.dart';
import 'package:sqflite/sqflite.dart';

class PlayerRepository {
  Database database;

  PlayerRepository(this.database);

  Future<Player> addPlayer(String inputText) async {
    try {
      int id = await database.rawInsert(
          'INSERT INTO Player(name, status) VALUES(?, 0)', [inputText]);
      final newPlayer = Player(id: id, name: inputText, status: 0);
      return newPlayer;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Player>> getPlayer() async {
    try {
      final List<Map<String, dynamic>> response =
          await database.rawQuery('SELECT * FROM Player WHERE status = 0');
      final players = response.map((map) => Player.fromJson(map)).toList();
      return players;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updatePlayer(Player player) async {
    try {
      await database.rawUpdate(
          'UPDATE Player SET name = ? WHERE id = ?', [player.name, player.id]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePlayer(Player player) async {
    try {
      await database
          .rawUpdate('UPDATE Player SET status = -1 WHERE id = ?', [player.id]);
    } catch (e) {
      rethrow;
    }
  }
}
