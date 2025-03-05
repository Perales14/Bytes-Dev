abstract class IRemoteDataSource {
  Future<List<Map<String, dynamic>>> getAll(String table,
      {Map<String, dynamic>? filters});
  Future<Map<String, dynamic>?> getById(String table, int id);
  Future<Map<String, dynamic>> insert(String table, Map<String, dynamic> data);
  Future<Map<String, dynamic>> update(
      String table, int id, Map<String, dynamic> data);
  Future<void> delete(String table, int id);
  Future<List<Map<String, dynamic>>> executeRpc(String function,
      {Map<String, dynamic>? params});
}
