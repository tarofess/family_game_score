import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/session.dart';
import 'package:family_game_score/viewmodel/provider/player_provider.dart';
import 'package:family_game_score/viewmodel/provider/session_provider.dart';
import 'package:family_game_score/viewmodel/setting_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([Ref, WidgetRef])
import 'setting_viewmodel_test.mocks.dart';

void main() {
  late SettingViewModel viewModel;
  late MockRef mockRef;
  late MockWidgetRef mockWidgetRef;

  setUp(() {
    mockRef = MockRef();
    mockWidgetRef = MockWidgetRef();
    viewModel = SettingViewModel(mockRef);

    provideDummy<AsyncValue<Session?>>(const AsyncValue.data(null));
    provideDummy<AsyncValue<List<Player>>>(const AsyncValue.data([]));
  });

  group('SettingViewModel Tests', () {
    test(
        'getFloatingActionButtonCallback returns callback when conditions are met',
        () {
      when(mockRef.watch(playerProvider)).thenReturn(const AsyncValue.data(
          [Player(id: 1, name: 'Test Player', status: 0)]));
      when(mockRef.watch(sessionProvider))
          .thenReturn(const AsyncValue.data(null));

      bool callbackCalled = false;
      final callback =
          viewModel.getFloatingActionButtonCallback(mockWidgetRef, () {
        callbackCalled = true;
      });

      expect(callback, isNotNull);
      callback!();
      expect(callbackCalled, isTrue);
    });

    test(
        'getFloatingActionButtonCallback returns null when session is not null',
        () {
      when(mockRef.watch(playerProvider)).thenReturn(const AsyncValue.data(
          [Player(id: 1, name: 'Test Player', status: 0)]));
      when(mockRef.watch(sessionProvider)).thenReturn(const AsyncValue.data(
          Session(id: 1, round: 1, begTime: '2023-07-22T10:00:00')));

      final callback =
          viewModel.getFloatingActionButtonCallback(mockWidgetRef, () {});
      expect(callback, isNull);
    });

    test('getFloatingActionButtonColor returns null when conditions are met',
        () {
      when(mockRef.watch(playerProvider)).thenReturn(const AsyncValue.data(
          [Player(id: 1, name: 'Test Player', status: 0)]));
      when(mockRef.watch(sessionProvider))
          .thenReturn(const AsyncValue.data(null));

      final color = viewModel.getFloatingActionButtonColor();
      expect(color, isNull);
    });

    test(
        'getFloatingActionButtonColor returns grey when conditions are not met',
        () {
      when(mockRef.watch(playerProvider)).thenReturn(const AsyncValue.data([]));
      when(mockRef.watch(sessionProvider)).thenReturn(const AsyncValue.data(
          Session(id: 1, round: 1, begTime: '2023-07-22T10:00:00')));

      final color = viewModel.getFloatingActionButtonColor();
      expect(color, Colors.grey[300]);
    });
  });
}
