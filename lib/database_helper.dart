import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _dbName = 'pomoDatabase.db';
  static final _dbVersion = 1;

  static final tableName = 'Big_Table';
  static final columnTitle = 'title';
  static final columnDate = 'date';
  static final columnScore = 'score';
  static final columnGoal = 'goal';
  static final columnDuration = 'duration';

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<dynamic> get database async {
    if (_database == null) {
      _database = await _initiateDatabase();
    }
    return _database;
  }

  void printVer(String tableName) async {
    Database db = await instance.database;

    try {
//      createTable('first');
      db.rawQuery('SELECT name FROM sqlite_master WHERE type=\'table\';');
    } catch (Exception) {
      print('does not exist');
    }
  }

  _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    db = await instance.database;
    return await db.rawQuery('''
    CREATE TABLE IF NOT EXISTS \"$tableName\" (
    $columnTitle TEXT NOT NULL,
    $columnDate INTEGER NOT NULL,
    $columnScore INTEGER NOT NULL,
    $columnGoal INTEGER NOT NULL,
    $columnDuration INTEGER NOT NULL
    );
    ''');
  }

  Future<int> insertRecord(Map<String, dynamic> row) async { // todo don't insert duplicate
    Database db = await instance.database;
    return await db.insert(tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryRecords() async {
    Database db = await instance.database;
    return await db.query(tableName);
  }

  Future updateRecord(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int date = row[columnDate];
    String title = row[columnTitle];
    return await db
        .update(tableName, row, where: '$columnDate = ? AND $columnTitle = ?', whereArgs: [date, title]);
  }

  Future<int> deleteRecord(String title, int date) async {
    Database db = await instance.database;
    return await db
        .delete(tableName, where: '$columnDate = ? AND $columnTitle = ?', whereArgs: [date, title]);
  }
}
