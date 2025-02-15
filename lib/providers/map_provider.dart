import 'package:flutter/material.dart';
import 'package:myorchard/models/maps_model.dart';
import 'package:myorchard/database/maps_db.dart';

class MapProvider extends ChangeNotifier {
  List<MapsModel> list_profiles = []; // เก็บข้อมูลโปรไฟล์

  ProfileProvider() {
    loadProfiles(); // โหลดข้อมูลเมื่อ Provider ถูกสร้าง
  }

  // โหลดข้อมูลจากฐานข้อมูล
  Future<void> loadProfiles() async {
    list_profiles = await ProfileDb().getProfiles(); // ดึงข้อมูลจากฐานข้อมูล
    notifyListeners(); // แจ้งเตือนให้ UI อัปเดต
  }

  // รีเฟรชข้อมูล
  Future<void> refreshProfiles() async {
    await loadProfiles(); // ใช้ loadProfiles() เพื่อดึงข้อมูลใหม่
    print("reloaded");
  }

  // เพิ่มโปรไฟล์
  Future<void> addProfile(String image, String name, List plot) async {
    try {
      final newProfile = MapsModel(image: image, name: name, plots: plot);

      await ProfileDb().insertProfile(newProfile); // บันทึกลงฐานข้อมูล
      await loadProfiles(); // โหลดข้อมูลใหม่เพื่อให้แน่ใจว่าอัปเดตแล้ว
      print("เพิ่มโปรไฟล์สำเร็จ");
    } catch (e) {
      print("เกิดข้อผิดพลาดในการเพิ่มโปรไฟล์: $e");
    }
  }

  // ลบโปรไฟล์
  Future<void> removeProfile(MapsModel map) async {
    try {
      await ProfileDb().deleteProfile(map.id); // ลบออกจากฐานข้อมูล
      await loadProfiles(); // โหลดข้อมูลใหม่เพื่ออัปเดต UI
      print("ลบโปรไฟล์สำเร็จ");
    } catch (e) {
      print("เกิดข้อผิดพลาดในการลบโปรไฟล์: $e");
    }
  }

  Future<void> updateProfile(MapsModel map) async {
    try {
      await ProfileDb().updateProfile(map); // ลบออกจากฐานข้อมูล
      await loadProfiles();
      print("${map.plots}"); // โหลดข้อมูลใหม่เพื่ออัปเดต UI
      print("แก้ไขไฟล์สำเร็จ");
    } catch (e) {
      print("เกิดข้อผิดพลาดในการแก้ไขโปรไฟล์: $e");
    }
  }
}
