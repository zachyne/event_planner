import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:event_planner/features/event_management/domain/entities/event.dart';

import 'package:dartz/dartz.dart';
import 'package:event_planner/features/event_management/domain/use_cases/create_event.dart';
import 'package:event_planner/features/event_management/domain/use_cases/delete_event.dart';
import 'package:event_planner/features/event_management/domain/use_cases/get_all_events.dart';
import 'package:event_planner/features/event_management/domain/use_cases/update_event.dart';
import 'package:event_planner/core/errors/failure.dart';

part 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  final CreateEvent createEventUseCase;
  final DeleteEvent deleteEventUseCase;
  final GetAllEvents getAllEventsUseCase;
  final UpdateEvent updateEventUseCase;

  // Local cache for the event list
  List<Event> _eventsCache = [];

  EventCubit({
    required this.createEventUseCase,
    required this.deleteEventUseCase,
    required this.getAllEventsUseCase,
    required this.updateEventUseCase,
  }) : super(EventInitial());

  // Get events and cache them locally
  Future<void> getAllEvents() async {
    emit(EventLoading());

    final Either<Failure, List<Event>> result =
        await getAllEventsUseCase.call();

    result.fold(
      (failure) => emit(EventError(failure.getMessage())),
      (events) {
        _eventsCache = events;
        emit(EventLoaded(events: _eventsCache));
      },
    );
  }

  // Create event and add to cache
  Future<void> createEvent(Event event) async {
    emit(EventLoading());

    final Either<Failure, void> result = await createEventUseCase.call(event);

    result.fold(
      (failure) => emit(EventError(failure.getMessage())),
      (_) {
        _eventsCache.add(event);
        emit(EventLoaded(events: _eventsCache));
      },
    );
  }

  // Update an event and modify it in the cache
  Future<void> updateEvent(Event event) async {
    emit(EventLoading());

    final Either<Failure, void> result = await updateEventUseCase.call(event);

    result.fold(
      (failure) => emit(EventError(failure.getMessage())),
      (_) {
        final index = _eventsCache.indexWhere((e) => e.id == event.id);
        if (index != -1) {
          _eventsCache[index] = event; // update cache
          emit(EventLoaded(events: List.from(_eventsCache)));
        } else {
          emit(EventError("Expense not found in cache"));
        }
        // _eventsCache =
        //     _eventsCache.map((e) => e.id == event.id ? event : e).toList();
        // emit(EventLoaded(events: _eventsCache));
      },
    );
  }

  // Delete an event from the cache
  Future<void> deleteEvent(String id) async {
    emit(EventLoading());

    final Either<Failure, void> result = await deleteEventUseCase.call(id);

    result.fold(
      (failure) => emit(EventError(failure.getMessage())),
      (_) {
        _eventsCache.removeWhere((event) => event.id == id);
        emit(EventLoaded(events: _eventsCache));
      },
    );
  }

  // Helper method to map Failure to readable message
  String _mapFailureToMessage(Failure failure) {
    // Customize this according to your error handling strategy
    return failure.toString();
  }
}
