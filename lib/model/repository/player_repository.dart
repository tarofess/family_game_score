import 'package:family_game_score/model/entity/player.dart';
import 'package:sqflite/sqflite.dart';

class PlayerRepository {
  Database database;

  PlayerRepository(this.database);

  Future<Player> addPlayer(String name, String image) async {
    int id = await database.rawInsert(
        'INSERT INTO Player(name, image, status) VALUES(?, ?, 0)',
        [name, image]);
    final newPlayer = Player(id: id, name: name, image: image);
    return newPlayer;
  }

  Future<List<Player>> getPlayer() async {
    final List<Map<String, dynamic>> response =
        await database.rawQuery('SELECT * FROM Player WHERE status = 0');
    final players = response.map((map) => Player.fromJson(map)).toList();
    return players;
  }

  Future<void> updatePlayer(Player player) async {
    await database.rawUpdate(
        'UPDATE Player SET name = ?, image = ? WHERE id = ?',
        [player.name, player.image, player.id]);
  }

  Future<void> deletePlayer(Player player) async {
    await database
        .rawUpdate('UPDATE Player SET status = -1 WHERE id = ?', [player.id]);
  }
}
