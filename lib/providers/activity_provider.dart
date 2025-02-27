import 'package:flutter/material.dart';
import 'package:myorchard/database/activities_db.dart';
import 'package:myorchard/models/activities_model.dart';

class ActivityProvider extends ChangeNotifier {
  List<ActivitiesModel> listActivities = []; // เก็บข้อมูลกิจกรรม

  ActivityProvider(int profileId) {
    loadActivities(profileId);
    //print("ActivityProvider = ${listActivities.length}");// โหลดข้อมูลเมื่อ Provider ถูกสร้าง
  }

  // โหลดข้อมูลจากฐานข้อมูล
  Future<void> loadActivities(int profileId) async {
    listActivities =
        await ActivitiesDb().getActivities(profileId); // ดึงข้อมูลจากฐานข้อมูล
    notifyListeners(); // แจ้งเตือนให้ UI อัปเดต
    print("loadedActivities");
  }

  // รีเฟรชข้อมูล
  Future<void> refreshActivities(int profileId) async {
    await loadActivities(profileId); // ใช้ loadProfiles() เพื่อดึงข้อมูลใหม่
    print("reloaded Activity");
  }

  // เพิ่มกิจกรรม
  Future<void> addActivity(
      String? image, tree, details, activity, date, plot, int profileId) async {
    try {
      final newActivity = ActivitiesModel(
          image: image,
          tree: tree,
          details: details,
          activity: activity,
          plot: plot,
          date: date,
          profileId: profileId);

      await ActivitiesDb().insertActivity(newActivity); // บันทึกลงฐานข้อมูล
      await loadActivities(
          profileId); // โหลดข้อมูลใหม่เพื่อให้แน่ใจว่าอัปเดตแล้ว
      print("เพิ่มกิจกรรมสำเร็จ");

      // print("Activity_provider = ${listActivities.}");
    } catch (e) {
      print("เกิดข้อผิดพลาดในการเพิ่มกิจกรรม: $e");
    }
  }

  // ลบกิจกรรม
  Future<void> removeActivity(ActivitiesModel activity) async {
    try {
      await ActivitiesDb().deleteActivities(activity.id); // ลบออกจากฐานข้อมูล
      await loadActivities(activity.profileId); // โหลดข้อมูลใหม่เพื่ออัปเดต UI
      print("ลบกิจกรรมสำเร็จ");
    } catch (e) {
      print("เกิดข้อผิดพลาดในการลบกิจกรรม: $e");
    }
  }

  Future<void> updateActivity(ActivitiesModel activity) async {
    try {
      await ActivitiesDb().updateActivities(activity); // ลบออกจากฐานข้อมูล
      await loadActivities(activity.profileId);
      notifyListeners();
      print("${activity.tree}"); // โหลดข้อมูลใหม่เพื่ออัปเดต UI
      print("แก้ไขกิจกรรมสำเร็จ");
    } catch (e) {
      print("เกิดข้อผิดพลาดในการแก้ไขกิจกรรม: $e");
    }
  }
}
