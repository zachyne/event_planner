// lib/domain/usecases/get_all_events.dart

import 'package:dartz/dartz.dart';
import 'package:event_planner/core/errors/failure.dart';

import '../entities/event.dart';
import '../repositories/event_repository.dart';

class GetAllEvents {
  final EventRepository repository;

  GetAllEvents({required this.repository});

  Future<Either<Failure, List<Event>>> call() async {
    return await repository.getAllEvents();
  }
}