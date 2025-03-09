import '../models/base_model.dart';
import '../models/documento_model.dart';
import 'base_repository.dart';

class DocumentoRepository extends BaseRepository<DocumentoModel> {
  // Constructor que pasa el nombre de tabla correcto al repositorio base
  DocumentoRepository() : super(tableName: 'documentos');

  @override
  DocumentoModel fromMap(Map<String, dynamic> map) {
    return DocumentoModel(
      id: map['id'] ?? 0,
      nombre: map['nombre'] ?? '',
      descripcion: map['descripcion'],
      ruta: map['ruta'] ?? '',
      tipoDocumento: map['tipo_documento'] ?? '',
      entidadRelacionada: map['entidad_relacionada'] ?? '',
      idEntidad: map['id_entidad'] ?? 0,
      usuarioId: map['usuario_id'] ?? 0,
      fechaSubida:
          BaseModel.parseDateTime(map['fecha_subida']) ?? DateTime.now(),
      estadoId: map['estado_id'] ?? 0,
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
      enviado: map['enviado'] == 1 || map['enviado'] == true,
    );
  }

  // Métodos específicos para documentos

  // Método para obtener documentos por entidad relacionada
  Future<List<DocumentoModel>> getByEntidadRelacionada(
      String entidad, int idEntidad) async {
    try {
      return await query(
          'entidad_relacionada = ? AND id_entidad = ?', [entidad, idEntidad]);
    } catch (e) {
      throw Exception(
          'Error al obtener documentos por entidad relacionada: $e');
    }
  }

  // Método para obtener documentos por usuario que los subió
  Future<List<DocumentoModel>> getByUsuario(int usuarioId) async {
    try {
      return await query('usuario_id = ?', [usuarioId]);
    } catch (e) {
      throw Exception('Error al obtener documentos por usuario: $e');
    }
  }

  // Método para obtener documentos por tipo
  Future<List<DocumentoModel>> getByTipo(String tipoDocumento) async {
    try {
      return await query('tipo_documento = ?', [tipoDocumento]);
    } catch (e) {
      throw Exception('Error al obtener documentos por tipo: $e');
    }
  }
}
