import 'package:supabase_flutter/supabase_flutter.dart';
import '../interfaces/database_interface.dart';

class SupabaseDatabase implements DatabaseInterface {
  late final SupabaseClient _client;
  bool _initialized = false;

  @override
  Future<void> init() async {
    if (!_initialized) {
      initialize();
    }
  }

  void initialize() {
        if (!_initialized) {

    _client = Supabase.instance.client;
    _initialized = true;}
  }

  @override
  Future<Map<String, dynamic>> insert(
      String table, Map<String, dynamic> data) async {
    initialize();
    final response = await _client.from(table).insert(data).select().single();
    // final a = await Supabase.instance.client.from(table).insert(data).select().single();

    return response;
  }

  @override
  Future<List<Map<String, dynamic>>> getAll(String table) async {
    final response = await _client.from(table).select();
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Future<Map<String, dynamic>?> getById(String table, dynamic id) async {
    initialize();
    final response =
        await _client.from(table).select().eq('id', id).maybeSingle();
    return response;
  }

  @override
  Future<int> update(String table, Map<String, dynamic> data, String where,
      List<dynamic> whereArgs) async {
    initialize();
    final fieldName = where.split(' ')[0];
    final value = whereArgs[0];
    await _client.from(table).update(data).eq(fieldName, value);
    return 1; // Supabase no devuelve el conteo exacto de filas afectadas
  }

  @override
  Future<int> delete(
      String table, String where, List<dynamic> whereArgs) async {
    initialize();
    final fieldName = where.split(' ')[0];
    final value = whereArgs[0];
    await _client.from(table).delete().eq(fieldName, value);
    return 1; // Supabase no devuelve el conteo exacto de filas afectadas
  }

  @override
  Future<List<Map<String, dynamic>>> rawQuery(String sql,
      [List<dynamic>? arguments]) async {
    initialize();
    // Supabase no soporta consultas SQL directas a través del cliente
    // Se podrían usar funciones PostgreSQL o llamadas RPC para consultas complejas
    throw UnimplementedError(
        'Raw queries not supported directly in Supabase client');
  }

  @override
  Future<List<Map<String, dynamic>>> query(
      String table, String where, List<dynamic> whereArgs) async {
    try {
      // Inicializamos la consulta
      initialize();
      print('Querying table $table with WHERE $where and args $whereArgs');
      var query = _client.from(table).select();
      // Procesamos las condiciones WHERE
      if (where.isNotEmpty && whereArgs.isNotEmpty) {
        // Dividimos la condición WHERE por "AND"
        final conditions = where.split(' AND ');

        // Aplicamos cada condición
        for (int i = 0; i < conditions.length; i++) {
          final condition = conditions[i].trim();
          final parts = condition.split(' ');

          if (parts.length >= 3) {
            final field = parts[0];
            final operator = parts[1];
            // El valor vendrá de whereArgs
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
                throw Exception('Operador no soportado: $operator');
            }
          }
        }
      }

      // Ejecutamos la consulta
      final response = await query;
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error en consulta Supabase: $e');
    }
  }

  @override
  Future<void> close() async {
    // No se necesita cerrar explícitamente el cliente de Supabase
  }
}
