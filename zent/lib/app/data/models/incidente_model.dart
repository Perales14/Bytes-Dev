import 'base_model.dart';

class IncidenteModel extends BaseModel {
  int proyectoId;
  String? tipo;
  String descripcion;
  String? impacto;
  String? acciones;
  String? estado;

  IncidenteModel({
    super.id = 0,
    required this.proyectoId,
    this.tipo,
    required this.descripcion,
    this.impacto,
    this.acciones,
    this.estado,
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
      'descripcion': descripcion,
      'impacto': impacto,
      'acciones': acciones,
      'estado': estado,
      'created_at': BaseModel.formatDateTime(createdAt),
      'updated_at': BaseModel.formatDateTime(updatedAt),
      'enviado': enviado ? 1 : 0,
    };
  }

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

  factory IncidenteModel.fromJson(Map<String, dynamic> map) {
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
}
