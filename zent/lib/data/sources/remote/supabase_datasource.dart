import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zent/data/sources/remote/interfaces/i_remote_datasource.dart';

class SupabaseDataSource implements IRemoteDataSource {
  final SupabaseClient _client;

  SupabaseDataSource(this._client);

  @override
  Future<List<Map<String, dynamic>>> getAll(String table,
      {Map<String, dynamic>? filters}) async {
    try {
      var query = _client.from(table).select();

      // Aplicar filtros si existen
      if (filters != null) {
        filters.forEach((key, value) {
          query = query.eq(key, value);
        });
      }

      final data = await query;
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      throw Exception('Error en Supabase getAll: $e');
    }
  }

  @override
  Future<Map<String, dynamic>?> getById(String table, int id) async {
    try {
      final data =
          await _client.from(table).select().eq('id', id).maybeSingle();

      return data != null ? Map<String, dynamic>.from(data) : null;
    } on PostgrestException catch (e) {
      // En caso de "no encontrado", devolver null en lugar de lanzar error
      if (e.message.contains('No rows found')) {
        return null;
      }
      throw Exception('Error en Supabase getById: ${e.message}');
    } catch (e) {
      throw Exception('Error en Supabase getById: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> insert(
      String table, Map<String, dynamic> data) async {
    try {
      final result = await _client.from(table).insert(data).select();

      if (result.isEmpty) {
        throw Exception('No se devolvieron datos después de la inserción');
      }

      return Map<String, dynamic>.from(result.first);
    } catch (e) {
      throw Exception('Error en Supabase insert: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> update(
      String table, int id, Map<String, dynamic> data) async {
    try {
      final result =
          await _client.from(table).update(data).eq('id', id).select();

      if (result.isEmpty) {
        throw Exception('No se encontró el registro para actualizar');
      }

      return Map<String, dynamic>.from(result.first);
    } catch (e) {
      throw Exception('Error en Supabase update: $e');
    }
  }

  @override
  Future<void> delete(String table, int id) async {
    try {
      await _client.from(table).delete().eq('id', id);
    } catch (e) {
      throw Exception('Error en Supabase delete: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> executeRpc(String function,
      {Map<String, dynamic>? params}) async {
    try {
      final result = await _client.rpc(function, params: params);
      return List<Map<String, dynamic>>.from(result);
    } catch (e) {
      throw Exception('Error en Supabase RPC: $e');
    }
  }
}
