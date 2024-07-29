import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/session.dart';
import 'package:family_game_score/viewmodel/home_viewmodel.dart';
import 'package:family_game_score/viewmodel/provider/player_provider.dart';
import 'package:family_game_score/viewmodel/provider/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([Ref, BuildContext])
import 'home_viewmodel_test.mocks.dart';

void main() {
  late MockRef mockRef;
  late HomeViewModel viewModel;

  setUpAll(() {
    provideDummy<AsyncValue<List<Player>>>(const AsyncValue.data([]));
    provideDummy<AsyncValue<Session?>>(const AsyncValue.data(null));
  });

  setUp(() {
    mockRef = MockRef();
    viewModel = HomeViewModel(mockRef);

    const mockPlayers = AsyncValue<List<Player>>.data([]);
    const mockSession = AsyncValue<Session?>.data(null);

    when(mockRef.watch(playerProvider)).thenReturn(mockPlayers);
    when(mockRef.watch(sessionProvider)).thenReturn(mockSession);
  });

  group('HomeViewModel', () {
    test('canStartGame returns true when there are 2 or more players', () {
      when(viewModel.players).thenReturn(const AsyncValue.data([
        Player(id: 1, name: 'Player1', status: 0),
        Player(id: 2, name: 'Player2', status: 0)
      ]));
      expect(viewModel.canStartGame(), isTrue);

      when(viewModel.players).thenReturn(const AsyncValue.data([
        Player(id: 1, name: 'Player1', status: 0),
        Player(id: 2, name: 'Player2', status: 0),
        Player(id: 3, name: 'Player3', status: 0)
      ]));
      expect(viewModel.canStartGame(), isTrue);
    });

    test('canStartGame returns false when there are less than 2 players', () {
      when(viewModel.players).thenReturn(const AsyncValue.data([]));
      expect(viewModel.canStartGame(), isFalse);

      when(viewModel.players).thenReturn(
          const AsyncValue.data([Player(id: 1, name: 'Player1', status: 0)]));
      expect(viewModel.canStartGame(), isFalse);
    });

    test('getButtonText returns correct text based on session state', () {
      when(viewModel.session).thenReturn(const AsyncValue.data(null));
      expect(viewModel.getButtonText(), equals('ゲームスタート！'));

      when(viewModel.session).thenReturn(const AsyncValue.data(Session(
          id: 1, round: 1, begTime: '2023-07-22 10:00:00', endTime: null)));
      expect(viewModel.getButtonText(), equals('ゲーム再開！'));
    });

    test('getGradientColors returns correct colors based on player count', () {
      const enabledColors = [
        Color.fromARGB(255, 255, 194, 102),
        Color.fromARGB(255, 255, 101, 90)
      ];
      const disabledColors = [
        Color.fromARGB(255, 223, 223, 223),
        Color.fromARGB(255, 109, 109, 109)
      ];

      when(viewModel.players).thenReturn(const AsyncValue.data([
        Player(id: 1, name: 'Player1', status: 0),
        Player(id: 2, name: 'Player2', status: 0)
      ]));
      expect(viewModel.getGradientColors(), equals(enabledColors));

      when(viewModel.players).thenReturn(
          const AsyncValue.data([Player(id: 1, name: 'Player1', status: 0)]));
      expect(viewModel.getGradientColors(), equals(disabledColors));
    });

    test('handleButtonPress calls onStartGame when canStartGame is true', () {
      when(viewModel.players).thenReturn(const AsyncValue.data([
        Player(id: 1, name: 'Player1', status: 0),
        Player(id: 2, name: 'Player2', status: 0)
      ]));

      bool onStartGameCalled = false;
      bool onShowSnackbarCalled = false;

      final callback = viewModel.handleButtonPress(
        onStartGame: () => onStartGameCalled = true,
        onShowSnackbar: () => onShowSnackbarCalled = true,
      );

      callback();

      expect(onStartGameCalled, isTrue);
      expect(onShowSnackbarCalled, isFalse);
    });

    test('handleButtonPress calls onShowSnackbar when canStartGame is false',
        () {
      when(viewModel.players).thenReturn(
          const AsyncValue.data([Player(id: 1, name: 'Player1', status: 0)]));

      bool onStartGameCalled = false;
      bool onShowSnackbarCalled = false;

      final callback = viewModel.handleButtonPress(
        onStartGame: () => onStartGameCalled = true,
        onShowSnackbar: () => onShowSnackbarCalled = true,
      );

      callback();

      expect(onStartGameCalled, isFalse);
      expect(onShowSnackbarCalled, isTrue);
    });
  });
}
