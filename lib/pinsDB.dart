// database_helper.dart
import 'dart:async';
import 'dart:io';
import 'package:myorchard/model/pinModel.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  // Initialize the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Open the database and create table if it doesn't exist
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "pins_New.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create the pins table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE pins_New (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        offsetX REAL NOT NULL,
        offsetY REAL NOT NULL,
        color TEXT NOT NULL
        
      )
    ''');
  }

  // Insert a new pin
  Future<int> insertPin(PinM pin) async {
    Database db = await database;
    return await db.insert('pins_New', pin.toMap());
  }

  // Retrieve all pins
  Future<List<PinM>> getPins() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('pins_New');
    return maps.map((map) => PinM.fromMap(map)).toList();
  }

  // Delete a pin
  Future<int> deletePin(int id) async {
    Database db = await database;
    return await db.delete('pins_New', where: 'id = ?', whereArgs: [id]);
  }

  // Update a pin
  Future<int> updatePin(PinM pin) async {
    Database db = await database;
    return await db
        .update('pins_New', pin.toMap(), where: 'id = ?', whereArgs: [pin.id]);
  }
}
