import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/result.dart';
import 'package:family_game_score/model/entity/session.dart';
import 'package:family_game_score/viewmodel/provider/result_provider.dart';
import 'package:family_game_score/viewmodel/provider/session_provider.dart';
import 'package:family_game_score/viewmodel/scoring_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([Ref])
import 'scoring_viewmodel_test.mocks.dart';

void main() {
  late ScoringViewModel viewModel;
  late MockRef mockRef;

  setUp(() {
    mockRef = MockRef();
    viewModel = ScoringViewModel(mockRef);

    provideDummy<AsyncValue<Session?>>(const AsyncValue.data(null));
    provideDummy<AsyncValue<List<Result>>>(const AsyncValue.data([]));
    provideDummy<AsyncValue<List<Player>>>(const AsyncValue.data([]));
  });

  group('ScoringViewModel Tests', () {
    test('getAppBarTitle returns correct title', () {
      when(mockRef.watch(sessionProvider)).thenReturn(const AsyncValue.data(
          Session(id: 1, round: 2, begTime: '2023-07-22T10:00:00')));
      final title = viewModel.getAppBarTitle();
      expect((title as Text).data, '2回戦');
    });

    test('getExitButtonCallback returns callback when conditions are met', () {
      when(mockRef.watch(resultProvider)).thenReturn(const AsyncValue.data(
          [Result(id: 1, playerId: 1, sessionId: 1, score: 100, rank: 1)]));
      when(mockRef.watch(sessionProvider)).thenReturn(const AsyncValue.data(
          Session(id: 1, round: 1, begTime: '2023-07-22T10:00:00')));
      bool callbackCalled = false;
      final callback = viewModel.getExitButtonCallback(() {
        callbackCalled = true;
      });
      expect(callback, isNotNull);
      callback!();
      expect(callbackCalled, isTrue);
    });

    test('getCheckButtonCallback returns callback when results are available',
        () {
      when(mockRef.watch(resultProvider)).thenReturn(const AsyncValue.data(
          [Result(id: 1, playerId: 1, sessionId: 1, score: 100, rank: 1)]));
      bool callbackCalled = false;
      final callback = viewModel.getCheckButtonCallback(() {
        callbackCalled = true;
      });
      expect(callback, isNotNull);
      callback!();
      expect(callbackCalled, isTrue);
    });

    test(
        'getFloatingActionButtonCallback returns callback when session is available',
        () {
      when(mockRef.watch(sessionProvider)).thenReturn(const AsyncValue.data(
          Session(id: 1, round: 1, begTime: '2023-07-22T10:00:00')));
      bool callbackCalled = false;
      final callback = viewModel.getFloatingActionButtonCallback(() {
        callbackCalled = true;
      });
      expect(callback, isNotNull);
      callback!();
      expect(callbackCalled, isTrue);
    });

    test('getFloatingActionButtonColor returns null when session is available',
        () {
      when(mockRef.watch(sessionProvider)).thenReturn(const AsyncValue.data(
          Session(id: 1, round: 1, begTime: '2023-07-22T10:00:00')));
      final color = viewModel.getFloatingActionButtonColor();
      expect(color, isNull);
    });

    test('getFloatingActionButtonColor returns grey when session is null', () {
      when(mockRef.watch(sessionProvider))
          .thenReturn(const AsyncValue.data(null));
      final color = viewModel.getFloatingActionButtonColor();
      expect(color, Colors.grey[300]);
    });
  });
}
