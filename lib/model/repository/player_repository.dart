import 'package:family_game_score/model/entity/player.dart';
import 'package:sqflite/sqflite.dart';

class PlayerRepository {
  Database database;

  PlayerRepository(this.database);

  Future<Player> addPlayer(String name, String image) async {
    try {
      int id = await database.rawInsert(
          'INSERT INTO Player(name, image, status) VALUES(?, ?, 1)',
          [name, image]);
      final newPlayer = Player(id: id, name: name, image: image);
      return newPlayer;
    } catch (e) {
      throw Exception('プレイヤーの追加中にエラーが発生しました。');
    }
  }

  Future<List<Player>> getPlayer() async {
    try {
      final List<Map<String, dynamic>> response =
          await database.rawQuery('SELECT * FROM Player WHERE status >= 0');
      final players = response.map((map) => Player.fromJson(map)).toList();
      return players;
    } catch (e) {
      throw Exception('プレイヤーの取得中にエラーが発生しました。');
    }
  }

  Future<List<Player>> getActivePlayer() async {
    try {
      final List<Map<String, dynamic>> response =
          await database.rawQuery('SELECT * FROM Player WHERE status = 1');
      final players = response.map((map) => Player.fromJson(map)).toList();
      return players;
    } catch (e) {
      throw Exception('有効なプレイヤーの取得中にエラーが発生しました。');
    }
  }

  Future<void> updatePlayer(Player player) async {
    try {
      await database.rawUpdate(
          'UPDATE Player SET name = ?, image = ? WHERE id = ?',
          [player.name, player.image, player.id]);
    } catch (e) {
      throw Exception('プレイヤーの更新中にエラーが発生しました。');
    }
  }

  Future<void> deletePlayer(Player player) async {
    try {
      await database
          .rawUpdate('UPDATE Player SET status = -1 WHERE id = ?', [player.id]);
    } catch (e) {
      throw Exception('プレイヤーの削除中にエラーが発生しました。');
    }
  }

  Future<void> deactivatePlayer(Player player) async {
    try {
      await database
          .rawUpdate('UPDATE Player SET status = 0 WHERE id = ?', [player.id]);
    } catch (e) {
      throw Exception('プレイヤーの無効化中にエラーが発生しました。');
    }
  }

  Future<void> activatePlayer(Player player) async {
    try {
      await database
          .rawUpdate('UPDATE Player SET status = 1 WHERE id = ?', [player.id]);
    } catch (e) {
      throw Exception('プレイヤーの有効化中にエラーが発生しました。');
    }
  }

  Future<int> getPlayersMaxID() async {
    try {
      final List<Map<String, dynamic>> response =
          await database.rawQuery('SELECT MAX(id) as max_id FROM Player');
      return response.first['max_id'] ?? 0;
    } catch (e) {
      throw Exception('画像名の更新中にエラーが発生しました。');
    }
  }
}
