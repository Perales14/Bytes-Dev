import '../models/base_model.dart';
import '../models/estado_model.dart';
import 'base_repository.dart';

class EstadoRepository extends BaseRepository<EstadoModel> {
  // Constructor que pasa el nombre de tabla correcto al repositorio base
  EstadoRepository() : super(tableName: 'estados');

  @override
  EstadoModel fromMap(Map<String, dynamic> map) {
    return EstadoModel(
      id: map['id'] ?? 0,
      tabla: map['tabla'] ?? '',
      codigo: map['codigo'] ?? '',
      nombre: map['nombre'] ?? '',
      descripcion: map['descripcion'],
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
      enviado: map['enviado'] == 1 || map['enviado'] == true,
    );
  }

  // Métodos específicos para estados

  // Método para obtener estados por tabla
  Future<List<EstadoModel>> getByTabla(String tabla) async {
    try {
      return await query('tabla = ?', [tabla]);
    } catch (e) {
      throw Exception('Error al obtener estados por tabla: $e');
    }
  }

  // Método para buscar estado por código
  Future<EstadoModel?> findByCodigo(String codigo) async {
    try {
      final results = await query('codigo = ?', [codigo]);
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      throw Exception('Error al buscar estado por código: $e');
    }
  }

  // Método para buscar estado por nombre y tabla
  Future<EstadoModel?> findByNombreAndTabla(String nombre, String tabla) async {
    try {
      final results = await query('nombre = ? AND tabla = ?', [nombre, tabla]);
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      throw Exception('Error al buscar estado por nombre y tabla: $e');
    }
  }
}
