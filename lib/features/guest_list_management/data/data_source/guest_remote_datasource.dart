import 'package:event_planner/features/guest_list_management/domain/entities/guest.dart';

abstract class GuestRemoteDataSource {
  Future<String> createGuest(Guest guest);
  Future<Guest?> getGuest(String id);
  Future<List<Guest>> getGuestsByEvent(String eventId);
  Future<void> updateGuest(Guest guest);
  Future<void> deleteGuest(String id);
  // new
  Future<List<Guest>> getAllGuests();
}