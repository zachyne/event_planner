import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_planner/core/errors/exceptions.dart';
import 'package:event_planner/features/guest_list_management/data/data_source/guest_remote_datasource.dart';
import 'package:event_planner/features/guest_list_management/data/models/guest_model.dart';
import 'package:event_planner/features/guest_list_management/domain/entities/guest.dart';

class GuestFirebaseRemoteDataSource implements GuestRemoteDataSource {
  final FirebaseFirestore _firestore;

  GuestFirebaseRemoteDataSource(this._firestore);

  @override
  Future<String> createGuest(Guest guest) async {
  try {
    final guestDocRef = _firestore.collection('guests').doc();
    final guestModel = GuestModel(
      id: guestDocRef.id,
      name: guest.name,
      contactInfo: guest.contactInfo,
      isRSVP: guest.isRSVP,
    );
    await guestDocRef.set(guestModel.toMap());
    return guestDocRef.id; // Return the ID of the newly created document
  } on FirebaseException catch (e) {
    throw APIException(
      message: e.message ?? 'Unknown error has occurred',
      statusCode: e.code,
    );
  } catch (e) {
    throw APIException(message: e.toString(), statusCode: '500');
  }
}

  @override
  Future<void> deleteGuest(String id) async {
    try {
      await _firestore.collection('guests').doc(id).delete();
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Unknown error occurred', statusCode: e.code);
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<Guest?> getGuest(String id) async {
    try {
      final doc = await _firestore.collection('guests').doc(id).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return Guest(
          id: data['id'],
          name: data['name'],
          contactInfo: data['contactInfo'],
          isRSVP: data['isRSVP'],
        );
      }
      return null;
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Unknown error occurred', statusCode: e.code);
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

//   @override
// Future<List<Guest>> getGuestsByEvent(String eventId) async {
//   try {
//     // Fetch event data first to get guestIds
//     final eventSnapshot = await _firestore
//         .collection('events')
//         .doc(eventId)
//         .get();

//     if (!eventSnapshot.exists) {
//       throw const APIException(
//           message: 'Event not found', statusCode: '404');
//     }

//     final eventData = eventSnapshot.data();
//     List<String> guestIds = List<String>.from(eventData?['guestIds'] ?? []);

//     // Now fetch guests based on guestIds
//     List<Guest> guests = [];
//     for (String guestId in guestIds) {
//       final guestSnapshot = await _firestore
//           .collection('guests')
//           .doc(guestId)
//           .get();

//       if (guestSnapshot.exists) {
//         final guestData = guestSnapshot.data();
//         guests.add(Guest(
//           id: guestData?['id'],
//           name: guestData?['name'],
//           contactInfo: guestData?['contactInfo'],
//           isRSVP: guestData?['isRSVP'],
//         ));
//       }
//     }

//     return guests;
//   } on FirebaseException catch (e) {
//     throw APIException(
//         message: e.message ?? 'Unknown error occurred', statusCode: e.code);
//   } on APIException {
//     rethrow;
//   } catch (e) {
//     throw APIException(message: e.toString(), statusCode: '500');
//   }
// }
@override
Future<List<Guest>> getGuestsByEvent(String eventId) async {
  try {
    // Fetch event data to get guestIds
    final eventSnapshot = await _firestore
        .collection('events')
        .doc(eventId)
        .get();

    if (!eventSnapshot.exists) {
      throw const APIException(
          message: 'Event not found', statusCode: '404');
    }

    final eventData = eventSnapshot.data();
    // Ensure guestIds is a List<String>, fallback to empty list if not found
    List<String> guestIds = List<String>.from(eventData?['guestIds'] ?? []);

    // Fetch guests based on guestIds
    List<Guest> guests = [];
    for (String guestId in guestIds) {
      final guestSnapshot = await _firestore
          .collection('guests')
          .doc(guestId)
          .get();

      if (guestSnapshot.exists) {
        final guestData = guestSnapshot.data();
        // Ensure correct data types for guest fields
        guests.add(Guest(
          id: guestData?['id'] ?? '', // Default to empty string if not found
          name: guestData?['name'] ?? '',
          contactInfo: guestData?['contactInfo'] ?? '',
          isRSVP: guestData?['isRSVP'] ?? false, // Default to false if not found
        ));
      }
    }

    return guests;
  } on FirebaseException catch (e) {
    throw APIException(
        message: e.message ?? 'Unknown error occurred', statusCode: e.code);
  } on APIException {
    rethrow;
  } catch (e) {
    throw APIException(message: e.toString(), statusCode: '500');
  }
}



  @override
  Future<void> updateGuest(Guest guest) async {
    final guestData = {
      'id': guest.id,
      'name': guest.name,
      'contactInfo': guest.contactInfo,
      'isRSVP': guest.isRSVP,
    };
    try {
      await _firestore.collection('guests').doc(guest.id).update(guestData);
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Unknown error occurred', statusCode: e.code);
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  // new

  @override
  Future<List<Guest>> getAllGuests() async {
    try {
      final snapshot = await _firestore.collection('guests').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Guest(
          id: data['id'],
          name: data['name'],
          contactInfo: data['contactInfo'],
          isRSVP: data['isRSVP'],
        );
      }).toList();
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Unknown error occurred', statusCode: e.code);
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }
}
