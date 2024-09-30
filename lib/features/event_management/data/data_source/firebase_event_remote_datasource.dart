import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_planner/core/errors/exceptions.dart';
import 'package:event_planner/features/event_management/data/data_source/event_remote_datasource.dart';
import 'package:event_planner/features/event_management/data/models/event_model.dart';
import 'package:event_planner/features/event_management/domain/entities/event.dart';

class EventFirebaseRemoteDatasource implements EventRemoteDataSource {
  final FirebaseFirestore _firestore;

  EventFirebaseRemoteDatasource(this._firestore);

  @override
  Future<void> createEvent(Event event) async {
    try {
      final eventDocRef = _firestore.collection('events').doc();
      final eventModel = EventModel(
          id: eventDocRef.id,
          title: event.title,
          date: event.date,
          time: event.time,
          location: event.location,
          description: event.description,
          guestIds: event.guestIds);
      await eventDocRef.set(eventModel.toMap());
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Unknown error has occured',
          statusCode: e.code);
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<void> deleteEvent(String id) async {
    try {
      await _firestore.collection('events').doc(id).delete();
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Unknown error has occured',
          statusCode: e.code);
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<List<Event>> getAllEvents() async {
    try {
      final querySnapshot = await _firestore.collection('events').get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Event(
          id: data['id'],
          title: data['title'],
          date: DateTime.parse(data['date']),
          time: data['time'],
          location: data['location'],
          description: data['description'],
          guestIds: List<int>.from(data['guestIds']),
        );
      }).toList();
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Unknown error has occured',
          statusCode: e.code);
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<Event?> getEvent(String id) async {
    try {
      final doc = await _firestore.collection('events').doc(id).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return Event(
          id: data['id'],
          title: data['title'],
          date: DateTime.parse(data['date']),
          time: data['time'],
          location: data['location'],
          description: data['description'],
          guestIds: List<int>.from(data['guestIds']),
        );
      }
      return null;
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Unknown error has occured',
          statusCode: e.code);
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<void> updateEvent(Event event) async {
    final eventModel = EventModel(
        id: event.id,
        title: event.title,
        date: event.date,
        time: event.time,
        location: event.location,
        description: event.description,
        guestIds: event.guestIds,
    );
    try {
      await _firestore.collection('events').doc(event.id).update(eventModel.toMap());
    } on FirebaseException catch (e) {
      throw APIException(
          message: e.message ?? 'Unknown error has occured',
          statusCode: e.code);
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: '500');
    }
  }
}


