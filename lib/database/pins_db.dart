// database_helper.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:myorchard/models/pinModel.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class PinsDb {
  // Singleton instance
  static final PinsDb _instance = PinsDb._internal();
  factory PinsDb() => _instance;
  PinsDb._internal();
  static Database? _database;

  List<PinM> listPins = [];

  // Initialize the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Open the database and create table if it doesn't exist
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "testPins.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create the pins table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE testPins (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        profileId INTEGER NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        offsetX REAL NOT NULL,
        offsetY REAL NOT NULL,
        color TEXT NOT NULL,
        FOREIGN KEY (profileId) REFERENCES testProfile(id)
      )
    ''');
  }

  // Insert a new pin
  Future<int> insertPin(PinM pin) async {
    Database db = await database;
    return await db.insert('testPins', pin.toMap());
  }

  // Retrieve all pins
  Future<List<PinM>> getPins(int? profileId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db
        .query('testPins', where: 'profileId = ?', whereArgs: [profileId]);
    listPins = maps.map((map) => PinM.fromMap(map)).toList();

    return listPins;
  }

  Future<int> deleteAllPins() async {
    Database db = await database;
    debugPrint("Delete All Pins");
    return await db.delete('testPins'); // ไม่มีเงื่อนไข จะลบข้อมูลทั้งหมด
  }

  // Delete a pin
  Future<int> deletePin(int? id) async {
    Database db = await database;
    return await db.delete('testPins', where: 'id = ?', whereArgs: [id]);
  }

  // Update a pin
  Future<int> updatePin(PinM pin) async {
    Database db = await database;
    return await db
        .update('testPins', pin.toMap(), where: 'id = ?', whereArgs: [pin.id]);
  }
}
