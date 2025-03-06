abstract class DatabaseInterface {
  Future<void> init();
  Future<Map<String, dynamic>> insert(String table, Map<String, dynamic> data);
  Future<List<Map<String, dynamic>>> getAll(String table);
  Future<Map<String, dynamic>?> getById(String table, dynamic id);
  Future<int> update(String table, Map<String, dynamic> data, String where,
      List<dynamic> whereArgs);
  Future<int> delete(String table, String where, List<dynamic> whereArgs);
  Future<List<Map<String, dynamic>>> rawQuery(String sql,
      [List<dynamic>? arguments]);
  Future<void> close();
}
