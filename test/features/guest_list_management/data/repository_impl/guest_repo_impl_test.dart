import 'package:event_planner/core/errors/failure.dart';
import 'package:event_planner/features/guest_list_management/data/repository_impl/guest_repo_impl.dart';
import 'package:event_planner/features/guest_list_management/domain/entities/guest.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';

import 'guest_remote_datasource.mock.dart';

void main() {
  late MockGuestRemoteDataSource mockGuestRemoteDataSource;
  late GuestRepositoryImplementation guestRepositoryUnderTest;

  setUp(() {
    mockGuestRemoteDataSource = MockGuestRemoteDataSource();
    guestRepositoryUnderTest =
        GuestRepositoryImplementation(mockGuestRemoteDataSource);
  });

  const testGuest = Guest(
      id: '1',
      name: 'John Doe',
      contactInfo: 'johndoe@example.com',
      isRSVP: true);

  group('createGuest', () {
    test('should return void on success', () async {
      // Arrange: Stub the createGuest method to return a successful response (void)
      when(() => mockGuestRemoteDataSource.createGuest(testGuest))
          .thenAnswer((_) async => Future.value());

      // Act: Call the repository's createGuest method
      final result = await guestRepositoryUnderTest.createGuest(testGuest);

      // Assert: Verify the method was called and the result is a Right (success)
      verify(() => mockGuestRemoteDataSource.createGuest(testGuest)).called(1);
      expect(result, equals(const Right(null)));
      verifyNoMoreInteractions(mockGuestRemoteDataSource);
    });

    test(
        'should return Failure when the remote data source throws an exception',
        () async {
      // Arrange: Stub the createGuest method to throw an exception
      when(() => mockGuestRemoteDataSource.createGuest(testGuest))
          .thenThrow(Exception());

      // Act: Call the repository's createGuest method
      final result = await guestRepositoryUnderTest.createGuest(testGuest);

      // Assert: Verify the method was called and the result is a Left (Failure)
      expect(result, isA<Left<Failure, void>>()); // Expecting a failure
      verify(() => mockGuestRemoteDataSource.createGuest(testGuest)).called(1);
      verifyNoMoreInteractions(mockGuestRemoteDataSource);
    });
  });

  group('deleteGuest', () {
    const guestId = '1';

    test('should return void on success', () async {
      // Arrange: Stub the deleteGuest method to return a successful response (void)
      when(() => mockGuestRemoteDataSource.deleteGuest(guestId))
          .thenAnswer((_) async => Future.value());

      // Act: Call the repository's deleteGuest method
      final result = await guestRepositoryUnderTest.deleteGuest(guestId);

      // Assert: Verify the method was called and the result is a Right (success)
      verify(() => mockGuestRemoteDataSource.deleteGuest(guestId)).called(1);
      expect(result, equals(const Right(null)));
      verifyNoMoreInteractions(mockGuestRemoteDataSource);
    });

    test(
        'should return Failure when the remote data source throws an exception',
        () async {
      // Arrange: Stub the deleteGuest method to throw an exception
      when(() => mockGuestRemoteDataSource.deleteGuest(guestId))
          .thenThrow(Exception('Failed to delete guest'));

      // Act: Call the repository's deleteGuest method
      final result = await guestRepositoryUnderTest.deleteGuest(guestId);

      // Assert: Verify the method was called and the result is a Left (Failure)
      expect(result, isA<Left<Failure, void>>()); // Expecting a failure
      verify(() => mockGuestRemoteDataSource.deleteGuest(guestId)).called(1);
      verifyNoMoreInteractions(mockGuestRemoteDataSource);
    });
  });

  group('getGuest', () {
    test('should return Guest when successful', () async {
      // Arrange
      when(() => mockGuestRemoteDataSource.getGuest('1'))
          .thenAnswer((_) async => testGuest);

      // Act
      final result = await guestRepositoryUnderTest.getGuest('1');

      // Assert
      verify(() => mockGuestRemoteDataSource.getGuest('1')).called(1);
      expect(result, const Right(testGuest));
      verifyNoMoreInteractions(mockGuestRemoteDataSource);
    });

    test(
        'should return Failure when the remote data source throws an exception',
        () async {
      // Arrange
      when(() => mockGuestRemoteDataSource.getGuest('1'))
          .thenThrow(Exception('Failed to get guest'));

      // Act
      final result = await guestRepositoryUnderTest.getGuest('1');

      // Assert
      expect(result, isA<Left<Failure, Guest?>>());
      verify(() => mockGuestRemoteDataSource.getGuest('1')).called(1);
      verifyNoMoreInteractions(mockGuestRemoteDataSource);
    });
  });

  group('getGuestsByEvent', () {
    const eventId = '123';
    final guests = [
      const Guest(
          id: '1',
          name: 'John Doe',
          contactInfo: 'johndoe@example.com',
          isRSVP: true),
      const Guest(
          id: '2',
          name: 'Jane Smith',
          contactInfo: 'janesmith@example.com',
          isRSVP: false),
    ];

    test('should return a list of guests on success', () async {
      // Arrange: Stub the getGuestsByEvent method to return a list of guests
      when(() => mockGuestRemoteDataSource.getGuestsByEvent(eventId))
          .thenAnswer((_) async => guests);

      // Act: Call the repository's getGuestsByEvent method
      final result = await guestRepositoryUnderTest.getGuestsByEvent(eventId);

      // Assert: Verify the method was called and the result is a Right (success) with the expected list
      verify(() => mockGuestRemoteDataSource.getGuestsByEvent(eventId))
          .called(1);
      expect(result, equals(Right(guests)));
    });

    test(
        'should return Failure when the remote data source throws an exception',
        () async {
      // Arrange: Stub the getGuestsByEvent method to throw an exception
      when(() => mockGuestRemoteDataSource.getGuestsByEvent(eventId))
          .thenThrow(Exception('Failed to fetch guests'));

      // Act: Call the repository's getGuestsByEvent method
      final result = await guestRepositoryUnderTest.getGuestsByEvent(eventId);

      // Assert: Verify the method was called and the result is a Left (Failure)
      verify(() => mockGuestRemoteDataSource.getGuestsByEvent(eventId))
          .called(1);
      expect(result.isLeft(), true);
      expect(result, isA<Left<Failure, List<Guest>>>());
    });
  });

  group('updateGuest', () {
    test('should return Void if the guest was updated successfully', () async {
      // Arrange: Stub the updateGuest method to return a successful response (void)
      when(() => mockGuestRemoteDataSource.updateGuest(testGuest))
          .thenAnswer((_) async => Future.value());
        
      // Act: Call the repository's updateGuest method
      final result = await guestRepositoryUnderTest.updateGuest(testGuest);

      // Assert: Verify the method was called and the result is a Right (success)
      verify(() => mockGuestRemoteDataSource.updateGuest(testGuest)).called(1);
      expect(result, equals(const Right(null)));
      verifyNoMoreInteractions(mockGuestRemoteDataSource);
    });

    test(
        'should return Failure when the remote data source throws an exception',
        () async {
      // Arrange: Stub the updateGuest method to throw an exception
      when(() => mockGuestRemoteDataSource.updateGuest(testGuest))
          .thenThrow(Exception('Failed to update guest'));

      // Act: Call the repository's updateGuest method
      final result = await guestRepositoryUnderTest.updateGuest(testGuest);

      // Assert: Verify the method was called and the result is a Left (Failure)
      expect(result, isA<Left<Failure, void>>()); // Expecting a failure
      verify(() => mockGuestRemoteDataSource.updateGuest(testGuest)).called(1);
      verifyNoMoreInteractions(mockGuestRemoteDataSource);
    });
  });
}
