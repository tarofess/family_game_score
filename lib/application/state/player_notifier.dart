import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/infrastructure/repository/sqlite_player_repository.dart';

class PlayerNotifier extends AsyncNotifier<List<Player>> {
  final SQLitePlayerRepository _playerRepository;

  PlayerNotifier(this._playerRepository);

  @override
  Future<List<Player>> build() async {
    final players = await _playerRepository.getPlayer();
    state = AsyncData(players);
    return players;
  }

  Future<void> addPlayer(String inputText, String image) async {
    final newPlayer = await _playerRepository.addPlayer(inputText, image);
    state = AsyncData([...state.value ?? [], newPlayer]);
  }

  Future<void> getPlayer() async {
    final players = await _playerRepository.getPlayer();
    state = AsyncData(players);
  }

  Future<void> getActivePlayer() async {
    final players = await _playerRepository.getActivePlayer();
    state = AsyncData(players);
  }

  Future<void> updatePlayer(Player player) async {
    await _playerRepository.updatePlayer(player);

    if (state.value != null) {
      state = AsyncData(
          state.value!.map((p) => p.id == player.id ? player : p).toList());
    } else {
      state = const AsyncData([]);
    }
  }

  Future<void> deletePlayer(Player player) async {
    await _playerRepository.deletePlayer(player);

    if (state.value != null) {
      state = AsyncData(state.value!.where((p) => p.id != player.id).toList());
    } else {
      state = const AsyncData([]);
    }
  }

  Future<void> activatePlayer(Player player) async {
    await _playerRepository.activatePlayer(player);

    if (state.value != null) {
      state = AsyncData(
          state.value!.map((p) => p.id == player.id ? player : p).toList());
    } else {
      state = const AsyncData([]);
    }
  }

  Future<void> deactivatePlayer(Player player) async {
    await _playerRepository.deactivatePlayer(player);

    if (state.value != null) {
      state = AsyncData(
          state.value!.map((p) => p.id == player.id ? player : p).toList());
    } else {
      state = const AsyncData([]);
    }
  }

  Future<int> getPlayersMaxID() async {
    return await _playerRepository.getPlayersMaxID();
  }

  void reorderPlayer(int oldIndex, int newIndex) {
    final List<Player> players =
        state.value?.where((player) => player.status == 1).toList() ?? [];
    final playerToMove = players.removeAt(oldIndex);
    players.insert(newIndex, playerToMove);
    state = AsyncData(players);
  }
}

final playerNotifierProvider =
    AsyncNotifierProvider<PlayerNotifier, List<Player>>(() {
  return PlayerNotifier(SQLitePlayerRepository());
});
