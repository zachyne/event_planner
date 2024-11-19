part of 'event_cubit.dart';

// Define different states for EventCubit
abstract class EventState extends Equatable {
  const EventState();

  @override
  List<Object?> get props => [];
}

// Initial State
class EventInitial extends EventState {}

// Loading State
class EventLoading extends EventState {}

// Success State (with List<Event>)
class EventLoaded extends EventState {
  final List<Event> events;

  const EventLoaded({required this.events});

  @override
  List<Object?> get props => [events];
}

class EventAdded extends EventState {}

class EventDeleted extends EventState {}

class EventUpdated extends EventState {
  final Event newEvent;

  const EventUpdated(this.newEvent);

  @override
  List<Object?> get props => [newEvent];  
}

// Error State (with error message)
class EventError extends EventState {
  final String message;

  const EventError(this.message);

  @override
  List<Object?> get props => [message];
}
