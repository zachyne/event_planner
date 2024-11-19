import 'dart:convert';

import 'package:event_planner/features/event_management/domain/entities/event.dart';

class EventModel extends Event {
  const EventModel({
    required super.id,
    required super.title,
    required super.date,
    required super.time,
    required super.location,
    required super.description,
    required super.guestIds,
  });

  // Method to create an EventModel from a Map
  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      // remove 'to String' if shows error
      id: map['id'].toString(),
      title: map['title'],
      date: DateTime.parse(map['date']),
      time: map['time'],
      location: map['location'],
      description: map['description'],
      guestIds: List<String>.from(map['guestIds'].map((id) => id.toString())),
    );
  }

  // Method to create an EventModel from JSON
  factory EventModel.fromJson(String source) {
    return EventModel.fromMap(json.decode(source));
  }

  // Method to convert an EventModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'time': time,
      'location': location,
      'description': description,
      'guestIds': guestIds,
    };
  }

  // Method to convert an EventModel to JSON
  String toJson() {
    return json.encode(toMap());
  }
}
