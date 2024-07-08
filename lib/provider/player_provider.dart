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
    state = await AsyncValue.guard(() async {
      final playerRepository = PlayerRepository();
      final newPlayer = await playerRepository.addPlayer(inputText);
      return [...state.value ?? [], newPlayer];
    });
  }

  Future<void> getPlayer() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final playerRepository = PlayerRepository();
      final players = await playerRepository.getPlayer();
      return players;
    });
  }

  Future<void> updatePlayer(Player player) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final playerRepository = PlayerRepository();
      await playerRepository.updatePlayer(player);

      if (state.value != null) {
        return state.value!.map((p) => p.id == player.id ? player : p).toList();
      } else {
        return [];
      }
    });
  }

  Future<void> deletePlayer(Player player) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final playerRepository = PlayerRepository();
      await playerRepository.deletePlayer(player);

      if (state.value != null) {
        return state.value!.map((p) => p.id == player.id ? player : p).toList();
      } else {
        return [];
      }
    });
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
