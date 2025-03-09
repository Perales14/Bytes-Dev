import 'dart:convert';
import '../models/base_model.dart';
import '../models/permiso_model.dart';
import 'base_repository.dart';

class PermisoRepository extends BaseRepository<PermisoModel> {
  // Constructor que pasa el nombre de tabla correcto al repositorio base
  PermisoRepository() : super(tableName: 'permisos');

  @override
  PermisoModel fromMap(Map<String, dynamic> map) {
    return PermisoModel(
      rolId: map['rol_id'] ?? 0,
      permisosJson: map['permisos_json'] != null
          ? (map['permisos_json'] is String
              ? json.decode(map['permisos_json'])
              : Map<String, dynamic>.from(map['permisos_json']))
          : null,
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
      enviado: map['enviado'] == 1 || map['enviado'] == true,
    );
  }

  // Métodos específicos para permisos

  // Método para obtener permisos por rol
  Future<PermisoModel?> getByRolId(int rolId) async {
    try {
      final results = await query('rol_id = ?', [rolId]);
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      throw Exception('Error al obtener permisos por rol: $e');
    }
  }

  // Método para actualizar los permisos de un rol específico
  Future<int> actualizarPermisos(
      int rolId, Map<String, dynamic> nuevosPermisos) async {
    try {
      PermisoModel? permiso = await getByRolId(rolId);

      if (permiso != null) {
        // Actualizar permisos existentes
        permiso.permisosJson = nuevosPermisos;
        await update(permiso);
        return 1; // Retorna 1 indicando éxito en la actualización
      } else {
        // Crear nuevo registro de permisos
        permiso = PermisoModel(
          rolId: rolId,
          permisosJson: nuevosPermisos,
        );
        final id = await insert(permiso);
        return id; // Retorna el ID insertado
      }
    } catch (e) {
      throw Exception('Error al actualizar permisos: $e');
    }
  }

  // Método para verificar si un rol tiene un permiso específico
  Future<bool> tienePermiso(int rolId, String modulo, String accion) async {
    try {
      final permiso = await getByRolId(rolId);
      if (permiso == null || permiso.permisosJson == null) {
        return false;
      }

      // Navega por el JSON para verificar si existe el permiso
      final moduloPermisos = permiso.permisosJson![modulo];
      if (moduloPermisos == null) {
        return false;
      }

      return moduloPermisos[accion] == true;
    } catch (e) {
      throw Exception('Error al verificar permiso: $e');
    }
  }

  // Método para añadir un permiso específico a un rol
  Future<void> agregarPermiso(int rolId, String modulo, String accion) async {
    try {
      PermisoModel? permiso = await getByRolId(rolId);

      if (permiso == null) {
        // Crear nuevo registro con este permiso
        final nuevosPermisos = {
          modulo: {accion: true}
        };
        await insert(PermisoModel(
          rolId: rolId,
          permisosJson: nuevosPermisos,
        ));
      } else {
        // Actualizar permisos existentes
        final permisos = permiso.permisosJson ?? {};

        if (!permisos.containsKey(modulo)) {
          permisos[modulo] = {};
        }

        permisos[modulo][accion] = true;
        permiso.permisosJson = permisos;
        await update(permiso);
      }
    } catch (e) {
      throw Exception('Error al agregar permiso: $e');
    }
  }

  // Método para revocar un permiso específico de un rol
  Future<void> revocarPermiso(int rolId, String modulo, String accion) async {
    try {
      final permiso = await getByRolId(rolId);
      if (permiso == null || permiso.permisosJson == null) {
        return;
      }

      final permisos = permiso.permisosJson!;
      if (permisos.containsKey(modulo) &&
          permisos[modulo] is Map &&
          permisos[modulo].containsKey(accion)) {
        permisos[modulo][accion] = false;
        permiso.permisosJson = permisos;
        await update(permiso);
      }
    } catch (e) {
      throw Exception('Error al revocar permiso: $e');
    }
  }
}
