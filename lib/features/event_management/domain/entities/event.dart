// lib/domain/entities/event.dart

import 'package:equatable/equatable.dart';

class Event extends Equatable {
  final String id;
  final String title;
  final DateTime date;
  final String time;
  final String location;
  final String description;
  final List<int> guestIds;

  const Event({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.description,
    required this.guestIds,
  });

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
