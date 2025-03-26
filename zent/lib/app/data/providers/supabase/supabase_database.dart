import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_client.dart';

class SupabaseDatabase {
  late final SupabaseClient _client;
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      await initialize();
    }
  }

  Future<void> initialize() async {
    if (!_initialized) {
      final manager = await SupabaseClientManager.instance;
      _client = manager.client;
      _initialized = true;
    }
  }

  // Insert data
  Future<Map<String, dynamic>> insert(
      String table, Map<String, dynamic> data) async {
    await initialize();
    final response = await _client.from(table).insert(data).select().single();
    return response;
  }

  // Get all records
  Future<List<Map<String, dynamic>>> getAll(String table) async {
    await initialize();
    final response = await _client.from(table).select();
    return List<Map<String, dynamic>>.from(response);
  }

  // Get by ID
  Future<Map<String, dynamic>?> getById(String table, dynamic id) async {
    try {
      await initialize();
      final response =
          await _client.from(table).select().eq('id', id).maybeSingle();
      return response;
    } catch (e) {
      print('Error fetching $table with ID $id: $e');
      return null;
    }
  }

  // Update
  Future<int> update(String table, Map<String, dynamic> data, String where,
      List<dynamic> whereArgs) async {
    await initialize();
    final fieldName = where.split(' ')[0];
    final value = whereArgs[0];
    await _client.from(table).update(data).eq(fieldName, value);
    return 1;
  }

  // Delete
  Future<int> delete(
      String table, String where, List<dynamic> whereArgs) async {
    await initialize();
    final fieldName = where.split(' ')[0];
    final value = whereArgs[0];
    await _client.from(table).delete().eq(fieldName, value);
    return 1;
  }

  // Custom query
  Future<List<Map<String, dynamic>>> query(
      String table, String where, List<dynamic> whereArgs) async {
    try {
      await initialize();
      var query = _client.from(table).select();

      if (where.isNotEmpty && whereArgs.isNotEmpty) {
        final conditions = where.split(' AND ');

        for (int i = 0; i < conditions.length; i++) {
          final condition = conditions[i].trim();
          final parts = condition.split(' ');

          if (parts.length >= 3) {
            final field = parts[0];
            final operator = parts[1];
            final value = whereArgs[i];

            switch (operator) {
              case '=':
                query = query.eq(field, value);
                break;
              case '>':
                query = query.gt(field, value);
                break;
              case '>=':
                query = query.gte(field, value);
                break;
              case '<':
                query = query.lt(field, value);
                break;
              case '<=':
                query = query.lte(field, value);
                break;
              case '!=':
                query = query.neq(field, value);
                break;
              case 'LIKE':
                query = query.like(field, '%$value%');
                break;
              default:
                throw Exception('Unsupported operator: $operator');
            }
          }
        }
      }

      final response = await query;
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Query error: $e');
    }
  }
}
