import 'base_model.dart';

class PermisoModel extends BaseModel {
  int rolId;
  Map<String, dynamic>? permisosJson;

  PermisoModel({
    required this.rolId,
    this.permisosJson,
    super.createdAt,
    super.updatedAt,
    super.enviado = false,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'rol_id': rolId,
      'permisos_json': permisosJson,
      'created_at': BaseModel.formatDateTime(createdAt),
      'updated_at': BaseModel.formatDateTime(updatedAt),
      'enviado': enviado ? 1 : 0,
    };
  }

  @override
  PermisoModel fromMap(Map<String, dynamic> map) {
    return PermisoModel(
      rolId: map['rol_id'] ?? 0,
      permisosJson: map['permisos_json'] != null
          ? Map<String, dynamic>.from(map['permisos_json'])
          : null,
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
      enviado: map['enviado'] == 1 || map['enviado'] == true,
    );
  }

  factory PermisoModel.fromJson(Map<String, dynamic> map) {
    return PermisoModel(
      rolId: map['rol_id'] ?? 0,
      permisosJson: map['permisos_json'] != null
          ? Map<String, dynamic>.from(map['permisos_json'])
          : null,
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
      enviado: map['enviado'] == 1 || map['enviado'] == true,
    );
  }

  // Override getter for id to use rolId instead
  @override
  int get id => rolId;

  // Override setter for id to set rolId instead
  @override
  set id(int value) {
    rolId = value;
  }
}
