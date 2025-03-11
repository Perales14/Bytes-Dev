import '../models/base_model.dart';
import '../models/actividad_model.dart';
import 'base_repository.dart';

class ActividadRepository extends BaseRepository<ActividadModel> {
  // Constructor que pasa el nombre de tabla correcto al repositorio base
  ActividadRepository() : super(tableName: 'actividades');

  @override
  ActividadModel fromMap(Map<String, dynamic> map) {
    return ActividadModel(
      id: map['id'] ?? 0,
      proyectoId: map['proyecto_id'] ?? 0,
      descripcion: map['descripcion'] ?? '',
      responsableId: map['responsable_id'],
      fechaInicio: BaseModel.parseDateTime(map['fecha_inicio']),
      fechaFin: BaseModel.parseDateTime(map['fecha_fin']),
      dependenciaId: map['dependencia_id'],
      evidencias: map['evidencias'] != null
          ? List<String>.from(map['evidencias'])
          : null,
      estadoId: map['estado_id'] ?? 0,
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
      enviado: map['enviado'] == 1 || map['enviado'] == true,
    );
  }

  // Métodos específicos para actividades

  // Método para obtener actividades por proyecto
  Future<List<ActividadModel>> getByProyecto(int proyectoId) async {
    try {
      return await query('proyecto_id = ?', [proyectoId]);
    } catch (e) {
      throw Exception('Error al obtener actividades por proyecto: $e');
    }
  }

  // Método para obtener actividades por responsable
  Future<List<ActividadModel>> getByResponsable(int responsableId) async {
    try {
      return await query('responsable_id = ?', [responsableId]);
    } catch (e) {
      throw Exception('Error al obtener actividades por responsable: $e');
    }
  }

  // Método para obtener actividades por estado
  Future<List<ActividadModel>> getByEstado(int estadoId) async {
    try {
      return await query('estado_id = ?', [estadoId]);
    } catch (e) {
      throw Exception('Error al obtener actividades por estado: $e');
    }
  }

  // Método para obtener actividades pendientes
  Future<List<ActividadModel>> getActividadesPendientes() async {
    try {
      return await query('fecha_fin IS NULL', []);
    } catch (e) {
      throw Exception('Error al obtener actividades pendientes: $e');
    }
  }

  // Método para obtener actividades por dependencia
  Future<List<ActividadModel>> getByDependencia(int dependenciaId) async {
    try {
      return await query('dependencia_id = ?', [dependenciaId]);
    } catch (e) {
      throw Exception('Error al obtener actividades por dependencia: $e');
    }
  }
}
