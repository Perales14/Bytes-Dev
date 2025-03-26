import 'base_model.dart';

class EstadoModel extends BaseModel {
  String tabla;
  String codigo;
  String nombre;
  String? descripcion;

  EstadoModel({
    super.id = 0,
    required this.tabla,
    required this.codigo,
    required this.nombre,
    this.descripcion,
    super.createdAt,
    super.updatedAt,
    super.enviado = false,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tabla': tabla,
      'codigo': codigo,
      'nombre': nombre,
      'descripcion': descripcion,
      'created_at': BaseModel.formatDateTime(createdAt),
      'updated_at': BaseModel.formatDateTime(updatedAt),
      'enviado': enviado ? 1 : 0,
    };
  }

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

  factory EstadoModel.fromJson(Map<String, dynamic> map) {
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
}
