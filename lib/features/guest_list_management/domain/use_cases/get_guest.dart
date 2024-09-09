// lib/domain/usecases/get_guest.dart

import 'package:dartz/dartz.dart';
import 'package:event_planner/core/errors/failure.dart';

import '../entities/guest.dart';
import '../repositories/guest_repository.dart';

class GetGuest {
  final GuestRepository repository;

  GetGuest({required this.repository});

  Future<Either<Failure, Guest?>> call(String id) async {
    return await repository.getGuest(id);
  }
}
