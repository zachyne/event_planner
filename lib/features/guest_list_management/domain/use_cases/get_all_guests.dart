// lib/domain/usecases/get_all_guests.dart

import 'package:dartz/dartz.dart';
import 'package:event_planner/core/errors/failure.dart';

import '../entities/guest.dart';
import '../repositories/guest_repository.dart';

class GetAllGuests {
  final GuestRepository repository;

  GetAllGuests({required this.repository});

  Future<Either<Failure, List<Guest>>> call() async {
    return await repository.getAllGuests();
  }
}