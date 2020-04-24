import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _dbName = 'pomoDatabase.db';
  static final _dbVersion = 1;

//  static String tableName = 'Title_Work';
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
    return await openDatabase(path, version: _dbVersion);
  }

  Future<dynamic> createTable(String tableName) async {
    Database db = await instance.database;
    return await db.rawQuery('''
    CREATE TABLE IF NOT EXISTS \"$tableName\" (
    $columnDate INTEGER PRIMARY KEY NOT NULL,
    $columnScore INTEGER NOT NULL,
    $columnGoal INTEGER NOT NULL,
    $columnDuration INTEGER NOT NULL
    );
    ''');
  }

  Future<int> insertRecord(String tableName, Map<String, dynamic> row) async {
    Database db = await instance.database;
    await createTable(tableName);
    return await db.insert(tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryRecords(String tableName) async {
    Database db = await instance.database;
    return await db.query(tableName);
  }

  Future updateRecord(String tableName, Map<String, dynamic> row) async {
    Database db = await instance.database;
    int date = row[columnDate];
    return await db
        .update(tableName, row, where: '$columnDate = ?', whereArgs: [date]);
  }

  Future<int> deleteRecord(String tableName, int date) async {
    Database db = await instance.database;
    return await db
        .delete(tableName, where: '$columnDate = ?', whereArgs: [date]);
  }
}
