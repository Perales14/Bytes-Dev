import 'base_model.dart';

class ActividadModel extends BaseModel {
  int proyectoId;
  String descripcion;
  int? responsableId;
  DateTime? fechaInicio;
  DateTime? fechaFin;
  int? dependenciaId;
  List<String>? evidencias;
  int estadoId;

  ActividadModel({
    super.id = 0,
    required this.proyectoId,
    required this.descripcion,
    this.responsableId,
    this.fechaInicio,
    this.fechaFin,
    this.dependenciaId,
    this.evidencias,
    required this.estadoId,
    super.createdAt,
    super.updatedAt,
    super.enviado = false,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'proyecto_id': proyectoId,
      'descripcion': descripcion,
      'responsable_id': responsableId,
      'fecha_inicio':
          fechaInicio != null ? BaseModel.formatDateTime(fechaInicio!) : null,
      'fecha_fin':
          fechaFin != null ? BaseModel.formatDateTime(fechaFin!) : null,
      'dependencia_id': dependenciaId,
      'evidencias': evidencias,
      'estado_id': estadoId,
      'created_at': BaseModel.formatDateTime(createdAt),
      'updated_at': BaseModel.formatDateTime(updatedAt),
      'enviado': enviado ? 1 : 0,
    };
  }

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

  factory ActividadModel.fromJson(Map<String, dynamic> map) {
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
}
