abstract class ILocalDataSource {
  Future<List<Map<String, dynamic>>> getAll(String table,
      {String? where, List<dynamic>? whereArgs});
  Future<Map<String, dynamic>?> getById(String table, int id);
  Future<int> insert(String table, Map<String, dynamic> data);
  Future<int> update(String table, int id, Map<String, dynamic> data);
  Future<int> delete(String table, int id);
  Future<int> markAsSent(String table, int id);
  Future<List<Map<String, dynamic>>> getPendingToSync(String table);
  Future<List<Map<String, dynamic>>> executeRawQuery(String query,
      [List<dynamic>? arguments]);
  Future<void> executeTransaction(Function(dynamic batch) action);
}
