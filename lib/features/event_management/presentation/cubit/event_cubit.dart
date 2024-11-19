import 'dart:async';

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

const String noInternetErrorMessage =
    "Sync Failed: Changes saved on your device and will sync once you're back online.";


class EventCubit extends Cubit<EventState> {
  final CreateEvent createEventUseCase;
  final DeleteEvent deleteEventUseCase;
  final GetAllEvents getAllEventsUseCase;
  final UpdateEvent updateEventUseCase;

  EventCubit({
    required this.createEventUseCase,
    required this.deleteEventUseCase,
    required this.getAllEventsUseCase,
    required this.updateEventUseCase,
  }) : super(EventInitial());

  // Get events and cache them locally
  Future<void> getAllEvents() async {
    emit(EventLoading());

    try {
      final Either<Failure, List<Event>> result = await getAllEventsUseCase
          .call()
          .timeout(const Duration(seconds: 10),
              onTimeout: () => throw TimeoutException("Request timed out"));

      result.fold(
        (failure) => emit(EventError(failure.getMessage())),
        (events) {
          emit(EventLoaded(events: events));
        },
      );
    } on TimeoutException catch (_) {
      emit(const EventError(
          "There seems to be a problem with your Internet connection"));
    }
  }

  // Create event and add to cache
  Future<void> createEvent(Event event) async {
    print("Guest IDs before saving: ${event.guestIds}"); // Debug log
    emit(EventLoading());

    try {
      final Either<Failure, void> result = await createEventUseCase
          .call(event)
          .timeout(const Duration(seconds: 10),
              onTimeout: () => throw TimeoutException("Request timed out"));

      result.fold(
        (failure) => emit(EventError(failure.getMessage())),
        (_) {
          emit(EventAdded());
        },
      );
    } catch (_) {
      emit(const EventError(noInternetErrorMessage));
    }
  }

  // Update an event and modify it in the cache
  Future<void> updateEvent(Event event) async {
    emit(EventLoading());

    try {
      final Either<Failure, void> result = await updateEventUseCase
          .call(event)
          .timeout(const Duration(seconds: 10),
              onTimeout: () => throw TimeoutException("Request timed out"));

      result.fold(
        (failure) => emit(EventError(failure.getMessage())),
        (_) {
          emit(EventUpdated(event));
        },
      );
    } catch (_) {
      emit(const EventError(noInternetErrorMessage));
    }
  }

  // Delete an event from the cache
  Future<void> deleteEvent(Event event) async {
    emit(EventLoading());

    try {
      final Either<Failure, void> result = await deleteEventUseCase(event.id).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException("Request timed out"),
      );

      result.fold(
        (failure) => emit(EventError(failure.getMessage())),
        (_) {
          emit(EventDeleted());
        },
      );
    } catch (_) {
      emit(const EventError(noInternetErrorMessage));
    }
  }

  

  // // Helper method to map Failure to readable message
  // String _mapFailureToMessage(Failure failure) {
  //   // Customize this according to your error handling strategy
  //   return failure.toString();
  // }
}
