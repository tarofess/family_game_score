import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/result.dart';
import 'package:family_game_score/model/entity/session.dart';
import 'package:family_game_score/service/dialog_service.dart';
import 'package:family_game_score/service/navigation_service.dart';
import 'package:family_game_score/viewmodel/provider/result_provider.dart';
import 'package:family_game_score/viewmodel/provider/session_provider.dart';
import 'package:family_game_score/viewmodel/scoring_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([Ref, DialogService, NavigationService, WidgetRef])
import 'setting_viewmodel_test.mocks.dart';

void main() {
  late ScoringViewModel viewModel;
  late MockRef mockRef;
  late MockDialogService mockDialogService;
  late MockNavigationService mockNavigationService;
  late MockWidgetRef mockWidgetRef;

  setUp(() {
    mockRef = MockRef();
    mockDialogService = MockDialogService();
    mockNavigationService = MockNavigationService();
    mockWidgetRef = MockWidgetRef();
    viewModel =
        ScoringViewModel(mockRef, mockDialogService, mockNavigationService);

    provideDummy<AsyncValue<Session?>>(const AsyncValue.data(null));
    provideDummy<AsyncValue<List<Result>>>(const AsyncValue.data([]));
    provideDummy<AsyncValue<List<Player>>>(const AsyncValue.data([]));
  });

  group('ScoringViewModel Tests', () {
    test('getAppBarTitle returns correct title', () {
      when(mockRef.watch(sessionProvider)).thenReturn(const AsyncValue.data(
          Session(id: 1, round: 2, begTime: '2023-07-22T10:00:00')));
      final title = viewModel.getAppBarTitle(MockBuildContext());
      expect((title as Text).data, '2回戦');
    });

    test('getExitButtonCallback returns callback when conditions are met', () {
      when(mockRef.watch(resultProvider)).thenReturn(const AsyncValue.data(
          [Result(id: 1, playerId: 1, sessionId: 1, score: 100, rank: 1)]));
      when(mockRef.watch(sessionProvider)).thenReturn(const AsyncValue.data(
          Session(id: 1, round: 1, begTime: '2023-07-22T10:00:00')));
      final callback =
          viewModel.getExitButtonCallback(MockBuildContext(), mockWidgetRef);
      expect(callback, isNotNull);
    });

    test('getCheckButtonCallback returns callback when results are available',
        () {
      when(mockRef.watch(resultProvider)).thenReturn(const AsyncValue.data(
          [Result(id: 1, playerId: 1, sessionId: 1, score: 100, rank: 1)]));
      final callback =
          viewModel.getCheckButtonCallback(MockBuildContext(), mockWidgetRef);
      expect(callback, isNotNull);
    });

    test(
        'getFloatingActionButtonCallback returns callback when session is available',
        () {
      when(mockRef.watch(sessionProvider)).thenReturn(const AsyncValue.data(
          Session(id: 1, round: 1, begTime: '2023-07-22T10:00:00')));
      final callback = viewModel.getFloatingActionButtonCallback(
          MockBuildContext(), mockWidgetRef);
      expect(callback, isNotNull);
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

class MockBuildContext extends Mock implements BuildContext {}
