import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:event_planner/core/errors/failure.dart';
import 'package:event_planner/features/guest_list_management/domain/entities/guest.dart';
import 'package:event_planner/features/guest_list_management/domain/use_cases/create_guest.dart';
import 'package:event_planner/features/guest_list_management/domain/use_cases/delete_guest.dart';
import 'package:event_planner/features/guest_list_management/domain/use_cases/get_guests_by_event.dart';
import 'package:event_planner/features/guest_list_management/domain/use_cases/update_guest.dart';

part 'guest_state.dart';

class GuestCubit extends Cubit<GuestState> {
  final CreateGuest createGuestUseCase;
  final DeleteGuest deleteGuestUseCase;
  final GetGuestsByEvent getGuestsByEventUseCase;
  final UpdateGuest updateGuestUseCase;

  // Local cache for the guest list
  List<Guest> _guestsCache = [];

  GuestCubit({
    required this.createGuestUseCase,
    required this.deleteGuestUseCase,
    required this.getGuestsByEventUseCase,
    required this.updateGuestUseCase,
  }) : super(GuestInitial());

  // Get guests by event and cache them locally
  Future<void> getGuestsByEvent(String eventId) async {
    emit(GuestLoading());

    final Either<Failure, List<Guest>> result =
        await getGuestsByEventUseCase.call(eventId);

    result.fold(
      (failure) => emit(GuestError(failure.getMessage())),
      (guests) {
        _guestsCache = guests;
        emit(GuestLoaded(guests: _guestsCache));
      },
    );
  }

  // Create guest and add to cache
  Future<void> createGuest(Guest guest) async {
    emit(GuestLoading());

    final Either<Failure, void> result = await createGuestUseCase.call(guest);

    result.fold(
      (failure) => emit(GuestError(failure.getMessage())),
      (_) {
        _guestsCache.add(guest);
        emit(GuestLoaded(guests: _guestsCache));
      },
    );
  }

  // Update a guest and modify it in the cache
  Future<void> updateGuest(Guest guest) async {
    emit(GuestLoading());

    final Either<Failure, void> result = await updateGuestUseCase.call(guest);

    result.fold(
        (failure) => emit(GuestError(failure.getMessage())),
        (_) {
      final index = _guestsCache.indexWhere((e) => e.id == guest.id);
      if (index != -1) {
        _guestsCache[index] = guest; // update cache
        emit(GuestLoaded(guests: List.from(_guestsCache)));
      } else {
        emit(GuestError("Expense not found in cache"));
      }
    }

        // {
        //   _guestsCache = _guestsCache.map((g) => g.id == guest.id ? guest : g).toList();
        //   emit(GuestLoaded(guests: _guestsCache));
        // },
        );
  }

  // Delete a guest from the cache
  Future<void> deleteGuest(String id) async {
    emit(GuestLoading());

    final Either<Failure, void> result = await deleteGuestUseCase.call(id);

    result.fold(
      (failure) => emit(GuestError(failure.getMessage())),
      (_) {
        _guestsCache.removeWhere((guest) => guest.id == id);
        emit(GuestLoaded(guests: _guestsCache));
      },
    );
  }

  // Helper method to map Failure to readable message
  String _mapFailureToMessage(Failure failure) {
    // Customize this according to your error handling strategy
    return failure.toString();
  }
}
