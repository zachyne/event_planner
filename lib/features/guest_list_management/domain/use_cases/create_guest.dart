// lib/domain/usecases/create_guest.dart

import 'package:dartz/dartz.dart';
import 'package:event_planner/core/errors/failure.dart';

import '../entities/guest.dart';
import '../repositories/guest_repository.dart';

class CreateGuest {
  final GuestRepository repository;

  CreateGuest({required this.repository});

  Future<Either<Failure, String>> call(Guest guest) async {
    return await repository.createGuest(guest);
  }
}
