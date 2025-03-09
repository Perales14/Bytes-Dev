import '../models/base_model.dart';
import '../models/permiso_model.dart';
import 'base_repository.dart';

class PermisoRepository extends BaseRepository<PermisoModel> {
  // Constructor que pasa el nombre de tabla correcto al repositorio base
  PermisoRepository() : super(tableName: 'permisos');

  @override
  PermisoModel fromMap(Map<String, dynamic> map) {
    return PermisoModel(
      id: map['id'] ?? 0,
      nombre: map['nombre'] ?? '',
      descripcion: map['descripcion'],
      modulo: map['modulo'] ?? '',
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
      enviado: map['enviado'] == 1 || map['enviado'] == true,
    );
  }

  // Métodos específicos para permisos

  // Método para obtener permisos por módulo
  Future<List<PermisoModel>> getByModulo(String modulo) async {
    try {
      return await query('modulo = ?', [modulo]);
    } catch (e) {
      throw Exception('Error al obtener permisos por módulo: $e');
    }
  }

  // Método para buscar permiso por nombre
  Future<PermisoModel?> findByNombre(String nombre) async {
    try {
      final results = await query('nombre = ?', [nombre]);
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      throw Exception('Error al buscar permiso por nombre: $e');
    }
  }
}
