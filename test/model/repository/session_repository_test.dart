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
  late SessionRepository repository;

  setUp(() {
    mockDatabase = MockDatabase();
    repository = SessionRepository(mockDatabase);
  });

  group('SessionRepository - Normal cases', () {
    test('Add Session - Success', () async {
      when(mockDatabase.rawInsert(any, any)).thenAnswer((_) async => 1);
      final newSession = await repository.addSession(1);

      expect(newSession.id, 1);
      expect(newSession.round, 1);
      expect(newSession.begTime, isNotNull);
      expect(newSession.endTime, isNull);
      verify(mockDatabase.rawInsert(
        'INSERT INTO Session(id, round, begTime) VALUES(?, ?, ?)',
        [1, 1, newSession.begTime],
      )).called(1);
    });

    test('Get Session - Active Session Exists', () async {
      when(mockDatabase.rawQuery(any)).thenAnswer((_) async => [
            {
              'id': 1,
              'round': 2,
              'begTime': '2020-01-01 00:00:00',
              'endTime': null
            },
          ]);
      final session = await repository.getSession();

      expect(session, isNotNull);
      expect(session!.id, 1);
      expect(session.round, 2);
      expect(session.begTime, '2020-01-01 00:00:00');
      expect(session.endTime, null);
      verify(mockDatabase
              .rawQuery('SELECT * FROM Session WHERE endTime IS NULL'))
          .called(1);
    });

    test('Get Session - No Active Session', () async {
      when(mockDatabase.rawQuery(any)).thenAnswer((_) async => []);
      final session = await repository.getSession();

      expect(session, isNull);
      verify(mockDatabase
              .rawQuery('SELECT * FROM Session WHERE endTime IS NULL'))
          .called(1);
    });

    test('Get Session Max ID - With Existing Sessions', () async {
      when(mockDatabase.rawQuery(any)).thenAnswer((_) async => [
            {'maxId': 99},
          ]);
      final maxID = await repository.getMaxID();

      expect(maxID, 100);
      verify(mockDatabase.rawQuery('SELECT MAX(id) as maxId FROM Session'))
          .called(1);
    });

    test('Get Session Max ID - No Existing Sessions', () async {
      when(mockDatabase.rawQuery(any)).thenAnswer((_) async => [
            {'maxId': null},
          ]);
      final maxID = await repository.getMaxID();

      expect(maxID, 1);
      verify(mockDatabase.rawQuery('SELECT MAX(id) as maxId FROM Session'))
          .called(1);
    });

    test('Update Session Round', () async {
      when(mockDatabase.rawUpdate(any, any)).thenAnswer((_) async => 1);
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
      const session = Session(id: 1, round: 2, begTime: '2020-01-01 00:00:00');
      final updatedSession = await repository.updateEndTime(session);

      expect(updatedSession.id, 1);
      expect(updatedSession.round, 2);
      expect(updatedSession.begTime, '2020-01-01 00:00:00');
      expect(updatedSession.endTime, isNotNull);
      verify(mockDatabase.rawUpdate(
          'UPDATE Session SET endTime = ? WHERE id = ?',
          [updatedSession.endTime, 1])).called(1);
    });
  });

  group('SessionRepository - Edge cases', () {
    test('Add Session - With Very Large ID', () async {
      when(mockDatabase.rawInsert(any, any)).thenAnswer((_) async => 1);
      final newSession = await repository
          .addSession(9007199254740991); // Max safe integer in JavaScript

      expect(newSession.id, 9007199254740991);
      expect(newSession.round, 1);
      verify(mockDatabase.rawInsert(
        'INSERT INTO Session(id, round, begTime) VALUES(?, ?, ?)',
        [9007199254740991, 1, newSession.begTime],
      )).called(1);
    });

    test('Update Session Round - From Max Int to Overflow', () async {
      when(mockDatabase.rawUpdate(any, any)).thenAnswer((_) async => 1);
      const session = Session(
          id: 1,
          round: 2147483647,
          begTime: '2020-01-01 00:00:00'); // Max 32-bit integer
      final updatedSession = await repository.updateRound(session);

      expect(updatedSession.round,
          2147483648); // This might cause issues in some systems
      verify(mockDatabase.rawUpdate(
              'UPDATE Session SET round = ? WHERE id = ?', [2147483648, 1]))
          .called(1);
    });
  });

  group('SessionRepository - Error cases', () {
    test('Add Session - Database Error', () async {
      when(mockDatabase.rawInsert(any, any))
          .thenThrow(Exception('Failed to insert'));

      expect(() => repository.addSession(1), throwsA(isA<Exception>()));
    });

    test('Get Session - Database Error', () async {
      when(mockDatabase.rawQuery(any)).thenThrow(Exception('Failed to query'));

      expect(() => repository.getSession(), throwsA(isA<Exception>()));
    });

    test('Get Max ID - Database Error', () async {
      when(mockDatabase.rawQuery(any))
          .thenThrow(Exception('Failed to query max id'));

      expect(() => repository.getMaxID(), throwsA(isA<Exception>()));
    });

    test('Update Round - Database Error', () async {
      when(mockDatabase.rawUpdate(any, any))
          .thenThrow(Exception('Failed to update round'));
      const session = Session(id: 1, round: 2, begTime: '2020-01-01 00:00:00');

      expect(() => repository.updateRound(session), throwsA(isA<Exception>()));
    });

    test('Update End Time - Database Error', () async {
      when(mockDatabase.rawUpdate(any, any))
          .thenThrow(Exception('Failed to update end time'));
      const session = Session(id: 1, round: 2, begTime: '2020-01-01 00:00:00');

      expect(
          () => repository.updateEndTime(session), throwsA(isA<Exception>()));
    });
  });

  group('Session Extension Tests', () {
    test('getFormatBegTime - Valid DateTime', () {
      const dateTimeString = '2020-01-01 12:34:56';
      final formattedTime = dateTimeString.getFormatBegTime();
      expect(formattedTime, '2020-01-01 12:34');
    });

    test('getFormatBegTime - Invalid DateTime', () {
      const invalidDateTimeString = 'invalid-date-time';
      expect(() => invalidDateTimeString.getFormatBegTime(),
          throwsFormatException);
    });
  });
}
