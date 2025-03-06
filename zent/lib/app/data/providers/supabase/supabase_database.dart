import 'package:supabase_flutter/supabase_flutter.dart';
import '../interfaces/database_interface.dart';

class SupabaseDatabase implements DatabaseInterface {
  late final SupabaseClient _client;
  bool _initialized = false;

  @override
  Future<void> init() async {
    if (!_initialized) {
      _client = Supabase.instance.client;
      _initialized = true;
    }
  }

  @override
  Future<Map<String, dynamic>> insert(
      String table, Map<String, dynamic> data) async {
    final response = await _client.from(table).insert(data).select().single();
    return response;
  }

  @override
  Future<List<Map<String, dynamic>>> getAll(String table) async {
    final response = await _client.from(table).select();
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Future<Map<String, dynamic>?> getById(String table, dynamic id) async {
    final response =
        await _client.from(table).select().eq('id', id).maybeSingle();
    return response;
  }

  @override
  Future<int> update(String table, Map<String, dynamic> data, String where,
      List<dynamic> whereArgs) async {
    final fieldName = where.split(' ')[0];
    final value = whereArgs[0];
    await _client.from(table).update(data).eq(fieldName, value);
    return 1; // Supabase no devuelve el conteo exacto de filas afectadas
  }

  @override
  Future<int> delete(
      String table, String where, List<dynamic> whereArgs) async {
    final fieldName = where.split(' ')[0];
    final value = whereArgs[0];
    await _client.from(table).delete().eq(fieldName, value);
    return 1; // Supabase no devuelve el conteo exacto de filas afectadas
  }

  @override
  Future<List<Map<String, dynamic>>> rawQuery(String sql,
      [List<dynamic>? arguments]) async {
    // Supabase no soporta consultas SQL directas a través del cliente
    // Se podrían usar funciones PostgreSQL o llamadas RPC para consultas complejas
    throw UnimplementedError(
        'Raw queries not supported directly in Supabase client');
  }

  @override
  Future<void> close() async {
    // No se necesita cerrar explícitamente el cliente de Supabase
  }
}
