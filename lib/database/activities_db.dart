import 'dart:io';

import 'package:myorchard/models/activities_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ActivitiesDb {
  static final ActivitiesDb _instance = ActivitiesDb._internal();
  factory ActivitiesDb() => _instance;
  ActivitiesDb._internal();
  List<ActivitiesModel> listActivities = [];

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "testActivities3.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE testActivities3 (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        profileId int NOT NULL,
        tree TEXT,
        plot TEXT,
        details TEXT,
        activity TEXT,
        image TEXT,
        date TEXT NOT NULL,
        executor TEXT NOT NULL,
        FOREIGN KEY (profileId) REFERENCES testProfile(id)
      )
    ''');
  }

  Future<List<ActivitiesModel>> getActivities(int profileId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('testActivities3',
        where: 'profileId = ?', whereArgs: [profileId],
        orderBy: 'id DESC');
    listActivities = maps.map((map) => ActivitiesModel.fromMap(map)).toList();
    return listActivities;
  }

  Future<int> insertActivity(ActivitiesModel profile) async {
    Database db = await database;
    return await db.insert('testActivities3', profile.toMap());
  }

  Future<int> deleteActivities(int? id) async {
    Database db = await database;
    return await db.delete('testActivities3', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateActivities(ActivitiesModel activity) async {
    Database db = await database;
    return await db.update('testActivities3', activity.toMap(),
        where: 'id = ?', whereArgs: [activity.id]);
  }
}
