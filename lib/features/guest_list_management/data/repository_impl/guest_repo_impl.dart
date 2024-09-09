import 'package:dartz/dartz.dart';
import 'package:event_planner/core/errors/exceptions.dart';
import 'package:event_planner/core/errors/failure.dart';
import 'package:event_planner/features/guest_list_management/data/data_source/guest_remote_datasource.dart';
import 'package:event_planner/features/guest_list_management/domain/entities/guest.dart';
import 'package:event_planner/features/guest_list_management/domain/repositories/guest_repository.dart';

class GuestRepositoryImplementation implements GuestRepository {
  final GuestRemoteDataSource _remoteDataSource;

  const GuestRepositoryImplementation(this._remoteDataSource);

  @override
  Future<Either<Failure, void>> createGuest(Guest guest) async {
    try {
      return Right(await _remoteDataSource.createGuest(guest));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch(e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteGuest(String id) async {
    try {
      return Right(await _remoteDataSource.deleteGuest(id));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch(e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Guest?>> getGuest(String id) async {
    try {
      return Right(await _remoteDataSource.getGuest(id));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch(e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Guest>>> getGuestsByEvent(String eventId) async {
    try {
      return Right(await _remoteDataSource.getGuestsByEvent(eventId));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch(e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateGuest(Guest guest) async {
    try {
      return Right(await _remoteDataSource.updateGuest(guest));
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch(e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

}