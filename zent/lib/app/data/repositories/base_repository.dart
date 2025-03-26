import 'package:get/get.dart';
import '../models/base_model.dart';
import '../providers/sqlite/sqlite_database.dart';
import '../providers/supabase/supabase_database.dart';
import '../services/sync_service.dart';
import '../utils/connectivity_helper.dart';

abstract class BaseRepository<T extends BaseModel> {
  final String tableName;

  final SQLiteDatabase _localDb = Get.find<SQLiteDatabase>();
  final SupabaseDatabase _remoteDb = Get.find<SupabaseDatabase>();
  final SyncService _syncService = Get.find<SyncService>();
  final ConnectivityHelper _connectivityHelper = Get.find<ConnectivityHelper>();

  BaseRepository({required this.tableName});

  T fromMap(Map<String, dynamic> map);

  // CRUD Operations
  Future<T> create(T model) async {
    try {
      if (await _connectivityHelper.isConnected()) {
        Map<String, dynamic> user = model.toMap();
        user.remove('enviado');
        user.remove('id');

        final Map<String, dynamic> data =
            await _remoteDb.insert(tableName, user);
        final T createdModel = fromMap(data);
        createdModel.markAsSynced();

        return createdModel;
      } else {
        throw Exception('No hay conexión a internet para crear $tableName');
      }
    } catch (e) {
      throw Exception('Error al crear $tableName: $e');
    }
  }

  Future<List<T>> getAll() async {
    try {
      final List<Map<String, dynamic>> data = await _remoteDb.getAll(tableName);
      return data.map((map) => fromMap(map)).toList();
    } catch (e) {
      throw Exception('Error al obtener todos los $tableName: $e');
    }
  }

  Future<T?> getById(int id) async {
    try {
      if (await _connectivityHelper.isConnected()) {
        try {
          final remoteData = await _remoteDb.getById(tableName, id);

          if (remoteData != null) {
            try {
              await _localDb.update(tableName, remoteData, 'id = ?', [id]);
            } catch (syncError) {
              // Silent sync error - we already have the data
            }
            return fromMap(remoteData);
          }
        } catch (remoteError) {
          // Fall through to local query
        }
      }

      final localData = await _localDb.getById(tableName, id);
      if (localData == null) return null;
      return fromMap(localData);
    } catch (e) {
      throw Exception('Error al obtener $tableName con ID $id: $e');
    }
  }

  Future<T> update(T model) async {
    try {
      model.updateModifiedAt();
      model.markAsNotSynced();

      await _localDb.update(tableName, model.toMap(), 'id = ?', [model.id]);

      if (await _connectivityHelper.isConnected()) {
        await _syncService.syncToRemote(tableName, model.toMap());
        model.markAsSynced();
      }

      return model;
    } catch (e) {
      throw Exception('Error al actualizar $tableName: $e');
    }
  }

  Future<bool> delete(int id) async {
    try {
      await _localDb.delete(tableName, 'id = ?', [id]);

      if (await _connectivityHelper.isConnected()) {
        await _remoteDb.delete(tableName, 'id = ?', [id]);
      } else {
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

  // Synchronization
  Future<void> syncWithRemote() async {
    if (await _connectivityHelper.isConnected()) {
      final List<Map<String, dynamic>> pendingRecords = await _localDb.rawQuery(
          'SELECT * FROM $tableName WHERE enviado = ? OR enviado IS NULL',
          [false]);

      for (final record in pendingRecords) {
        await _syncService.syncToRemote(tableName, record);
      }

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

  // Query operations
  Future<List<T>> query(String where, List<dynamic> whereArgs) async {
    try {
      if (await _connectivityHelper.isConnected()) {
        final data = await _remoteDb.query(tableName, where, whereArgs);
        return data.map((map) => fromMap(map)).toList();
      } else {
        final data = await _localDb.rawQuery(
            'SELECT * FROM $tableName WHERE $where', whereArgs);
        return data.map((map) => fromMap(map)).toList();
      }
    } catch (e) {
      throw Exception('Error en consulta personalizada para $tableName: $e');
    }
  }

  Future<List<Map<String, dynamic>>> rawQuery(
      String sql, List<dynamic> args) async {
    try {
      return await _localDb.rawQuery(sql, args);
    } catch (e) {
      throw Exception('Error en consulta raw: $e');
    }
  }

  Future<int> rawInsert(String table, Map<String, dynamic> data) async {
    try {
      final id = await _localDb.insert(table, data);

      if (await _connectivityHelper.isConnected()) {
        await _remoteDb.insert(table, data);
      } else {
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

  Future<int> rawDelete(
      String table, String where, List<dynamic> whereArgs) async {
    try {
      final count = await _localDb.delete(table, where, whereArgs);

      if (await _connectivityHelper.isConnected()) {
        await _remoteDb.delete(table, where, whereArgs);
      } else {
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
