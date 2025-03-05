import 'package:zent/core/constants/db_constants.dart';
import 'package:zent/data/models/cliente_model.dart';
import 'package:zent/data/models/direccion_model.dart';
import 'package:zent/data/models/estado_model.dart';
import 'package:zent/data/models/proveedor_model.dart';
import 'package:zent/data/models/usuario_model.dart';

class Proyecto {
  final int? id;
  final String nombre;
  final String? descripcion;
  final int clienteId;
  final int responsableId;
  final int? proveedorId;
  final DateTime? fechaInicio;
  final DateTime? fechaFinEstimada;
  final DateTime? fechaFinReal;
  final DateTime? fechaEntrega;
  final double? presupuestoEstimado;
  final double? costoReal;
  final double? comisionPorcentaje;
  final double? comisionConsultoria;
  final int? idDireccion;
  final int estadoId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool enviado;

  // Relaciones - pueden ser nulos hasta que se carguen
  final Cliente? cliente;
  final Usuario? responsable;
  final Proveedor? proveedor;
  final Direccion? direccion;
  final Estado? estado;

  Proyecto({
    this.id,
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
    this.comisionConsultoria,
    this.idDireccion,
    required this.estadoId,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.enviado = false,
    this.cliente,
    this.responsable,
    this.proveedor,
    this.direccion,
    this.estado,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory Proyecto.fromJson(Map<String, dynamic> json,
      {bool fromSupabase = false}) {
    return Proyecto(
      id: json[DbConstants.idColumn],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      clienteId: json['cliente_id'],
      responsableId: json['responsable_id'],
      proveedorId: json['proveedor_id'],
      fechaInicio: json['fecha_inicio'] != null
          ? DateTime.parse(json['fecha_inicio'])
          : null,
      fechaFinEstimada: json['fecha_fin_estimada'] != null
          ? DateTime.parse(json['fecha_fin_estimada'])
          : null,
      fechaFinReal: json['fecha_fin_real'] != null
          ? DateTime.parse(json['fecha_fin_real'])
          : null,
      fechaEntrega: json['fecha_entrega'] != null
          ? DateTime.parse(json['fecha_entrega'])
          : null,
      presupuestoEstimado: json['presupuesto_estimado'],
      costoReal: json['costo_real'],
      comisionPorcentaje: json['comision_porcentaje'],
      comisionConsultoria: json['comision_consultoria'],
      idDireccion: json['id_direccion'],
      estadoId: json['estado_id'],
      createdAt: json[DbConstants.createdAtColumn] != null
          ? DateTime.parse(json[DbConstants.createdAtColumn])
          : null,
      updatedAt: json[DbConstants.updatedAtColumn] != null
          ? DateTime.parse(json[DbConstants.updatedAtColumn])
          : null,
      enviado: fromSupabase ? true : json[DbConstants.enviadoColumn] == 1,
    );
  }

  Map<String, dynamic> toJson({bool forSupabase = false}) {
    final map = {
      if (id != null) DbConstants.idColumn: id,
      'nombre': nombre,
      'descripcion': descripcion,
      'cliente_id': clienteId,
      'responsable_id': responsableId,
      'proveedor_id': proveedorId,
      'fecha_inicio': fechaInicio?.toIso8601String(),
      'fecha_fin_estimada': fechaFinEstimada?.toIso8601String(),
      'fecha_fin_real': fechaFinReal?.toIso8601String(),
      'fecha_entrega': fechaEntrega?.toIso8601String(),
      'presupuesto_estimado': presupuestoEstimado,
      'costo_real': costoReal,
      'comision_porcentaje': comisionPorcentaje,
      'comision_consultoria': comisionConsultoria,
      'id_direccion': idDireccion,
      'estado_id': estadoId,
      DbConstants.createdAtColumn: createdAt.toIso8601String(),
      DbConstants.updatedAtColumn: updatedAt.toIso8601String(),
    };

    // Solo incluimos el campo enviado si es para SQLite (no para Supabase)
    if (!forSupabase) {
      map[DbConstants.enviadoColumn] = enviado ? 1 : 0;
    }

    return map;
  }

  Proyecto copyWith({
    int? id,
    String? nombre,
    String? descripcion,
    int? clienteId,
    int? responsableId,
    int? proveedorId,
    DateTime? fechaInicio,
    DateTime? fechaFinEstimada,
    DateTime? fechaFinReal,
    DateTime? fechaEntrega,
    double? presupuestoEstimado,
    double? costoReal,
    double? comisionPorcentaje,
    double? comisionConsultoria,
    int? idDireccion,
    int? estadoId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? enviado,
    Cliente? cliente,
    Usuario? responsable,
    Proveedor? proveedor,
    Direccion? direccion,
    Estado? estado,
  }) {
    return Proyecto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      clienteId: clienteId ?? this.clienteId,
      responsableId: responsableId ?? this.responsableId,
      proveedorId: proveedorId ?? this.proveedorId,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFinEstimada: fechaFinEstimada ?? this.fechaFinEstimada,
      fechaFinReal: fechaFinReal ?? this.fechaFinReal,
      fechaEntrega: fechaEntrega ?? this.fechaEntrega,
      presupuestoEstimado: presupuestoEstimado ?? this.presupuestoEstimado,
      costoReal: costoReal ?? this.costoReal,
      comisionPorcentaje: comisionPorcentaje ?? this.comisionPorcentaje,
      comisionConsultoria: comisionConsultoria ?? this.comisionConsultoria,
      idDireccion: idDireccion ?? this.idDireccion,
      estadoId: estadoId ?? this.estadoId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      enviado: enviado ?? this.enviado,
      cliente: cliente ?? this.cliente,
      responsable: responsable ?? this.responsable,
      proveedor: proveedor ?? this.proveedor,
      direccion: direccion ?? this.direccion,
      estado: estado ?? this.estado,
    );
  }

  // Calcular ganancia estimada
  double? get gananciaEstimada {
    if (presupuestoEstimado == null || costoReal == null) return null;
    return presupuestoEstimado! - costoReal!;
  }

  // Calcular monto de comisión si tenemos porcentaje
  double? get montoComision {
    if (presupuestoEstimado == null || comisionPorcentaje == null) return null;
    return presupuestoEstimado! * (comisionPorcentaje! / 100);
  }

  @override
  String toString() =>
      'Proyecto(id: $id, nombre: $nombre, clienteId: $clienteId, '
      'responsableId: $responsableId, estado: $estadoId, enviado: $enviado)';
}
