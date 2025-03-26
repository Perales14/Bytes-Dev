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
      proyectoId: map['proyecto_id'],
      tipo: map['tipo'],
      titulo: map['titulo'] ?? '',
      contenido: map['contenido'],
      archivoUrl: map['archivo_url'],
      usuarioId: map['usuario_id'] ?? 0,
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
      enviado: map['enviado'] == 1 || map['enviado'] == true,
    );
  }

  // Métodos específicos para documentos

  // Método para obtener documentos por proyecto
  Future<List<DocumentoModel>> getByProyecto(int proyectoId) async {
    try {
      return await query('proyecto_id = ?', [proyectoId]);
    } catch (e) {
      throw Exception('Error al obtener documentos por proyecto: $e');
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
  Future<List<DocumentoModel>> getByTipo(String tipo) async {
    try {
      return await query('tipo = ?', [tipo]);
    } catch (e) {
      throw Exception('Error al obtener documentos por tipo: $e');
    }
  }

  // Método para buscar documentos por título
  Future<List<DocumentoModel>> buscarPorTitulo(String busqueda) async {
    try {
      return await query('titulo LIKE ?', ['%$busqueda%']);
    } catch (e) {
      throw Exception('Error al buscar documentos por título: $e');
    }
  }
}
