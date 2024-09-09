// lib/domain/usecases/delete_event.dart

import 'package:dartz/dartz.dart';
import 'package:event_planner/core/errors/failure.dart';

import '../repositories/event_repository.dart';

class DeleteEvent {
  final EventRepository repository;

  DeleteEvent({required this.repository});

  Future<Either<Failure, void>> call(String id) async => 
    repository.deleteEvent(id);
}
