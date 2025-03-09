import 'package:get/get.dart';
import '../models/base_model.dart';
import '../providers/sqlite/sqlite_database.dart';
import '../providers/supabase/supabase_database.dart';
import '../services/sync_service.dart';
import '../utils/connectivity_helper.dart';

abstract class BaseRepository<T extends BaseModel> {
  // Nombre de la tabla en la base de datos
  final String tableName;

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

  // CRUD Operations

  // CREATE: Crear un nuevo registro
  Future<T> create(T model) async {
    try {
      // Aseguramos que se marque como no sincronizado al inicio
      model.markAsNotSynced();

      // Insertamos en la base de datos local
      final Map<String, dynamic> data =
          await _localDb.insert(tableName, model.toMap());
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
      await _localDb.update(tableName, model.toMap(), 'id = ?', [model.id]);

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
      // Sincronizar datos locales no enviados
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
}
