// pin.dart
import 'dart:ui';

import 'package:flutter/material.dart';

class PinM {
  int? id;
  double latitude;
  double longitude;
  double offsetX;
  double offsetY;
  Color color;
  

  PinM({
    this.id,
    required this.latitude,
    required this.longitude,
    required this.offsetX,
    required this.offsetY,
    required this.color,
   
  });

  // Convert a Pin into a Map. The keys must correspond to the names of the columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'offsetX': offsetX,
      'offsetY': offsetY,
      'color': color,
      
    };
  }

  // Extract a Pin object from a Map.
  factory PinM.fromMap(Map<String, dynamic> map) {
    return PinM(
      id: map['id'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      offsetX: map['offsetX'],
      offsetY: map['offsetY'],
      color: map['color'],
      
    );
  }

   
}
