import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'models/card_model.dart';

class DB {
  static final _dbName = 'pomoDatabase1.db';
  static final _dbVersion = 1;
  static final _tableName = 'Big_Table';

  static final columnID = 'id';
  static final columnTitle = 'title';
  static final columnDate = 'date';
  static final columnScore = 'score';
  static final columnGoal = 'goal';
  static final columnMinutes = 'minutes';

  DB._privateConstructor();

  static final DB instance = DB._privateConstructor();

  static Database _database;

  Future<dynamic> get database async {
    if (_database == null) {
      _database = await _initiateDatabase();
    }
    return _database;
  }

  _initiateDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    return await db.rawQuery('''
    CREATE TABLE IF NOT EXISTS \"$_tableName\" (
    $columnID INTEGER PRIMARY KEY,
    $columnDate TEXT NOT NULL,
    $columnScore INTEGER NOT NULL,
    $columnGoal INTEGER NOT NULL,
    $columnMinutes INTEGER NOT NULL,
    $columnTitle TEXT NOT NULL
    );
    ''');
  }

  recreateTable() async {
    Database db = await instance.database;
    await db.rawQuery('drop table $_tableName');
    await _onCreate(db, _dbVersion);
    var tables = await db
        .rawQuery('SELECT name FROM sqlite_master WHERE type=\'table\';');
    print('tables: $tables');
    print('New table created');
  }

  rando() async {
    Database db = await instance.database;
  }

  Future<List<Map<String, dynamic>>> queryRecords() async {
    Database db = await instance.database;
    return await db.query(_tableName);
  }

  Future<List<Map<String, dynamic>>> queryModelsWithDate(String date) async { // gets all models with one date
    Database db = await instance.database;
    var query = '''
      SELECT * FROM $_tableName WHERE $columnDate = \'$date\';
    ''';
    return await db.rawQuery(query);
  }

  Future<List<Map<String, dynamic>>> queryDatesWithModel(String title) async { // gets one model with all dates
    Database db = await instance.database;
    var query = '''
      SELECT * FROM $_tableName WHERE $columnTitle = \'$title\';
    ''';
    return await db.rawQuery(query);
  }


  Future insertOrUpdateRecord(Map<String, dynamic> row) async {
    Database db = await instance.database;
    String date = row[columnDate];
    String title = row[columnTitle];
    var update = await db.update(_tableName, row,
        where: '$columnDate = ? AND $columnTitle = ?',
        whereArgs: [date, title]);

    if (update > 0)
      return update;
    else
      return await db.insert(_tableName, row);
  }

  Future<int> deleteRecord(String title, String date) async {
    Database db = await instance.database;
    return await db.delete(_tableName,
        where: '$columnDate = ? AND $columnTitle = ?',
        whereArgs: [date, title]);
  }
}
