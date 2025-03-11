import 'dart:convert';

class MapsModel {
  int? id;
  String image;
  String name;
  List? plots = [];
  List<String>? activitiesSet;

  MapsModel({
    this.id,
    required this.image,
    required this.name,
    this.plots = const [],
    this.activitiesSet = const []
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'plots': jsonEncode(plots),
      'activitiesSet': jsonEncode(activitiesSet) // แปลงลิสต์เป็น JSON String
    };
  }

   factory MapsModel.fromMap(Map<String, dynamic> map) {
    return MapsModel(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      plots: map['plots'] != null
          ? List<String>.from(jsonDecode(map['plots']))
          : [],
      activitiesSet: map['activitiesSet'] != null
          ? List<String>.from(jsonDecode(map['activitiesSet']))
          : [
            'อื่นๆ(ระบุ)', 'ใส่ปุ๋ย', 'รดน้ำ', 'ใส่ยา', 'พรวนดิน', 'ตัดหญ้า'
          ],
    );
  }
}

