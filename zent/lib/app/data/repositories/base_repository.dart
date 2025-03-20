import 'package:get/get.dart';
import '../models/base_model.dart';
import '../providers/sqlite/sqlite_database.dart';
import '../providers/supabase/supabase_database.dart';
import '../services/sync_service.dart';
import '../utils/connectivity_helper.dart';

abstract class BaseRepository<T extends BaseModel> {
  final String tableName;
  // Flag para indicar si estamos usando la DB local o Supabase
  bool useLocalDB = false;

  // Providers de bases de datos
  final SQLiteDatabase _localDb = Get.find<SQLiteDatabase>();
  final SupabaseDatabase _remoteDb = Get.find<SupabaseDatabase>();

  // Servicios
  final SyncService _syncService = Get.find<SyncService>();
  final ConnectivityHelper _connectivityHelper = Get.find<ConnectivityHelper>();

  // Constructor
  BaseRepository({required this.tableName});

  // Método abstracto que cada repositorio hijo debe implementar
  // para convertir un Map a un modelo específico
  T fromMap(Map<String, dynamic> map);

  // Método para convertir un modelo a mapa para la base de datos
  // Este método puede ser sobrescrito por repositorios específicos
  Map<String, dynamic> toMapForDB(T model) {
    return model.toMap();
  }

  // CRUD Operations

  // CREATE: Crear un nuevo registro
  Future<T> create(T model) async {
    try {
      // Aseguramos que se marque como no sincronizado al inicio
      model.markAsNotSynced();

      // Insertamos en la base de datos local
      final Map<String, dynamic> data =
          await _localDb.insert(tableName, toMapForDB(model));
      final T createdModel = fromMap(data);

      // Intentamos sincronizar con el servidor si hay conexión
      if (await _connectivityHelper.isConnected()) {
        await _syncService.syncToRemote(tableName, createdModel.toMap());
        createdModel.markAsSynced();
      }

      return createdModel;
    } catch (e) {
      throw Exception('Error al crear $tableName: $e');
    }
  }

  // READ: Obtener todos los registros
  Future<List<T>> getAll() async {
    try {
      final List<Map<String, dynamic>> data = await _localDb.getAll(tableName);
      return data.map((map) => fromMap(map)).toList();
    } catch (e) {
      throw Exception('Error al obtener todos los $tableName: $e');
    }
  }

  // READ: Obtener un registro por ID
  Future<T?> getById(int id) async {
    try {
      final data = await _localDb.getById(tableName, id);
      if (data == null) return null;
      return fromMap(data);
    } catch (e) {
      throw Exception('Error al obtener $tableName con ID $id: $e');
    }
  }

  // UPDATE: Actualizar un registro existente
  Future<T> update(T model) async {
    try {
      // Asegurarse de que la fecha de actualización sea actual
      model.updateModifiedAt();
      // Marcar como no sincronizado
      model.markAsNotSynced();

      // Actualizar localmente
      await _localDb.update(tableName, toMapForDB(model), 'id = ?', [model.id]);

      // Intentar sincronizar con el servidor si hay conexión
      if (await _connectivityHelper.isConnected()) {
        await _syncService.syncToRemote(tableName, model.toMap());
        model.markAsSynced();
      }

      return model;
    } catch (e) {
      throw Exception('Error al actualizar $tableName: $e');
    }
  }

  // DELETE: Eliminar un registro
  Future<bool> delete(int id) async {
    try {
      // Eliminar de la base de datos local
      await _localDb.delete(tableName, 'id = ?', [id]);

      // Si hay conexión, eliminar también del servidor
      if (await _connectivityHelper.isConnected()) {
        await _remoteDb.delete(tableName, 'id = ?', [id]);
      } else {
        // Si no hay conexión, registrar la eliminación para sincronizar más tarde
        // Aquí podrías usar una tabla de "eliminaciones pendientes"
        await _localDb.insert('sync_deletions', {
          'table_name': tableName,
          'record_id': id,
          'deleted_at': DateTime.now().toIso8601String()
        });
      }

      return true;
    } catch (e) {
      throw Exception('Error al eliminar $tableName con ID $id: $e');
    }
  }

  // Método para sincronización manual
  Future<void> syncWithRemote() async {
    if (await _connectivityHelper.isConnected()) {
      // Sincronizar datos locales no enviads
      final List<Map<String, dynamic>> pendingRecords = await _localDb.rawQuery(
          'SELECT * FROM $tableName WHERE enviado = ? OR enviado IS NULL',
          [false]);

      for (final record in pendingRecords) {
        await _syncService.syncToRemote(tableName, record);
      }

      // Obtener datos nuevos del servidor
      final remoteRecords = await _syncService.syncFromRemote(tableName);
      for (final record in remoteRecords) {
        T model = fromMap(record);
        model.markAsSynced();

        final existingRecord = await _localDb.getById(tableName, model.id);
        if (existingRecord == null) {
          await _localDb.insert(tableName, model.toMap());
        } else {
          await _localDb.update(tableName, model.toMap(), 'id = ?', [model.id]);
        }
      }
    }
  }

  // Búsqueda personalizada
  Future<List<T>> query(String where, List<dynamic> whereArgs) async {
    try {
      final List<Map<String, dynamic>> data = await _localDb.rawQuery(
          'SELECT * FROM $tableName WHERE $where', whereArgs);
      return data.map((map) => fromMap(map)).toList();
    } catch (e) {
      throw Exception('Error en consulta personalizada para $tableName: $e');
    }
  }

  // Método para ejecutar consultas SQL personalizadas
  Future<List<Map<String, dynamic>>> rawQuery(
      String sql, List<dynamic> args) async {
    try {
      return await _localDb.rawQuery(sql, args);
    } catch (e) {
      throw Exception('Error en consulta raw: $e');
    }
  }

  // Método para insertar en tablas relacionadas
  Future<int> rawInsert(String table, Map<String, dynamic> data) async {
    try {
      // Insertar en la base de datos local
      final id = await _localDb.insert(table, data);

      // Si hay conexión, sincronizar con el servidor
      if (await _connectivityHelper.isConnected()) {
        await _remoteDb.insert(table, data);
      } else {
        // Registrar para sincronización posterior
        await _localDb.insert('sync_pending', {
          'table_name': table,
          'record_data': data.toString(),
          'operation': 'insert',
          'created_at': DateTime.now().toIso8601String()
        });
      }

      return id['id'] ?? 0;
    } catch (e) {
      throw Exception('Error al insertar en $table: $e');
    }
  }

  // Método para eliminar con condiciones personalizadas
  Future<int> rawDelete(
      String table, String where, List<dynamic> whereArgs) async {
    try {
      // Eliminar de la base de datos local
      final count = await _localDb.delete(table, where, whereArgs);

      // Si hay conexión, eliminar también del servidor
      if (await _connectivityHelper.isConnected()) {
        await _remoteDb.delete(table, where, whereArgs);
      } else {
        // Registrar para sincronización posterior
        await _localDb.insert('sync_pending', {
          'table_name': table,
          'where_condition': where,
          'where_args': whereArgs.toString(),
          'operation': 'delete',
          'created_at': DateTime.now().toIso8601String()
        });
      }

      return count;
    } catch (e) {
      throw Exception('Error al eliminar de $table: $e');
    }
  }
}
