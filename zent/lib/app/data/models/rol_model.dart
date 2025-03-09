import 'base_model.dart';

class RolModel extends BaseModel {
  String nombre;
  String? descripcion;

  RolModel({
    super.id = 0,
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
      'nombre': nombre,
      'descripcion': descripcion,
      'created_at': BaseModel.formatDateTime(createdAt),
      'updated_at': BaseModel.formatDateTime(updatedAt),
      'enviado': enviado ? 1 : 0,
    };
  }

  @override
  RolModel fromMap(Map<String, dynamic> map) {
    return RolModel(
      id: map['id'] ?? 0,
      nombre: map['nombre'] ?? '',
      descripcion: map['descripcion'],
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
      enviado: map['enviado'] == 1 || map['enviado'] == true,
    );
  }

  factory RolModel.fromJson(Map<String, dynamic> map) {
    return RolModel(
      id: map['id'] ?? 0,
      nombre: map['nombre'] ?? '',
      descripcion: map['descripcion'],
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
      enviado: map['enviado'] == 1 || map['enviado'] == true,
    );
  }
}
