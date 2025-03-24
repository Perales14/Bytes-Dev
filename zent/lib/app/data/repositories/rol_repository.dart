import '../models/base_model.dart';
import '../models/rol_model.dart';
import 'base_repository.dart';

class RolRepository extends BaseRepository<RolModel> {
  // Constructor que pasa el nombre de tabla correcto al repositorio base
  RolRepository() : super(tableName: 'roles');

  @override
  RolModel fromMap(Map<String, dynamic> map) {
    return RolModel(
      id: map['id'] ?? 0,
      nombre: map['nombre'] ?? '',
      descripcion: map['descripcion'],
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
      enviado: map['enviado'] == 1 || map['enviado'] == true,
    );
  }

  // Método para obtener todos los roles
  Future<List<RolModel>> getRoles() async {
    try {
      return await getAll();
    } catch (e) {
      throw Exception('Error al obtener roles: $e');
    }
  }

  // Método para obtener solo los nombres de todos los roles
  Future<List<String>> getRolesNames() async {
    try {
      final roles = await getRoles();
      return roles.map((rol) => rol.nombre).toList();
    } catch (e) {
      throw Exception('Error al obtener nombres de roles: $e');
    }
  }

  // Método para buscar rol por nombre
  Future<RolModel?> findByNombre(String nombre) async {
    try {
      final results = await query('nombre = ?', [nombre]);
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      throw Exception('Error al buscar rol por nombre: $e');
    }
  }

  // Método para obtener los permisos asociados a un rol
  Future<List<int>> getPermisosIds(int rolId) async {
    try {
      final results = await rawQuery(
          'SELECT permiso_id FROM rol_permisos WHERE rol_id = ?', [rolId]);
      return results.map((map) => map['permiso_id'] as int).toList();
    } catch (e) {
      throw Exception('Error al obtener permisos del rol: $e');
    }
  }

  // Método para asignar un permiso a un rol
  Future<void> asignarPermiso(int rolId, int permisoId) async {
    try {
      await rawInsert('rol_permisos', {
        'rol_id': rolId,
        'permiso_id': permisoId,
      });
    } catch (e) {
      throw Exception('Error al asignar permiso al rol: $e');
    }
  }

  // Método para revocar un permiso de un rol
  Future<void> revocarPermiso(int rolId, int permisoId) async {
    try {
      await rawDelete(
        'rol_permisos',
        'rol_id = ? AND permiso_id = ?',
        [rolId, permisoId],
      );
    } catch (e) {
      throw Exception('Error al revocar permiso del rol: $e');
    }
  }

  // Método para buscar roles por término en descripción
  Future<List<RolModel>> findByDescripcion(String termino) async {
    try {
      return await query('descripcion LIKE ?', ['%$termino%']);
    } catch (e) {
      throw Exception('Error al buscar roles por descripción: $e');
    }
  }
}
