import 'package:event_planner/features/event_management/domain/entities/event.dart';

abstract class EventRemoteDataSource {
  Future<void> createEvent(Event event);
  Future<Event?> getEvent(String id);
  Future<List<Event>> getAllEvents();
  Future<void> updateEvent(Event event);
  Future<void> deleteEvent(String id);
}