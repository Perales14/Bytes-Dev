import 'package:get/get.dart';
import 'package:zent/core/constants/db_constants.dart';
import 'package:zent/data/models/direccion_model.dart';
import 'package:zent/data/repositories/interfaces/i_direccion_repository.dart';
import 'package:zent/data/sources/local/interfaces/i_local_datasource.dart';
import 'package:zent/data/sources/remote/interfaces/i_remote_datasource.dart';

class DireccionRepository implements IDireccionRepository {
  final ILocalDataSource _localDataSource;
  final IRemoteDataSource _remoteDataSource;

  DireccionRepository(this._localDataSource, this._remoteDataSource);

  @override
  Future<List<Direccion>> getAll({bool forceRefresh = false}) async {
    try {
      // Si se fuerza la actualización, intentar obtener datos remotos primero
      if (forceRefresh) {
        try {
          final remoteData =
              await _remoteDataSource.getAll(DbConstants.direccionesTable);

          // Actualizar base local con datos remotos (operación en lote)
          await _localDataSource.executeTransaction((batch) {
            for (var item in remoteData) {
              // Convertir el modelo para almacenamiento local
              final direccion = Direccion.fromJson(item, fromSupabase: true);

              // Verificar si existe localmente
              _localDataSource
                  .getById(DbConstants.direccionesTable, direccion.id!)
                  .then((localData) {
                if (localData != null) {
                  // Actualizar pero preservar estado de enviado
                  final Map<String, dynamic> updateData = direccion.toJson();
                  updateData['enviado'] = 1; // Marcar como enviado
                  batch.update(DbConstants.direccionesTable, updateData,
                      where: 'id = ?', whereArgs: [direccion.id]);
                } else {
                  // Insertar como nuevo registro (ya sincronizado)
                  final Map<String, dynamic> insertData = direccion.toJson();
                  insertData['enviado'] = 1; // Marcar como enviado
                  batch.insert(DbConstants.direccionesTable, insertData);
                }
              });
            }
          });
        } catch (e) {
          print('Error al sincronizar con datos remotos: $e');
          // Continuar con datos locales si hay error
        }
      }

      // Obtener datos locales actualizados
      final localData =
          await _localDataSource.getAll(DbConstants.direccionesTable);
      return localData.map((e) => Direccion.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Error al obtener direcciones: $e');
    }
  }

  @override
  Future<Direccion?> getById(int id) async {
    try {
      // Intentar obtener de la base local primero
      final localData =
          await _localDataSource.getById(DbConstants.direccionesTable, id);

      if (localData != null) {
        return Direccion.fromJson(localData);
      }

      // Si no se encuentra localmente, intentar obtenerlo remotamente
      try {
        final remoteData =
            await _remoteDataSource.getById(DbConstants.direccionesTable, id);
        if (remoteData != null) {
          // Guardar en local para futuras consultas
          final direccion = Direccion.fromJson(remoteData, fromSupabase: true);
          await _localDataSource.insert(DbConstants.direccionesTable,
              direccion.copyWith(enviado: true).toJson());
          return direccion;
        }
      } catch (e) {
        print('Error al obtener dirección remota: $e');
      }

      return null;
    } catch (e) {
      throw Exception('Error al obtener dirección: $e');
    }
  }

  @override
  Future<int> save(Direccion direccion) async {
    try {
      // Guardar localmente primero
      final localId = await _localDataSource.insert(
          DbConstants.direccionesTable, direccion.toJson());

      // Intentar guardar en remoto
      try {
        // Agregar el ID local que se generó
        final direccionWithId = direccion.copyWith(id: localId);
        await _remoteDataSource.insert(DbConstants.direccionesTable,
            direccionWithId.toJson(forSupabase: true));

        // Actualizar el registro local para marcarlo como enviado
        await _localDataSource.markAsSent(
            DbConstants.direccionesTable, localId);
      } catch (e) {
        // Error al sincronizar, se intentará más tarde
        print('Error al sincronizar nueva dirección: $e');
      }

      return localId;
    } catch (e) {
      throw Exception('Error al guardar dirección: $e');
    }
  }

  @override
  Future<bool> update(Direccion direccion) async {
    try {
      if (direccion.id == null) {
        throw Exception('ID de dirección no puede ser nulo para actualizar');
      }

      // Actualizar localmente
      final Map<String, dynamic> updateData = direccion
          .copyWith(enviado: false, updatedAt: DateTime.now().toIso8601String())
          .toJson();

      final result = await _localDataSource.update(
          DbConstants.direccionesTable, direccion.id!, updateData);

      if (result <= 0) return false;

      // Intentar actualizar en remoto
      try {
        await _remoteDataSource.update(DbConstants.direccionesTable,
            direccion.id!, direccion.toJson(forSupabase: true));

        // Marcar como enviado en la base local
        await _localDataSource.markAsSent(
            DbConstants.direccionesTable, direccion.id!);
      } catch (e) {
        // Error al sincronizar, se intentará más tarde
        print('Error al sincronizar actualización: $e');
      }

      return true;
    } catch (e) {
      print('Error al actualizar dirección: $e');
      return false;
    }
  }

  @override
  Future<bool> delete(int id) async {
    try {
      // Eliminar localmente
      final result =
          await _localDataSource.delete(DbConstants.direccionesTable, id);

      if (result <= 0) return false;

      // Intentar eliminar en remoto
      try {
        await _remoteDataSource.delete(DbConstants.direccionesTable, id);
      } catch (e) {
        // Error al sincronizar eliminación
        print('Error al sincronizar eliminación: $e');
      }

      return true;
    } catch (e) {
      print('Error al eliminar dirección: $e');
      return false;
    }
  }

  @override
  Future<void> syncPendingToRemote() async {
    try {
      // Obtener elementos pendientes de sincronizar
      final pendientes =
          await _localDataSource.getPendingToSync(DbConstants.direccionesTable);

      for (var item in pendientes) {
        final direccion = Direccion.fromJson(item);

        if (direccion.id != null) {
          try {
            // Intentar sincronizar con Supabase
            await _remoteDataSource.update(DbConstants.direccionesTable,
                direccion.id!, direccion.toJson(forSupabase: true));

            // Marcar como sincronizado
            await _localDataSource.markAsSent(
                DbConstants.direccionesTable, direccion.id!);
          } catch (e) {
            print('Error al sincronizar dirección ${direccion.id}: $e');
          }
        }
      }
    } catch (e) {
      throw Exception('Error en la sincronización: $e');
    }
  }
}
