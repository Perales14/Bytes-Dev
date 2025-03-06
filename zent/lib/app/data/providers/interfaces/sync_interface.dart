abstract class SyncInterface {
  Future<void> syncToRemote(String table, Map<String, dynamic> data);
  Future<List<Map<String, dynamic>>> syncFromRemote(String table,
      {String? lastSyncTimestamp});
  Future<bool> isOnline();
  Future<void> markAsSynced(String table, dynamic id);
}
