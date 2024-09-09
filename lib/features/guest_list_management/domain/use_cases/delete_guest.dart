// lib/domain/usecases/delete_guest.dart

import 'package:dartz/dartz.dart';
import 'package:event_planner/core/errors/failure.dart';

import '../repositories/guest_repository.dart';

class DeleteGuest {
  final GuestRepository repository;

  DeleteGuest({required this.repository});

  Future<Either<Failure, void>> call(String id) async => await repository.deleteGuest(id);
}
