import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/result.dart';
import 'package:family_game_score/model/entity/session.dart';
import 'package:family_game_score/viewmodel/provider/player_provider.dart';
import 'package:family_game_score/viewmodel/provider/result_provider.dart';
import 'package:family_game_score/viewmodel/provider/session_provider.dart';
import 'package:family_game_score/viewmodel/ranking_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([Ref])
import 'ranking_viewmodel_test.mocks.dart';

void main() {
  late MockRef mockRef;
  late RankingViewModel viewModel;

  setUpAll(() {
    provideDummy<AsyncValue<List<Result>>>(const AsyncValue.data([]));
    provideDummy<AsyncValue<List<Player>>>(const AsyncValue.data([]));
    provideDummy<AsyncValue<Session?>>(const AsyncValue.data(null));
  });

  setUp(() {
    mockRef = MockRef();

    // AsyncValue インスタンスを使用
    const mockResults = AsyncValue<List<Result>>.data([]);
    const mockPlayers = AsyncValue<List<Player>>.data([]);
    const mockSession = AsyncValue<Session?>.data(null);

    when(mockRef.watch(resultProvider)).thenReturn(mockResults);
    when(mockRef.watch(playerProvider)).thenReturn(mockPlayers);
    when(mockRef.watch(sessionProvider)).thenReturn(mockSession);

    viewModel = RankingViewModel(mockRef);
  });

  group('RankingViewModel', () {
    test('results should return the value from resultProvider', () {
      expect(viewModel.results, isA<AsyncValue<List<Result>>>());
    });

    test('players should return the value from playerProvider', () {
      expect(viewModel.players, isA<AsyncValue<List<Player>>>());
    });

    test('session should return the value from sessionProvider', () {
      expect(viewModel.session, isA<AsyncValue<Session?>>());
    });

    group('getAppBarTitle', () {
      test('should return "結果発表" when session is null', () {
        when(mockRef.watch(sessionProvider))
            .thenReturn(const AsyncValue<Session?>.data(null));
        final result = viewModel.getAppBarTitle();
        expect(result.runtimeType, Text);
        expect((result as Text).data, '結果発表');
      });

      test('should return "現在の順位" when session is not null', () {
        when(mockRef.watch(sessionProvider)).thenReturn(
            const AsyncValue<Session?>.data(
                Session(id: 1, round: 1, begTime: '2023-07-22 10:00:00')));
        final result = viewModel.getAppBarTitle();
        expect(result.runtimeType, Text);
        expect((result as Text).data, '現在の順位');
      });
    });

    group('getIconButton', () {
      test('should return IconButton when session is null', () {
        when(mockRef.watch(sessionProvider))
            .thenReturn(const AsyncValue<Session?>.data(null));
        final result = viewModel.getIconButton(() {});
        expect(result.runtimeType, IconButton);
      });

      test('should return SizedBox when session is not null', () {
        when(mockRef.watch(sessionProvider)).thenReturn(
            const AsyncValue<Session?>.data(
                Session(id: 1, round: 1, begTime: '2023-07-22 10:00:00')));
        final result = viewModel.getIconButton(() {});
        expect(result.runtimeType, SizedBox);
      });

      test('should call onIconButtonPressed when IconButton is pressed', () {
        when(mockRef.watch(sessionProvider))
            .thenReturn(const AsyncValue<Session?>.data(null));
        var called = false;
        final iconButton = viewModel.getIconButton(() {
          called = true;
        }) as IconButton;

        iconButton.onPressed!();

        expect(called, true);
      });
    });
  });
}
