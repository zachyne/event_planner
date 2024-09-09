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

  @override
  List<Object?> get props => [
    id,
    name,
    contactInfo,
    isRSVP,
  ];
}
