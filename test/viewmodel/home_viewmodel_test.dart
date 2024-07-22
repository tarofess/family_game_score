import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/session.dart';
import 'package:family_game_score/service/navigation_service.dart';
import 'package:family_game_score/service/snackbar_service.dart';
import 'package:family_game_score/view/scoring_view.dart';
import 'package:family_game_score/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([Ref, NavigationService, SnackbarService, BuildContext])
import 'home_viewmodel_test.mocks.dart';

void main() {
  late MockRef mockRef;
  late MockNavigationService mockNavigationService;
  late MockSnackbarService mockSnackbarService;
  late HomeViewModel viewModel;
  late MockBuildContext mockContext;

  setUp(() {
    mockRef = MockRef();
    mockNavigationService = MockNavigationService();
    mockSnackbarService = MockSnackbarService();
    mockContext = MockBuildContext();
    viewModel =
        HomeViewModel(mockRef, mockNavigationService, mockSnackbarService);
  });

  group('HomeViewModel', () {
    test('canStartGame returns true when there are 2 or more players', () {
      expect(
          viewModel.canStartGame([
            const Player(id: 1, name: 'Player1', status: 0),
            const Player(id: 2, name: 'Player2', status: 0)
          ]),
          isTrue);
      expect(
          viewModel.canStartGame([
            const Player(id: 1, name: 'Player1', status: 0),
            const Player(id: 2, name: 'Player2', status: 0),
            const Player(id: 3, name: 'Player3', status: 0)
          ]),
          isTrue);
    });

    test('canStartGame returns false when there are less than 2 players', () {
      expect(viewModel.canStartGame([]), isFalse);
      expect(
          viewModel
              .canStartGame([const Player(id: 1, name: 'Player1', status: 0)]),
          isFalse);
    });

    test('getButtonText returns correct text based on session state', () {
      expect(viewModel.getButtonText(null, mockContext), equals('ゲームスタート！'));
      expect(
          viewModel.getButtonText(
              const Session(
                  id: 1,
                  round: 1,
                  begTime: '2023-07-22 10:00:00',
                  endTime: null),
              mockContext),
          equals('ゲーム再開！'));
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

      expect(
          viewModel.getGradientColors([
            const Player(id: 1, name: 'Player1', status: 0),
            const Player(id: 2, name: 'Player2', status: 0)
          ]),
          equals(enabledColors));
      expect(
          viewModel.getGradientColors(
              [const Player(id: 1, name: 'Player1', status: 0)]),
          equals(disabledColors));
    });

    test('handleButtonPress navigates to ScoringView when canStartGame is true',
        () {
      final players = [
        const Player(id: 1, name: 'Player1', status: 0),
        const Player(id: 2, name: 'Player2', status: 0)
      ];
      viewModel.handleButtonPress(mockContext, players);
      verify(mockNavigationService.pushReplacementWithAnimationFromBottom(
        mockContext,
        argThat(isA<ScoringView>()),
      )).called(1);
      verifyNever(mockSnackbarService.showHomeViewSnackBar(mockContext));
    });

    test('handleButtonPress shows snackbar when canStartGame is false', () {
      final players = [const Player(id: 1, name: 'Player1', status: 0)];
      viewModel.handleButtonPress(mockContext, players);
      verifyNever(mockNavigationService.pushReplacementWithAnimationFromBottom(
          mockContext, const ScoringView()));
      verify(mockSnackbarService.showHomeViewSnackBar(mockContext)).called(1);
    });
  });

  group('SessionExtension', () {
    test('getFormatBegTime returns correctly formatted date string', () {
      const dateString = '2023-07-22 10:00:00';
      expect(dateString.getFormatBegTime(), equals('2023-07-22 10:00'));
    });
  });
}
