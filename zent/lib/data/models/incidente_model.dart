import 'package:zent/core/constants/db_constants.dart';
import 'package:zent/data/models/proyecto_model.dart';

enum TipoIncidente { accidente, retraso, fallaTecnica, otro }

enum ImpactoIncidente { bajo, medio, alto }

enum EstadoIncidente { abierto, enProceso, resuelto }

class Incidente {
  final int? id;
  final int proyectoId;
  final TipoIncidente? tipo;
  final String descripcion;
  final ImpactoIncidente? impacto;
  final String? acciones;
  final EstadoIncidente? estado;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool enviado;

  // Relaciones
  final Proyecto? proyecto;

  Incidente({
    this.id,
    required this.proyectoId,
    this.tipo,
    required this.descripcion,
    this.impacto,
    this.acciones,
    this.estado,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.enviado = false,
    this.proyecto,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory Incidente.fromJson(Map<String, dynamic> json,
      {bool fromSupabase = false}) {
    // Convertir string a enum para tipo
    TipoIncidente? tipoEnum;
    String? tipoStr = json['tipo'];
    if (tipoStr != null) {
      switch (tipoStr) {
        case 'Accidente':
          tipoEnum = TipoIncidente.accidente;
          break;
        case 'Retraso':
          tipoEnum = TipoIncidente.retraso;
          break;
        case 'Falla Técnica':
          tipoEnum = TipoIncidente.fallaTecnica;
          break;
        case 'Otro':
          tipoEnum = TipoIncidente.otro;
          break;
      }
    }

    // Convertir string a enum para impacto
    ImpactoIncidente? impactoEnum;
    String? impactoStr = json['impacto'];
    if (impactoStr != null) {
      switch (impactoStr) {
        case 'Bajo':
          impactoEnum = ImpactoIncidente.bajo;
          break;
        case 'Medio':
          impactoEnum = ImpactoIncidente.medio;
          break;
        case 'Alto':
          impactoEnum = ImpactoIncidente.alto;
          break;
      }
    }

    // Convertir string a enum para estado
    EstadoIncidente? estadoEnum;
    String? estadoStr = json['estado'];
    if (estadoStr != null) {
      switch (estadoStr) {
        case 'Abierto':
          estadoEnum = EstadoIncidente.abierto;
          break;
        case 'En Proceso':
          estadoEnum = EstadoIncidente.enProceso;
          break;
        case 'Resuelto':
          estadoEnum = EstadoIncidente.resuelto;
          break;
      }
    }

    return Incidente(
      id: json[DbConstants.idColumn],
      proyectoId: json['proyecto_id'],
      tipo: tipoEnum,
      descripcion: json['descripcion'],
      impacto: impactoEnum,
      acciones: json['acciones'],
      estado: estadoEnum,
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
    // Convertir enum a string para tipo
    String? tipoStr;
    if (tipo != null) {
      switch (tipo) {
        case TipoIncidente.accidente:
          tipoStr = 'Accidente';
          break;
        case TipoIncidente.retraso:
          tipoStr = 'Retraso';
          break;
        case TipoIncidente.fallaTecnica:
          tipoStr = 'Falla Técnica';
          break;
        case TipoIncidente.otro:
          tipoStr = 'Otro';
          break;
        case null:
          // TODO: Handle this case.
          throw UnimplementedError();
      }
    }

    // Convertir enum a string para impacto
    String? impactoStr;
    if (impacto != null) {
      switch (impacto) {
        case ImpactoIncidente.bajo:
          impactoStr = 'Bajo';
          break;
        case ImpactoIncidente.medio:
          impactoStr = 'Medio';
          break;
        case ImpactoIncidente.alto:
          impactoStr = 'Alto';
          break;
        case null:
          // TODO: Handle this case.
          throw UnimplementedError();
      }
    }

    // Convertir enum a string para estado
    String? estadoStr;
    if (estado != null) {
      switch (estado) {
        case EstadoIncidente.abierto:
          estadoStr = 'Abierto';
          break;
        case EstadoIncidente.enProceso:
          estadoStr = 'En Proceso';
          break;
        case EstadoIncidente.resuelto:
          estadoStr = 'Resuelto';
          break;
        case null:
          // TODO: Handle this case.
          throw UnimplementedError();
      }
    }

    final map = {
      if (id != null) DbConstants.idColumn: id,
      'proyecto_id': proyectoId,
      'tipo': tipoStr,
      'descripcion': descripcion,
      'impacto': impactoStr,
      'acciones': acciones,
      'estado': estadoStr,
      DbConstants.createdAtColumn: createdAt.toIso8601String(),
      DbConstants.updatedAtColumn: updatedAt.toIso8601String(),
    };

    // Solo incluimos el campo enviado si es para SQLite
    if (!forSupabase) {
      map[DbConstants.enviadoColumn] = enviado ? 1 : 0;
    }

    return map;
  }

  Incidente copyWith({
    int? id,
    int? proyectoId,
    TipoIncidente? tipo,
    String? descripcion,
    ImpactoIncidente? impacto,
    String? acciones,
    EstadoIncidente? estado,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? enviado,
    Proyecto? proyecto,
  }) {
    return Incidente(
      id: id ?? this.id,
      proyectoId: proyectoId ?? this.proyectoId,
      tipo: tipo ?? this.tipo,
      descripcion: descripcion ?? this.descripcion,
      impacto: impacto ?? this.impacto,
      acciones: acciones ?? this.acciones,
      estado: estado ?? this.estado,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      enviado: enviado ?? this.enviado,
      proyecto: proyecto ?? this.proyecto,
    );
  }

  @override
  String toString() => 'Incidente(id: $id, proyectoId: $proyectoId, '
      'tipo: $tipo, descripcion: ${descripcion.substring(0, descripcion.length > 20 ? 20 : descripcion.length)}..., '
      'estado: $estado, enviado: $enviado)';
}
