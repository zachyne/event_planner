// lib/domain/usecases/get_event.dart

import 'package:dartz/dartz.dart';
import 'package:event_planner/core/errors/failure.dart';

import '../entities/event.dart';
import '../repositories/event_repository.dart';

class GetEvent {
  final EventRepository repository;

  GetEvent({required this.repository});

  Future<Either<Failure, Event?>> call(String id) async {
    return await repository.getEvent(id);
  }
}
