import 'dart:convert';

class MapsModel {
  int? id;
  String image;
  String name;
  List? plots = [];

  MapsModel({
    this.id,
    required this.image,
    required this.name,
    this.plots = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'plots': jsonEncode(plots), // แปลงลิสต์เป็น JSON String
    };
  }

   factory MapsModel.fromMap(Map<String, dynamic> map) {
    return MapsModel(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      plots: List<String>.from(jsonDecode(map['plots'])), // แปลง JSON String กลับเป็นลิสต์
    );
  }
}

