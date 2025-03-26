import '../models/base_model.dart';
import '../models/auditoria_model.dart';
import 'base_repository.dart';

class AuditoriaRepository extends BaseRepository<AuditoriaModel> {
  // Constructor que pasa el nombre de tabla correcto al repositorio base
  AuditoriaRepository() : super(tableName: 'auditorias');

  @override
  AuditoriaModel fromMap(Map<String, dynamic> map) {
    return AuditoriaModel(
      id: map['id'] ?? 0,
      tablaAfectada: map['tabla_afectada'] ?? '',
      operacion: map['operacion'],
      idAfectado: map['id_afectado'],
      valoresAnteriores: map['valores_anteriores'] != null
          ? Map<String, dynamic>.from(map['valores_anteriores'])
          : null,
      valoresNuevos: map['valores_nuevos'] != null
          ? Map<String, dynamic>.from(map['valores_nuevos'])
          : null,
      usuarioId: map['usuario_id'],
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      enviado: map['enviado'] == 1 || map['enviado'] == true,
    );
  }

  // Métodos específicos para auditorías

  // Método para obtener auditorías por usuario
  Future<List<AuditoriaModel>> getByUsuario(int usuarioId) async {
    try {
      return await query('usuario_id = ?', [usuarioId]);
    } catch (e) {
      throw Exception('Error al obtener auditorías por usuario: $e');
    }
  }

  // Método para obtener auditorías por tipo de operación
  Future<List<AuditoriaModel>> getByOperacion(String operacion) async {
    try {
      return await query('operacion = ?', [operacion]);
    } catch (e) {
      throw Exception('Error al obtener auditorías por operación: $e');
    }
  }

  // Método para obtener auditorías por tabla afectada
  Future<List<AuditoriaModel>> getByTabla(String tablaAfectada) async {
    try {
      return await query('tabla_afectada = ?', [tablaAfectada]);
    } catch (e) {
      throw Exception('Error al obtener auditorías por tabla afectada: $e');
    }
  }

  // Método para obtener auditorías por ID afectado
  Future<List<AuditoriaModel>> getByIdAfectado(
      int idAfectado, String tablaAfectada) async {
    try {
      return await query('id_afectado = ? AND tabla_afectada = ?',
          [idAfectado, tablaAfectada]);
    } catch (e) {
      throw Exception('Error al obtener auditorías por ID afectado: $e');
    }
  }
}
