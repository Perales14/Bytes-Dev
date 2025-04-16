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
    data.remove('id'); // Remove the ID field from the data map
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

      // Consulta raw para una expresión más compleja
      if (where.contains('LOWER')) {
        print('Usando consulta insensible a mayúsculas/minúsculas');

        // Para el caso específico LOWER(email) = LOWER(?)
        if (where.contains('LOWER(email)') && whereArgs.length == 1) {
          final value = whereArgs[0].toString().toLowerCase();
          // Usa ilike para comparación insensible a mayúsculas/minúsculas
          query = query.ilike('email', value);
          print('Buscando email con valor: $value usando ilike');
        } else {
          // Para otros casos de LOWER, usar una aproximación
          final conditions = where.split(' AND ');
          for (int i = 0; i < conditions.length && i < whereArgs.length; i++) {
            final condition = conditions[i].trim();

            if (condition.contains('LOWER') && condition.contains('=')) {
              // Extraer nombre del campo
              final fieldMatch =
                  RegExp(r'LOWER\((\w+)\)').firstMatch(condition);
              if (fieldMatch != null && fieldMatch.groupCount >= 1) {
                final fieldName = fieldMatch
                    .group(1); // por ejemplo, extrae 'email' de LOWER(email)
                if (fieldName != null) {
                  final value = whereArgs[i].toString().toLowerCase();
                  query = query.ilike(fieldName, value);
                  print('Buscando $fieldName con valor: $value usando ilike');
                }
              }
            }
          }
        }
      }
      // Manejo normal para consultas estándar
      else if (where.isNotEmpty && whereArgs.isNotEmpty) {
        final conditions = where.split(' AND ');

        for (int i = 0; i < conditions.length && i < whereArgs.length; i++) {
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
                query = query.like(
                    field,
                    value.toString().contains('%')
                        ? value.toString()
                        : '%$value%');
                break;
              case 'ILIKE':
                query = query.ilike(
                    field,
                    value.toString().contains('%')
                        ? value.toString()
                        : '%$value%');
                break;
              default:
                throw Exception('Operador no soportado: $operator');
            }
          }
        }
      }

      final response = await query;
      print('Consulta ejecutada. Resultados: ${response.length}');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error en query: $e');
      throw Exception('Error en consulta: $e');
    }
  }
}
