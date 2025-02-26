import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myorchard/database/chats_db.dart';
import 'package:myorchard/models/chat_model.dart';

class ChatsProvider extends ChangeNotifier {
  List<ChatModel> listChats = []; // เก็บข้อมูลกิจกรรม

  ChatsProvider(int profileId) {
    loadChats(profileId);
    //print("ActivityProvider = ${listActivities.length}");// โหลดข้อมูลเมื่อ Provider ถูกสร้าง
  }

  // โหลดข้อมูลจากฐานข้อมูล
  Future<void> loadChats(int profileId) async {
    listChats = await ChatsDb().getChats(profileId); // ดึงข้อมูลจากฐานข้อมูล
    notifyListeners(); // แจ้งเตือนให้ UI อัปเดต
    print("loadedChats");
  }

  // รีเฟรชข้อมูล
  Future<void> refreshChats(int profileId) async {
    await loadChats(profileId); // ใช้ loadProfiles() เพื่อดึงข้อมูลใหม่
    print("reloaded Chats");
  }

  // เพิ่มกิจกรรม
  Future<void> addChat(ChatModel newChat) async {
    try {
      ;

      await ChatsDb().insertChat(newChat); // บันทึกลงฐานข้อมูล
      await loadChats(
          newChat.profileId); // โหลดข้อมูลใหม่เพื่อให้แน่ใจว่าอัปเดตแล้ว
      print("เพิ่มกิจกรรมสำเร็จ : ${newChat.message}");

      // print("Activity_provider = ${listActivities.}");
    } catch (e) {
      print("เกิดข้อผิดพลาดในการเพิ่มกิจกรรม: $e");
    }
  }

  // ลบกิจกรรม
  Future<void> removeChat(ChatModel chat) async {
    try {
      await ChatsDb().deleteChat(chat.id); // ลบออกจากฐานข้อมูล
      await loadChats(chat.profileId); // โหลดข้อมูลใหม่เพื่ออัปเดต UI
      print("ลบกิจกรรมสำเร็จ");
    } catch (e) {
      print("เกิดข้อผิดพลาดในการลบกิจกรรม: $e");
    }
  }
}
