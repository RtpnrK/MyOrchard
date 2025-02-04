// Used by: lib/database/database.dart, lib/screens/home.dart, lib/screens/map.dart, lib/screens/pin.dart, lib/screens/pinList.dart, lib/screens/pinMap.dart, lib/screens/pinMapList.dart, lib/screens/pinMapList2.dart, lib/screens/pinMapList3.dart, lib/screens/pinMapList4.dart, lib/screens/pinMapList5.dart, lib/screens/pinMapList6.dart, lib/screens/pinMapList7.dart, lib/screens/pinMapList8.dart, lib/screens/pinMapList9.dart, lib/screens/pinMapList10.dart, lib/screens/pinMapList11.dart, lib/screens/pinMapList12.dart, lib/screens/pinMapList13.dart, lib/screens/pinMapList14.dart, lib/screens/pinMapList15.dart, lib/screens/pinMapList16.dart, lib/screens/pinMapList17.dart, lib/screens/pinMapList18.dart, lib/screens/pinMapList19.dart, lib/screens/pinMapList20.dart, lib/screens/pinMapList21.dart, lib/screens/pinMapList22.dart, lib/screens/pinMapList23.dart, lib/screens/pinMapList24.dart, lib/screens/pinMapList25.dart, lib/screens/pinMapList26.dart, lib/screens/pinMapList27.dart, lib/screens/pinMapList28.dart, lib/screens/pinMapList29.dart, lib/screens/pinMapList30.dart, lib/screens/pinMapList31.dart, lib/screens/pinMapList32.dart, lib/screens/pinMapList33.dart, lib/screens/pinMapList34.dart, lib/screens/pinMapList35.dart, lib/screens/pinMapList36.dart, lib/screens/pinMapList37.dart, lib/screens/pinMapList38.dart, lib/screens/pinMapList39.dart, lib/screens/pinMapList40.dart, lib/screens/pinMapList41.dart, lib/screens/pinMapList42.dart, lib/screens/pinMapList43.dart, lib/screens/pinMapList44.dart, lib/screens/pinMapList45.dart, lib/screens/pinMapList46.dart, lib/screens/pinMapList47.dart, lib/screens/pinMapList48.dart, lib/screens/pinMapList49.dart, lib/screens/pinMapList50.dart, lib/screens/pinMapList51.dart, lib/screens

class PinM {
  int? id;
  double latitude;
  double longitude;
  double offsetX;
  double offsetY;
  String color;
  

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
