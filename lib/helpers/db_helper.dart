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
    db.execute(
        'CREATE TABLE user_volumes(id TEXT PRIMARY KEY, date TEXT, shoulder REAL, chest REAL, biceps REAL, triceps REAL, arm REAL, back REAL, abdominal REAL, leg REAL)');
    db.execute('CREATE TABLE user_info(id TEXT PRIMARY KEY, bodyweight REAL)');
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    // print("this is add");
    // print(await db.query(table));
  }

  static Future<void> delete(String table, String id) async {
    final db = await DBHelper.database();
    db.delete(
      table,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  static Future<void> deleteMultiple(String table, List<String> idList) async {
    final db = await DBHelper.database();
    Batch batch = db.batch();
    idList.forEach((id) {
      batch.delete(
        table,
        where: "id = ?",
        whereArgs: [id],
      );
    });
    await batch.commit();
    // print("this is delete");
    // print(await db.query(table));
  }

  static Future<void> update(
      String table, String id, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.update(
      table,
      data,
      where: "id = ?",
      whereArgs: [id],
    );
    // print("this is update");
    // print(await db.query(table));
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }
}
