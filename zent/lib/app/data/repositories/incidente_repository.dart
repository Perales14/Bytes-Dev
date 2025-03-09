import '../models/base_model.dart';
import '../models/incidente_model.dart';
import 'base_repository.dart';

class IncidenteRepository extends BaseRepository<IncidenteModel> {
  // Constructor que pasa el nombre de tabla correcto al repositorio base
  IncidenteRepository() : super(tableName: 'incidentes');

  @override
  IncidenteModel fromMap(Map<String, dynamic> map) {
    return IncidenteModel(
      id: map['id'] ?? 0,
      proyectoId: map['proyecto_id'] ?? 0,
      tipo: map['tipo'],
      descripcion: map['descripcion'] ?? '',
      impacto: map['impacto'],
      acciones: map['acciones'],
      estado: map['estado'],
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
      enviado: map['enviado'] == 1 || map['enviado'] == true,
    );
  }

  // Métodos específicos para incidentes

  // Método para obtener incidentes por proyecto
  Future<List<IncidenteModel>> getByProyecto(int proyectoId) async {
    try {
      return await query('proyecto_id = ?', [proyectoId]);
    } catch (e) {
      throw Exception('Error al obtener incidentes por proyecto: $e');
    }
  }

  // Método para obtener incidentes por tipo
  Future<List<IncidenteModel>> getByTipo(String tipo) async {
    try {
      return await query('tipo = ?', [tipo]);
    } catch (e) {
      throw Exception('Error al obtener incidentes por tipo: $e');
    }
  }

  // Método para obtener incidentes por estado
  Future<List<IncidenteModel>> getByEstado(String estado) async {
    try {
      return await query('estado = ?', [estado]);
    } catch (e) {
      throw Exception('Error al obtener incidentes por estado: $e');
    }
  }

  // Método para buscar incidentes por descripción
  Future<List<IncidenteModel>> findByDescripcion(String descripcion) async {
    try {
      return await query('descripcion LIKE ?', ['%$descripcion%']);
    } catch (e) {
      throw Exception('Error al buscar incidentes por descripción: $e');
    }
  }

  // Método para buscar incidentes por impacto
  Future<List<IncidenteModel>> getByImpacto(String impacto) async {
    try {
      return await query('impacto = ?', [impacto]);
    } catch (e) {
      throw Exception('Error al obtener incidentes por impacto: $e');
    }
  }
}
