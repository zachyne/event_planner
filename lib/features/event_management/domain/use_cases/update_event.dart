// lib/domain/usecases/update_event.dart

import 'package:dartz/dartz.dart';
import 'package:event_planner/core/errors/failure.dart';

import '../entities/event.dart';
import '../repositories/event_repository.dart';

class UpdateEvent {
  final EventRepository repository;

  UpdateEvent({required this.repository});

  Future<Either<Failure, void>> call(Event event) async => 
    repository.updateEvent(event);
}
