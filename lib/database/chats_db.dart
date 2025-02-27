import 'dart:io';

import 'package:myorchard/models/chat_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ChatsDb {
  static final ChatsDb _instance = ChatsDb._internal();
  factory ChatsDb() => _instance;
  ChatsDb._internal();
  List<ChatModel> listChats = [];

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "testChats.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE testChats (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        message TEXT NOT NULL,
        time TEXT NOT NULL,
        profileId INTEGER NOT NULL,
        date TEXT NOT NULL,
        FOREIGN KEY (profileId) REFERENCES testProfile(id)
      )
    ''');
  }

  Future<List<ChatModel>> getChats(int profileId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('testChats',
        where: 'profileId = ?', whereArgs: [profileId],);
    listChats = maps.map((map) => ChatModel.fromMap(map)).toList();
    return listChats;
  }

  Future<int> insertChat(ChatModel chat) async {
    Database db = await database;
    return await db.insert('testChats', chat.toMap());
  }

  Future<int> deleteChat(int? id) async {
    Database db = await database;
    return await db.delete('testChats', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateChat(ChatModel chat) async {
    Database db = await database;
    return await db.update('testChats', chat.toMap(),
        where: 'id = ?', whereArgs: [chat.profileId]);
  }
}
