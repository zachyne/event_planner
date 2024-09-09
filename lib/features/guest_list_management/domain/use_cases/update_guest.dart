// lib/domain/usecases/update_guest.dart

import 'package:dartz/dartz.dart';
import 'package:event_planner/core/errors/failure.dart';

import '../entities/guest.dart';
import '../repositories/guest_repository.dart';

class UpdateGuest {
  final GuestRepository repository;

  UpdateGuest({required this.repository});

  Future<Either<Failure, void>> call(Guest guest) async {
    return await repository.updateGuest(guest);
  }
}
