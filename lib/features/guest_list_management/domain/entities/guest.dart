// lib/domain/entities/guest.dart

import 'package:equatable/equatable.dart';

class Guest extends Equatable {
  final String id;
  final String name;
  final String contactInfo;
  final bool isRSVP;

  const Guest({
    required this.id,
    required this.name,
    required this.contactInfo,
    required this.isRSVP,
  });

  Guest copyWith({
    String? id,
    String? name,
    String? contactInfo,
    bool? isRSVP,
  }) {
    return Guest(
      id: id ?? this.id,
      name: name ?? this.name,
      contactInfo: contactInfo ?? this.contactInfo,
      isRSVP: isRSVP ?? this.isRSVP,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    contactInfo,
    isRSVP,
  ];
}
