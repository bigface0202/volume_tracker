import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'user_trainings.db'),
        onCreate: (db, version) => _createDb(db), version: 1);
  }

  static void _createDb(Database db) {
    db.execute(
        'CREATE TABLE user_trainings(id TEXT PRIMARY KEY, part TEXT, weights REAL, times REAL, volume REAL, date TEXT)');
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<void> delete(String table, String id) async {
    final db = await DBHelper.database();
    db.delete(
      table,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }
}
