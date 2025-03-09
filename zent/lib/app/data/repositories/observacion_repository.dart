import '../models/base_model.dart';
import '../models/observacion_model.dart';
import 'base_repository.dart';

class ObservacionRepository extends BaseRepository<ObservacionModel> {
  // Constructor que pasa el nombre de tabla correcto al repositorio base
  ObservacionRepository() : super(tableName: 'observaciones');

  @override
  ObservacionModel fromMap(Map<String, dynamic> map) {
    return ObservacionModel(
      id: map['id'] ?? 0,
      tablaOrigen: map['tabla_origen'] ?? '',
      idOrigen: map['id_origen'] ?? 0,
      observacion: map['observacion'] ?? '',
      usuarioId: map['usuario_id'] ?? 0,
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      enviado: map['enviado'] == 1 || map['enviado'] == true,
    );
  }

  // Métodos específicos para observaciones

  // Método para obtener observaciones por tabla origen y id origen
  Future<List<ObservacionModel>> getByOrigen(
      String tablaOrigen, int idOrigen) async {
    try {
      return await query(
          'tabla_origen = ? AND id_origen = ?', [tablaOrigen, idOrigen]);
    } catch (e) {
      throw Exception('Error al obtener observaciones por origen: $e');
    }
  }

  // Método para obtener observaciones por usuario
  Future<List<ObservacionModel>> getByUsuario(int usuarioId) async {
    try {
      return await query('usuario_id = ?', [usuarioId]);
    } catch (e) {
      throw Exception('Error al obtener observaciones por usuario: $e');
    }
  }

  // Método para buscar observaciones por contenido
  Future<List<ObservacionModel>> buscarPorContenido(String texto) async {
    try {
      return await query('observacion LIKE ?', ['%$texto%']);
    } catch (e) {
      throw Exception('Error al buscar observaciones por contenido: $e');
    }
  }

  // Método para obtener observaciones por tabla origen
  Future<List<ObservacionModel>> getByTablaOrigen(String tablaOrigen) async {
    try {
      return await query('tabla_origen = ?', [tablaOrigen]);
    } catch (e) {
      throw Exception('Error al obtener observaciones por tabla origen: $e');
    }
  }
}
