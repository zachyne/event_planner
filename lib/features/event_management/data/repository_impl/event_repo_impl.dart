import 'package:dartz/dartz.dart';
import 'package:event_planner/core/errors/exceptions.dart';
import 'package:event_planner/core/errors/failure.dart';
import 'package:event_planner/features/event_management/data/data_source/event_remote_datasource.dart';
import 'package:event_planner/features/event_management/domain/entities/event.dart';
import 'package:event_planner/features/event_management/domain/repositories/event_repository.dart';

class EventRepositoryImplementation implements EventRepository {
  final EventRemoteDataSource _remoteDataSource;

  const EventRepositoryImplementation(this._remoteDataSource);

  @override
  Future<Either<Failure, void>> createEvent(Event event) async {
    try {
      return Right(await _remoteDataSource.createEvent(event));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch(e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Event?>> getEvent(String id) async {
    try {
      return Right(await _remoteDataSource.getEvent(id));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch(e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Event>>> getAllEvents() async {
    try {
      return Right(await _remoteDataSource.getAllEvents());
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch(e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateEvent(Event event) async {
    try {
      return Right(await _remoteDataSource.updateEvent(event));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch(e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEvent(String id) async {
    try {
      return Right(await _remoteDataSource.deleteEvent(id));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch(e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }
}
