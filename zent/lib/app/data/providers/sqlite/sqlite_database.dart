import 'package:sqflite/sqflite.dart';
import '../interfaces/database_interface.dart';
import 'sqlite_helper.dart';

class SQLiteDatabase implements DatabaseInterface {
  late Database _db;
  final SQLiteHelper _helper = SQLiteHelper();

  @override
  Future<void> init() async {
    _db = await _helper.database;
  }

  @override
  Future<Map<String, dynamic>> insert(
      String table, Map<String, dynamic> data) async {
    // Ensure enviado field is set to false for new local entries
    data['enviado'] = data['enviado'] ?? false;

    final id = await _db.insert(table, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return {...data, 'id': id};
  }

  @override
  Future<List<Map<String, dynamic>>> getAll(String table) async {
    return await _db.query(table);
  }

  @override
  Future<Map<String, dynamic>?> getById(String table, dynamic id) async {
    final result = await _db.query(table, where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  @override
  Future<int> update(String table, Map<String, dynamic> data, String where,
      List<dynamic> whereArgs) async {
    return await _db.update(table, data, where: where, whereArgs: whereArgs);
  }

  @override
  Future<int> delete(
      String table, String where, List<dynamic> whereArgs) async {
    return await _db.delete(table, where: where, whereArgs: whereArgs);
  }

  @override
  Future<List<Map<String, dynamic>>> rawQuery(String sql,
      [List<dynamic>? arguments]) async {
    return await _db.rawQuery(sql, arguments);
  }

  @override
  Future<void> close() async {
    await _db.close();
  }
}
