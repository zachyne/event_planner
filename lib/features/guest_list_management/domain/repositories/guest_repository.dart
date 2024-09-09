// lib/domain/repositories/guest_repository.dart

import 'package:dartz/dartz.dart';
import 'package:event_planner/core/errors/failure.dart';

import '../entities/guest.dart';

abstract class GuestRepository {
  Future<Either<Failure, void>> createGuest(Guest guest);
  Future<Either<Failure, Guest?>> getGuest(String id);
  Future<Either<Failure, List<Guest>>> getGuestsByEvent(String eventId);
  Future<Either<Failure, void>> updateGuest(Guest guest);
  Future<Either<Failure, void>> deleteGuest(String id);
}
