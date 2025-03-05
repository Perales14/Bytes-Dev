import 'package:sqflite/sqflite.dart';
import 'package:zent/core/database/database_helper.dart';
import 'package:zent/data/sources/local/interfaces/i_local_datasource.dart';

class SQLiteDataSource implements ILocalDataSource {
  @override
  Future<List<Map<String, dynamic>>> getAll(String table,
      {String? where, List<dynamic>? whereArgs}) async {
    final db = await DatabaseHelper.database;
    return await db.query(table, where: where, whereArgs: whereArgs);
  }

  @override
  Future<Map<String, dynamic>?> getById(String table, int id) async {
    final db = await DatabaseHelper.database;
    final results = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  @override
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await DatabaseHelper.database;

    // Asegurar que los campos de fecha estén actualizados
    data['updated_at'] = DateTime.now().toIso8601String();
    if (!data.containsKey('created_at')) {
      data['created_at'] = data['updated_at'];
    }

    return await db.insert(table, data);
  }

  @override
  Future<int> update(String table, int id, Map<String, dynamic> data) async {
    final db = await DatabaseHelper.database;

    // Actualizar timestamp
    data['updated_at'] = DateTime.now().toIso8601String();

    return await db.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> delete(String table, int id) async {
    final db = await DatabaseHelper.database;
    return await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> markAsSent(String table, int id) async {
    final db = await DatabaseHelper.database;
    return await db.update(
      table,
      {'enviado': 1, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getPendingToSync(String table) async {
    final db = await DatabaseHelper.database;
    return await db.query(
      table,
      where: 'enviado = ?',
      whereArgs: [0],
    );
  }

  @override
  Future<List<Map<String, dynamic>>> executeRawQuery(String query,
      [List<dynamic>? arguments]) async {
    final db = await DatabaseHelper.database;
    return await db.rawQuery(query, arguments);
  }

  @override
  Future<void> executeTransaction(Function(dynamic batch) action) async {
    final db = await DatabaseHelper.database;
    final batch = db.batch();

    action(batch);

    await batch.commit(noResult: false);
  }
}
