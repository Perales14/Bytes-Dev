import 'base_model.dart';

class ProyectoModel extends BaseModel {
  String nombre;
  String? descripcion;
  int clienteId;
  int responsableId;
  int? proveedorId;
  DateTime? fechaInicio;
  DateTime? fechaFinEstimada;
  DateTime? fechaFinReal;
  DateTime? fechaEntrega;
  double? presupuestoEstimado;
  double? costoReal;
  double? comisionPorcentaje;
  int? idDireccion;
  int estadoId;

  ProyectoModel({
    super.id = 0,
    required this.nombre,
    this.descripcion,
    required this.clienteId,
    required this.responsableId,
    this.proveedorId,
    this.fechaInicio,
    this.fechaFinEstimada,
    this.fechaFinReal,
    this.fechaEntrega,
    this.presupuestoEstimado,
    this.costoReal,
    this.comisionPorcentaje,
    this.idDireccion,
    required this.estadoId,
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
      'cliente_id': clienteId,
      'responsable_id': responsableId,
      'proveedor_id': proveedorId,
      'fecha_inicio':
          fechaInicio != null ? BaseModel.formatDateTime(fechaInicio!) : null,
      'fecha_fin_estimada': fechaFinEstimada != null
          ? BaseModel.formatDateTime(fechaFinEstimada!)
          : null,
      'fecha_fin_real':
          fechaFinReal != null ? BaseModel.formatDateTime(fechaFinReal!) : null,
      'fecha_entrega':
          fechaEntrega != null ? BaseModel.formatDateTime(fechaEntrega!) : null,
      'presupuesto_estimado': presupuestoEstimado,
      'costo_real': costoReal,
      'comision_porcentaje': comisionPorcentaje,
      'id_direccion': idDireccion,
      'estado_id': estadoId,
      'created_at': BaseModel.formatDateTime(createdAt),
      'updated_at': BaseModel.formatDateTime(updatedAt),
      'enviado': enviado ? 1 : 0,
    };
  }

  @override
  ProyectoModel fromMap(Map<String, dynamic> map) {
    return ProyectoModel(
      id: map['id'] ?? 0,
      nombre: map['nombre'] ?? '',
      descripcion: map['descripcion'],
      clienteId: map['cliente_id'] ?? 0,
      responsableId: map['responsable_id'] ?? 0,
      proveedorId: map['proveedor_id'],
      fechaInicio: BaseModel.parseDateTime(map['fecha_inicio']),
      fechaFinEstimada: BaseModel.parseDateTime(map['fecha_fin_estimada']),
      fechaFinReal: BaseModel.parseDateTime(map['fecha_fin_real']),
      fechaEntrega: BaseModel.parseDateTime(map['fecha_entrega']),
      presupuestoEstimado: map['presupuesto_estimado'],
      costoReal: map['costo_real'],
      comisionPorcentaje: map['comision_porcentaje'],
      idDireccion: map['id_direccion'],
      estadoId: map['estado_id'] ?? 0,
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
      enviado: map['enviado'] == 1 || map['enviado'] == true,
    );
  }

  factory ProyectoModel.fromJson(Map<String, dynamic> map) {
    return ProyectoModel(
      id: map['id'] ?? 0,
      nombre: map['nombre'] ?? '',
      descripcion: map['descripcion'],
      clienteId: map['cliente_id'] ?? 0,
      responsableId: map['responsable_id'] ?? 0,
      proveedorId: map['proveedor_id'],
      fechaInicio: BaseModel.parseDateTime(map['fecha_inicio']),
      fechaFinEstimada: BaseModel.parseDateTime(map['fecha_fin_estimada']),
      fechaFinReal: BaseModel.parseDateTime(map['fecha_fin_real']),
      fechaEntrega: BaseModel.parseDateTime(map['fecha_entrega']),
      presupuestoEstimado: map['presupuesto_estimado'],
      costoReal: map['costo_real'],
      comisionPorcentaje: map['comision_porcentaje'],
      idDireccion: map['id_direccion'],
      estadoId: map['estado_id'] ?? 0,
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
      enviado: map['enviado'] == 1 || map['enviado'] == true,
    );
  }
}
