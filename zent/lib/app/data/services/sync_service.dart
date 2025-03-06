import 'dart:async';
import 'package:get/get.dart';
import '../providers/interfaces/sync_interface.dart';
import '../providers/supabase/supabase_database.dart';
import '../providers/sqlite/sqlite_database.dart';
import '../utils/connectivity_helper.dart';

class SyncService extends GetxService implements SyncInterface {
  final SQLiteDatabase _localDb = SQLiteDatabase();
  final SupabaseDatabase _remoteDb = SupabaseDatabase();
  final ConnectivityHelper _connectivityHelper = ConnectivityHelper();

  // Control variables
  final RxBool isSyncing = false.obs;
  final RxString syncStatus = ''.obs;

  // Tablas a sincronizar
  final List<String> _tables = [
    'actividad',
    'auditoria',
    'cliente',
    'direccion',
    'documento',
    'especialidad',
    'estado',
    'incidente',
    'observacion',
    'permiso',
    'proveedor',
    'proyecto',
    'rol',
    'usuario'
  ];

  @override
  Future<void> onInit() async {
    super.onInit();
    await _localDb.init();
    await _remoteDb.init();

    // Iniciar sincronización periódica
    _setupPeriodicSync();
  }

  void _setupPeriodicSync() {
    // Sincronizar cada 15 minutos si hay conexión
    Timer.periodic(Duration(minutes: 15), (timer) async {
      if (await isOnline()) {
        syncAll();
      }
    });
  }

  // Sincronizar todas las tablas
  Future<void> syncAll() async {
    if (isSyncing.value) return;

    isSyncing.value = true;
    syncStatus.value = 'Sincronizando...';

    try {
      // Primero enviar datos locales al servidor
      for (final table in _tables) {
        await _syncTableToRemote(table);
      }

      // Luego obtener datos nuevos del servidor
      for (final table in _tables) {
        await _syncTableFromRemote(table);
      }

      syncStatus.value = 'Sincronización completada';
    } catch (e) {
      syncStatus.value = 'Error en sincronización: ${e.toString()}';
    } finally {
      isSyncing.value = false;
    }
  }

  Future<void> _syncTableToRemote(String table) async {
    // Obtener registros no enviados
    final pendingRecords = await _localDb.rawQuery(
        'SELECT * FROM $table WHERE enviado = ? OR enviado IS NULL', [false]);

    for (final record in pendingRecords) {
      await syncToRemote(table, record);
    }
  }

  Future<void> _syncTableFromRemote(String table) async {
    // Obtener último timestamp de sincronización (podrías almacenar esto en preferencias)
    final String? lastSync = null; // Implementar obtención del último timestamp

    final remoteRecords =
        await syncFromRemote(table, lastSyncTimestamp: lastSync);

    for (final record in remoteRecords) {
      // Verificar si el registro ya existe localmente
      final localRecord = await _localDb.getById(table, record['id']);

      if (localRecord == null) {
        // Insertar nuevo registro y marcarlo como enviado
        record['enviado'] = true;
        await _localDb.insert(table, record);
      } else {
        // Actualizar registro existente y marcarlo como enviado
        record['enviado'] = true;
        await _localDb.update(table, record, 'id = ?', [record['id']]);
      }
    }
  }

  @override
  Future<void> syncToRemote(String table, Map<String, dynamic> data) async {
    if (!await isOnline()) {
      return;
    }

    try {
      // Remover el campo 'enviado' antes de enviar a Supabase
      final Map<String, dynamic> remoteData = {...data};
      remoteData.remove('enviado');

      // Enviar a Supabase
      await _remoteDb.insert(table, remoteData);

      // Marcar como sincronizado
      await markAsSynced(table, data['id']);
    } catch (e) {
      print('Error al sincronizar con remoto: $e');
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> syncFromRemote(String table,
      {String? lastSyncTimestamp}) async {
    if (!await isOnline()) {
      return [];
    }

    try {
      // Podríamos filtrar por timestamp si implementamos lastSyncTimestamp
      return await _remoteDb.getAll(table);
    } catch (e) {
      print('Error al obtener datos remotos: $e');
      return [];
    }
  }

  @override
  Future<bool> isOnline() async {
    return await _connectivityHelper.isConnected();
  }

  @override
  Future<void> markAsSynced(String table, id) async {
    await _localDb.update(table, {'enviado': true}, 'id = ?', [id]);
  }
}
