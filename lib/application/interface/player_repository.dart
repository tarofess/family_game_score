import 'package:family_game_score/domain/entity/player.dart';

abstract class PlayerRepository {
  Future<Player> addPlayer(String name, String image);
  Future<List<Player>> getPlayer();
  Future<List<Player>> getActivePlayer();
  Future<void> updatePlayer(Player player);
  Future<void> deletePlayer(Player player);
  Future<void> deactivatePlayer(Player player);
  Future<void> activatePlayer(Player player);
  Future<int> getPlayersMaxID();
}
