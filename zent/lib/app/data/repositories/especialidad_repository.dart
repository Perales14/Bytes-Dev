import '../models/base_model.dart';
import '../models/especialidad_model.dart';
import 'base_repository.dart';

class EspecialidadRepository extends BaseRepository<EspecialidadModel> {
  // Constructor que pasa el nombre de tabla correcto al repositorio base
  EspecialidadRepository() : super(tableName: 'especialidades');

  @override
  EspecialidadModel fromMap(Map<String, dynamic> map) {
    return EspecialidadModel(
      id: map['id'] ?? 0,
      nombre: map['nombre'] ?? '',
      descripcion: map['descripcion'],
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
      enviado: map['enviado'] == 1 || map['enviado'] == true,
    );
  }

  // Métodos específicos para especialidades

  // Método para buscar especialidad por nombre
  Future<EspecialidadModel?> findByNombre(String nombre) async {
    try {
      final results = await query('nombre = ?', [nombre]);
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      throw Exception('Error al buscar especialidad por nombre: $e');
    }
  }

  // Método para buscar especialidades por término en nombre o descripción
  Future<List<EspecialidadModel>> findByTermino(String termino) async {
    try {
      return await query(
          'nombre LIKE ? OR descripcion LIKE ?', ['%$termino%', '%$termino%']);
    } catch (e) {
      throw Exception('Error al buscar especialidades por término: $e');
    }
  }
}
