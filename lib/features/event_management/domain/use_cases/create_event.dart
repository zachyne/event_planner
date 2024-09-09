// lib/domain/usecases/create_event.dart

import 'package:dartz/dartz.dart';
import 'package:event_planner/core/errors/failure.dart';

import '../entities/event.dart';
import '../repositories/event_repository.dart';

class CreateEvent {
  final EventRepository repository;

  CreateEvent({required this.repository});

  Future<Either<Failure, void>> call(Event event) async =>
    repository.createEvent(event);
}
