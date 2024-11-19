// lib/domain/entities/event.dart

import 'package:equatable/equatable.dart';

class Event extends Equatable {
  final String id;
  final String title;
  final DateTime date;
  final String time;
  final String location;
  final String description;
  final List<String> guestIds;

  const Event({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.description,
    required this.guestIds,
  });

  Event copyWith({
    String? id,
    String? title,
    DateTime? date,
    String? time,
    String? location,
    String? description,
    List<String>? guestIds,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      time: time ?? this.time,
      location: location ?? this.location,
      description: description ?? this.description,
      guestIds: guestIds ?? this.guestIds,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    date,
    time,
    location,
    description,
    guestIds,
  ];
}
