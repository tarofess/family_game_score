import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/repository/player_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayerNotifier extends AsyncNotifier<List<Player>> {
  @override
  Future<List<Player>> build() async {
    try {
      final playerRepository = PlayerRepository();
      final players = await playerRepository.getPlayer();
      state = AsyncData(players);
      return players;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> addPlayer(String inputText) async {
    state = const AsyncLoading();

    try {
      final playerRepository = PlayerRepository();
      final newPlayer = await playerRepository.addPlayer(inputText);
      state = AsyncData([...state.value ?? [], newPlayer]);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> getPlayer() async {
    state = const AsyncLoading();

    try {
      final playerRepository = PlayerRepository();
      final players = await playerRepository.getPlayer();
      state = AsyncData(players);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> updatePlayer(Player player) async {
    state = const AsyncLoading();

    try {
      final playerRepository = PlayerRepository();
      playerRepository.updatePlayer(player);

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
      final playerRepository = PlayerRepository();
      playerRepository.deletePlayer(player);

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
}

final playerProvider = AsyncNotifierProvider<PlayerNotifier, List<Player>>(() {
  return PlayerNotifier();
});
