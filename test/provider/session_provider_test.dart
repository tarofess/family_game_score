import 'package:family_game_score/model/entity/session.dart';
import 'package:family_game_score/model/repository/session_repository.dart';
import 'package:family_game_score/provider/session_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

import 'session_provider_test.mocks.dart';

@GenerateMocks([Database])
void main() {
  late ProviderContainer container;
  late MockDatabase mockDatabase;
  late SessionRepository sessionRepository;

  setUp(() {
    mockDatabase = MockDatabase();
    sessionRepository = SessionRepository(mockDatabase);

    container = ProviderContainer(
      overrides: [
        sessionProvider.overrideWith(() {
          final notifier = SessionNotifier(mockDatabase);
          notifier.sessionRepository = sessionRepository;
          return notifier;
        }),
      ],
    );
  });
  group('Testing SessionProvider', () {
    test('Initial state is loading', () {
      expect(container.read(sessionProvider),
          const AsyncValue<Session?>.loading());
    });

    test('Build', () async {
      when(mockDatabase.rawQuery(any, any)).thenAnswer((_) async => [
            {
              'id': 1,
              'round': 1,
              'begTime': '2021-09-01 00:00:00',
              'endTime': null
            }
          ]);
      await container.read(sessionProvider.future);

      expect(
          container.read(sessionProvider),
          isA<AsyncData<Session?>>()
              .having((d) => d.value!.id, 'session id', 1));
    });
    test('Add Session', () async {
      when(mockDatabase.rawQuery('SELECT MAX(id) as maxId FROM Session'))
          .thenAnswer((_) async => [
                {'maxId': 99},
              ]);
      when(mockDatabase.rawInsert(any, any)).thenAnswer((_) async => 1);
      await container.read(sessionProvider.notifier).addSession();
      final addedSession = container.read(sessionProvider).value!;

      verify(mockDatabase.rawInsert(
          'INSERT INTO Session(id, round, begTime) VALUES(?, ?, ?)',
          [100, 1, addedSession.begTime])).called(1);
    });

    test('Get Session', () async {
      when(mockDatabase.rawQuery(any, any)).thenAnswer((_) async => [
            {
              'id': 1,
              'round': 1,
              'begTime': '2021-09-01 00:00:00',
              'endTime': null
            }
          ]);
      await container.read(sessionProvider.notifier).getSession();
      final session = container.read(sessionProvider).value!;

      expect(session.id, 1);
    });

    test('Update Round', () async {
      when(mockDatabase.rawUpdate(any, any)).thenAnswer((_) async => 1);
      when(mockDatabase.rawQuery(any, any)).thenAnswer((_) async => [
            {
              'id': 1,
              'round': 1,
              'begTime': '2021-09-01 00:00:00',
              'endTime': null
            }
          ]);
      await container.read(sessionProvider.future);
      await container.read(sessionProvider.notifier).updateRound();
      final updatedSession = container.read(sessionProvider).value!;

      expect(updatedSession.round, 2);
    });

    test('Update EndTime', () async {
      when(mockDatabase.rawUpdate(any, any)).thenAnswer((_) async => 1);
      when(mockDatabase.rawQuery(any, any)).thenAnswer((_) async => [
            {
              'id': 1,
              'round': 1,
              'begTime': '2021-09-01 00:00:00',
              'endTime': null
            }
          ]);
      await container.read(sessionProvider.future);
      await container.read(sessionProvider.notifier).updateEndTime();
      final updatedSession = container.read(sessionProvider).value!;

      expect(updatedSession.endTime, isNotNull);
    });
  });

  group('Testing SessionProvider - Exception', () {
    test('Add Session - Exception', () async {
      when(mockDatabase.rawQuery('SELECT MAX(id) as maxId FROM Session'))
          .thenThrow(Exception());
      await container.read(sessionProvider.notifier).addSession();

      expect(container.read(sessionProvider), isA<AsyncError<Session?>>());
    });

    test('Get Session - Exception', () async {
      when(mockDatabase.rawQuery(any, any)).thenThrow(Exception());
      await container.read(sessionProvider.notifier).getSession();

      expect(container.read(sessionProvider), isA<AsyncError<Session?>>());
    });

    test('Update Round - Exception', () async {
      when(mockDatabase.rawUpdate(any, any)).thenThrow(Exception());
      when(mockDatabase.rawQuery(any, any)).thenAnswer((_) async => [
            {
              'id': 1,
              'round': 1,
              'begTime': '2021-09-01 00:00:00',
              'endTime': null
            }
          ]);
      await container.read(sessionProvider.future);
      await container.read(sessionProvider.notifier).updateRound();

      expect(container.read(sessionProvider), isA<AsyncError<Session?>>());
    });

    test('Update EndTime - Exception', () async {
      when(mockDatabase.rawUpdate(any, any)).thenThrow(Exception());
      when(mockDatabase.rawQuery(any, any)).thenAnswer((_) async => [
            {
              'id': 1,
              'round': 1,
              'begTime': '2021-09-01 00:00:00',
              'endTime': null
            }
          ]);
      await container.read(sessionProvider.future);
      await container.read(sessionProvider.notifier).updateEndTime();

      expect(container.read(sessionProvider), isA<AsyncError<Session?>>());
    });
  });
}
