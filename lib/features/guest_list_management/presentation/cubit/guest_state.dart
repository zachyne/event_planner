part of 'guest_cubit.dart';

// Define different states for GuestCubit
abstract class GuestState extends Equatable {
  const GuestState();

  @override
  List<Object?> get props => [];
}

// Initial State
class GuestInitial extends GuestState {}

// Loading State
class GuestLoading extends GuestState {}

class GuestAdded extends GuestState {}

class GuestDeleted extends GuestState {}

class GuestUpdated extends GuestState {
  final Guest newGuest;

  const GuestUpdated(this.newGuest);

  @override
  List<Object?> get props => [newGuest];  
}


// Success State (with List<Guest>)
class GuestLoaded extends GuestState {
  final List<Guest> guests;

  const GuestLoaded({required this.guests});

  @override
  List<Object?> get props => [guests];
}

// Error State (with error message)
class GuestError extends GuestState {
  final String message;

  const GuestError(this.message);

  @override
  List<Object?> get props => [message];
}
