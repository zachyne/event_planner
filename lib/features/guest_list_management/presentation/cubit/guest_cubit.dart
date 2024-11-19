import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:event_planner/core/errors/failure.dart';
import 'package:event_planner/features/guest_list_management/domain/entities/guest.dart';
import 'package:event_planner/features/guest_list_management/domain/use_cases/create_guest.dart';
import 'package:event_planner/features/guest_list_management/domain/use_cases/delete_guest.dart';
import 'package:event_planner/features/guest_list_management/domain/use_cases/get_all_guests.dart';
import 'package:event_planner/features/guest_list_management/domain/use_cases/get_guests_by_event.dart';
import 'package:event_planner/features/guest_list_management/domain/use_cases/update_guest.dart';

part 'guest_state.dart';

const String noInternetErrorMessage =
    "Sync Failed: Changes saved on your device and will sync once you're back online.";

class GuestCubit extends Cubit<GuestState> {
  final CreateGuest createGuestUseCase;
  final DeleteGuest deleteGuestUseCase;
  final GetGuestsByEvent getGuestsByEventUseCase;
  final UpdateGuest updateGuestUseCase;
  final GetAllGuests getAllGuestsUseCase;

  // Local cache for the guest list
  List<Guest> _guestsCache = [];

  GuestCubit({
    required this.createGuestUseCase,
    required this.deleteGuestUseCase,
    required this.getGuestsByEventUseCase,
    required this.updateGuestUseCase,
    required this.getAllGuestsUseCase,
  }) : super(GuestInitial());

  // Get guests by event and cache them locally
  Future<void> getGuestsByEvent(String eventId) async {
    emit(GuestLoading());

    try {
      final Either<Failure, List<Guest>> result =
          await getGuestsByEventUseCase.call(eventId).timeout(
                const Duration(seconds: 10),
                onTimeout: () => throw TimeoutException("Request timed out"),
              );

      result.fold(
        (failure) => emit(GuestError(failure.getMessage())),
        (guests) {
          _guestsCache = guests;
          emit(GuestLoaded(guests: _guestsCache));
        },
      );
    } on TimeoutException catch (_) {
      emit(const GuestError("There seems to be a problem with your Internet connection"));
    }
  }

  // Create guest and add to cache
  Future<void> createGuest(Guest guest) async {
    emit(GuestLoading());

    try {
      final Either<Failure, String> result =
          await createGuestUseCase.call(guest);

      result.fold(
        (failure) => emit(GuestError(failure.getMessage())),
        (_) {
          emit(GuestAdded());
        },
      );
    } catch (_) {
      emit(const GuestError(noInternetErrorMessage));
    }
  }

  // Update a guest and modify it in the cache
  Future<void> updateGuest(Guest guest) async {
    emit(GuestLoading());

    try {
      final Either<Failure, void> result = await updateGuestUseCase
          .call(guest)
          .timeout(const Duration(seconds: 10),
              onTimeout: () => throw TimeoutException("Request timed out."));

      result.fold(
        (failure) => emit(GuestError(failure.getMessage())),
        (_) {
          emit(GuestUpdated(guest));
        },
      );
    } catch (_) {
      emit(const GuestError(noInternetErrorMessage));
    }
  }

  // Delete a guest from the cache
  Future<void> deleteGuest(String id) async {
    emit(GuestLoading());

    try {
      final Either<Failure, void> result = await deleteGuestUseCase
          .call(id)
          .timeout(const Duration(seconds: 10),
              onTimeout: () => throw TimeoutException("Request timed out"));

      result.fold(
        (failure) => emit(GuestError(failure.getMessage())),
        (_) {
          _guestsCache.removeWhere((guest) => guest.id == id);
          emit(GuestLoaded(guests: _guestsCache));
        },
      );
    } catch (_) {
      emit(const GuestError(noInternetErrorMessage));
    }
  }

  // Get all guests and cache them locally
  Future<void> getAllGuests() async {
    emit(GuestLoading());

    final Either<Failure, List<Guest>> result =
        await getAllGuestsUseCase.call();

    result.fold(
      (failure) => emit(GuestError(failure.getMessage())),
      (guests) {
        _guestsCache = guests;
        emit(GuestLoaded(guests: _guestsCache));
      },
    );
  }
}
