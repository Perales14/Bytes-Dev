import 'base_model.dart';

class DocumentoModel extends BaseModel {
  int? proyectoId;
  String? tipo;
  String titulo;
  String? contenido;
  String? archivoUrl;
  int usuarioId;

  DocumentoModel({
    super.id = 0,
    this.proyectoId,
    this.tipo,
    required this.titulo,
    this.contenido,
    this.archivoUrl,
    required this.usuarioId,
    super.createdAt,
    super.updatedAt,
    super.enviado = false,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'proyecto_id': proyectoId,
      'tipo': tipo,
      'titulo': titulo,
      'contenido': contenido,
      'archivo_url': archivoUrl,
      'usuario_id': usuarioId,
      'created_at': BaseModel.formatDateTime(createdAt),
      'updated_at': BaseModel.formatDateTime(updatedAt),
      'enviado': enviado ? 1 : 0,
    };
  }

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

  factory DocumentoModel.fromJson(Map<String, dynamic> map) {
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
}
