import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/repository/database_helper.dart';
import 'package:family_game_score/model/repository/player_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqflite/sqflite.dart';

class PlayerNotifier extends AsyncNotifier<List<Player>> {
  late PlayerRepository playerRepository;
  Database database;

  PlayerNotifier(this.database);

  @override
  Future<List<Player>> build() async {
    playerRepository = PlayerRepository(database);
    final players = await playerRepository.getPlayer();
    state = AsyncData(players);
    return players;
  }

  Future<void> addPlayer(String inputText, String image) async {
    final newPlayer = await playerRepository.addPlayer(inputText, image);
    state = AsyncData([...state.value ?? [], newPlayer]);
  }

  Future<void> getPlayer() async {
    final players = await playerRepository.getPlayer();
    state = AsyncData(players);
  }

  Future<void> getActivePlayer() async {
    final players = await playerRepository.getActivePlayer();
    state = AsyncData(players);
  }

  Future<void> updatePlayer(Player player) async {
    await playerRepository.updatePlayer(player);

    if (state.value != null) {
      state = AsyncData(
          state.value!.map((p) => p.id == player.id ? player : p).toList());
    } else {
      state = const AsyncData([]);
    }
  }

  Future<void> deletePlayer(Player player) async {
    await playerRepository.deletePlayer(player);

    if (state.value != null) {
      state = AsyncData(state.value!.where((p) => p.id != player.id).toList());
    } else {
      state = const AsyncData([]);
    }
  }

  Future<void> activatePlayer(Player player) async {
    await playerRepository.activatePlayer(player);

    if (state.value != null) {
      state = AsyncData(
          state.value!.map((p) => p.id == player.id ? player : p).toList());
    } else {
      state = const AsyncData([]);
    }
  }

  Future<void> deactivatePlayer(Player player) async {
    await playerRepository.deactivatePlayer(player);

    if (state.value != null) {
      state = AsyncData(
          state.value!.map((p) => p.id == player.id ? player : p).toList());
    } else {
      state = const AsyncData([]);
    }
  }

  Future<int> getPlayersMaxID() async {
    return await playerRepository.getPlayersMaxID();
  }

  void reorderPlayer(int oldIndex, int newIndex) {
    final List<Player> players =
        state.value?.where((player) => player.status == 1).toList() ?? [];
    final playerToMove = players.removeAt(oldIndex);
    players.insert(newIndex, playerToMove);
    state = AsyncData(players);
  }
}

final playerProvider = AsyncNotifierProvider<PlayerNotifier, List<Player>>(() {
  return PlayerNotifier(DatabaseHelper.instance.database);
});
