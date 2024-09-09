// lib/domain/usecases/get_guests_by_event.dart

import 'package:dartz/dartz.dart';
import 'package:event_planner/core/errors/failure.dart';

import '../entities/guest.dart';
import '../repositories/guest_repository.dart';

class GetGuestsByEvent {
  final GuestRepository repository;

  GetGuestsByEvent({required this.repository});

  Future<Either<Failure, List<Guest>>> call(String eventId) async {
    return await repository.getGuestsByEvent(eventId);
  }
}
