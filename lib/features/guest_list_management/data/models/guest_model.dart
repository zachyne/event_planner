import 'dart:convert';

import 'package:event_planner/features/guest_list_management/domain/entities/guest.dart';


class GuestModel extends Guest {
  const GuestModel({
    required super.id, 
    required super.name, 
    required super.contactInfo, 
    required super.isRSVP
    });

    // Method to create a GuestModel from a Map
    factory GuestModel.fromMap(Map<String, dynamic> map) {
      return GuestModel(
        id: map['id'],
        name: map['name'],
        contactInfo: map['contactInfo'],
        isRSVP: map['isRSVP'],
      );
    }

    // Method to create a GuestModel from JSON
    factory GuestModel.fromJson(String source) {
      return GuestModel.fromMap(json.decode(source));
    }

    // Method to convert a GuestModel to a Map
    Map<String, dynamic> toMap() {
      return {
        'id': id,
        'name': name,
        'contactInfo': contactInfo,
        'isRSVP': isRSVP,
      };
    }

    // Method to convert a GuestModel to JSON
    String toJson() {
      return json.encode(toMap());
    }
}

