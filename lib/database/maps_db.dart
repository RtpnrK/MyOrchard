import 'dart:io';

import 'package:myorchard/models/maps_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ProfileDb {
  static final ProfileDb _instance = ProfileDb._internal();
  factory ProfileDb() => _instance;
  ProfileDb._internal();
  List<MapsModel> list_profiles = [];

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "testProfile.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE testProfile (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        image TEXT NOT NULL,
        name TEXT NOT NULL,
        plots TEXT
      )
    ''');
  }

  Future<int> insertProfile(MapsModel profile) async {
    Database db = await database;
    return await db.insert('testProfile', profile.toMap());
  }

  Future<List<MapsModel>> getProfiles() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('testProfile',
        orderBy: 'id DESC');
    list_profiles = maps.map((map) => MapsModel.fromMap(map)).toList();
    // print("${list_profiles[0].plots}");
    return list_profiles;
  }

  Future<int> deleteProfile(int? id) async {
    Database db = await database;
    return await db.delete('testProfile', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateProfile(MapsModel profile) async {
    Database db = await database;
    return await db.update('testProfile', profile.toMap(),
        where: 'id = ?', whereArgs: [profile.id]);
  }
}
