import 'package:flutter/foundation.dart';
import 'package:myorchard/database/pins_db.dart';
import 'package:myorchard/models/pinModel.dart';

class PinsProvider extends ChangeNotifier {
  List<PinM> listPins = [];

  PinsProvider(int profileId) {
    loadPins(profileId);
  }

  // โหลดข้อมูลจากฐานข้อมูล
  Future<void> loadPins(int profileId) async {
    listPins = await PinsDb().getPins(profileId); // ดึงข้อมูลจากฐานข้อมูล
    notifyListeners(); // แจ้งเตือนให้ UI อัปเดต
    print("loaded Pins");
  }

  // รีเฟรชข้อมูล
  Future<void> refreshPins(int profileId) async {
    await loadPins(profileId); // เพื่อดึงข้อมูลใหม่
    print("reloaded Pins");
  }

  // เพิ่มกิจกรรม
  Future<void> addPin(int profileId, double latitude, double longitude,
      double offsetX, double offsetY, String color, double accuracy) async {
    try {
      final newPins = PinM(
        profileId: profileId,
        latitude: latitude,
        longitude: longitude,
        offsetX: offsetX,
        offsetY: offsetY,
        color: color,
        accuracy: accuracy
      );

      await PinsDb().insertPin(newPins); // บันทึกลงฐานข้อมูล
      await loadPins(profileId); // โหลดข้อมูลใหม่เพื่อให้แน่ใจว่าอัปเดตแล้ว
      print("เพิ่มกิจกรรมสำเร็จ : ${newPins.color}");

     
    } catch (e) {
      print("เกิดข้อผิดพลาดในการเพิ่มกิจกรรม: $e");
    }
  }

  // ลบกิจกรรม
  Future<void> removePin(PinM pin) async {
    try {
      await PinsDb().deletePin(pin.id); // ลบออกจากฐานข้อมูล
      await loadPins(pin.profileId); // โหลดข้อมูลใหม่เพื่ออัปเดต UI
      print("ลบกิจกรรมสำเร็จ");
    } catch (e) {
      print("เกิดข้อผิดพลาดในการลบกิจกรรม: $e");
    }
  }

   Future<void> updatePin(PinM pin) async {
    try {
      await PinsDb().updatePin(pin); // ลบออกจากฐานข้อมูล
      await loadPins(pin.profileId);
      notifyListeners(); // โหลดข้อมูลใหม่เพื่ออัปเดต UI
      print("แก้ไขกิจกรรมสำเร็จ");
    } catch (e) {
      print("เกิดข้อผิดพลาดในการแก้ไขกิจกรรม: $e");
    }
  }
}
