import 'package:family_game_score/model/entity/session.dart';
import 'package:family_game_score/model/repository/session_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

import 'session_repository_test.mocks.dart';

@GenerateMocks([Database])
void main() {
  late MockDatabase mockDatabase;

  setUp(() {
    mockDatabase = MockDatabase();
  });

  group('Testing SessionRepository', () {
    test('Add Session', () async {
      when(mockDatabase.rawInsert(any, any)).thenAnswer((_) async => 1);
      final repository = SessionRepository(mockDatabase);
      final newSession = await repository.addSession(1);

      expect(newSession.id, 1);
      expect(newSession.round, 1);
    });

    test('Get Session', () async {
      when(mockDatabase.rawQuery(any, any)).thenAnswer((_) async => [
            {
              'id': 1,
              'round': 2,
              'begTime': '2020-01-01 00:00:00',
              'endTime': null
            },
          ]);
      final repository = SessionRepository(mockDatabase);
      final session = await repository.getSession();

      expect(session!.id, 1);
      expect(session.round, 2);
      expect(session.begTime, '2020-01-01 00:00:00');
      expect(session.endTime, null);
    });

    test('Get Session Max ID', () async {
      when(mockDatabase.rawQuery(any, any)).thenAnswer((_) async => [
            {
              'maxId': 99,
            },
          ]);
      final repository = SessionRepository(mockDatabase);
      final maxID = await repository.getMaxID();

      expect(maxID, 100);
    });

    test('Update Session Round', () async {
      when(mockDatabase.rawUpdate(any, any)).thenAnswer((_) async => 1);
      final repository = SessionRepository(mockDatabase);
      const session = Session(id: 1, round: 2, begTime: '2020-01-01 00:00:00');
      final updatedSession = await repository.updateRound(session);

      expect(updatedSession.id, 1);
      expect(updatedSession.round, 3);
      expect(updatedSession.begTime, '2020-01-01 00:00:00');
      expect(updatedSession.endTime, null);
      verify(mockDatabase.rawUpdate(
          'UPDATE Session SET round = ? WHERE id = ?', [3, 1])).called(1);
    });

    test('Update Session EndTime', () async {
      when(mockDatabase.rawUpdate(any, any)).thenAnswer((_) async => 1);
      final repository = SessionRepository(mockDatabase);
      const session = Session(id: 1, round: 2, begTime: '2020-01-01 00:00:00');
      final updatedSession = await repository.updateEndTime(session);

      expect(updatedSession.id, 1);
      expect(updatedSession.round, 2);
      expect(updatedSession.begTime, '2020-01-01 00:00:00');
      verify(mockDatabase.rawUpdate(
          'UPDATE Session SET endTime = ? WHERE id = ?',
          [updatedSession.endTime, 1])).called(1);
    });
  });

  group('Testing SessionRepository - Exception', () {
    test('Add Session - Throws Exception', () async {
      when(mockDatabase.rawInsert(any, any))
          .thenThrow(Exception('Failed to insert'));
      final repository = SessionRepository(mockDatabase);

      expect(() async => await repository.addSession(1), throwsException);
    });

    test('Get Session - Throws Exception', () async {
      when(mockDatabase.rawQuery(any, any))
          .thenThrow(Exception('Failed to fetch'));
      final repository = SessionRepository(mockDatabase);

      expect(() async => await repository.getSession(), throwsException);
    });

    test('Get Max ID - Throws Exception', () async {
      when(mockDatabase.rawQuery(any, any))
          .thenThrow(Exception('Failed to fetch max id'));
      final repository = SessionRepository(mockDatabase);

      expect(() async => await repository.getMaxID(), throwsException);
    });

    test('Update Round - Throws Exception', () async {
      when(mockDatabase.rawUpdate(any, any))
          .thenThrow(Exception('Failed to update round'));
      final repository = SessionRepository(mockDatabase);
      const session = Session(id: 1, round: 2, begTime: '2020-01-01 00:00:00');

      expect(
          () async => await repository.updateRound(session), throwsException);
    });

    test('Update End Time - Throws Exception', () async {
      when(mockDatabase.rawUpdate(any, any))
          .thenThrow(Exception('Failed to update end time'));
      final repository = SessionRepository(mockDatabase);
      const session = Session(id: 1, round: 2, begTime: '2020-01-01 00:00:00');

      expect(
          () async => await repository.updateEndTime(session), throwsException);
    });
  });
}
