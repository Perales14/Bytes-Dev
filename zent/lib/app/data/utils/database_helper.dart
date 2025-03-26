import '../providers/supabase/supabase_database.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  final SupabaseDatabase _supabaseDatabase = SupabaseDatabase();

  // Singleton pattern
  DatabaseHelper._internal();

  // Initialize database
  Future<void> init() async {
    await _supabaseDatabase.init();
  }

  // Proxy methods to SupabaseDatabase
  Future<Map<String, dynamic>> insert(
      String table, Map<String, dynamic> data) async {
    return await _supabaseDatabase.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> getAll(String table) async {
    return await _supabaseDatabase.getAll(table);
  }

  Future<Map<String, dynamic>?> getById(String table, dynamic id) async {
    return await _supabaseDatabase.getById(table, id);
  }

  Future<int> update(String table, Map<String, dynamic> data, String where,
      List<dynamic> whereArgs) async {
    return await _supabaseDatabase.update(table, data, where, whereArgs);
  }

  Future<int> delete(
      String table, String where, List<dynamic> whereArgs) async {
    return await _supabaseDatabase.delete(table, where, whereArgs);
  }

  Future<List<Map<String, dynamic>>> query(
      String table, String where, List<dynamic> whereArgs) async {
    return await _supabaseDatabase.query(table, where, whereArgs);
  }
}
