import 'package:zent/core/constants/db_constants.dart';
import 'package:zent/data/models/usuario_model.dart';

class Observacion {
  final int? id;
  final String tablaOrigen;
  final int idOrigen;
  final String observacion;
  final int usuarioId;
  final DateTime createdAt;
  final bool enviado;

  // Relaciones
  final Usuario? usuario;

  Observacion({
    this.id,
    required this.tablaOrigen,
    required this.idOrigen,
    required this.observacion,
    required this.usuarioId,
    DateTime? createdAt,
    this.enviado = false,
    this.usuario,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Observacion.fromJson(Map<String, dynamic> json,
      {bool fromSupabase = false}) {
    return Observacion(
      id: json[DbConstants.idColumn],
      tablaOrigen: json['tabla_origen'],
      idOrigen: json['id_origen'],
      observacion: json['observacion'],
      usuarioId: json['usuario_id'],
      createdAt: json[DbConstants.createdAtColumn] != null
          ? DateTime.parse(json[DbConstants.createdAtColumn])
          : null,
      enviado: fromSupabase ? true : json[DbConstants.enviadoColumn] == 1,
    );
  }

  Map<String, dynamic> toJson({bool forSupabase = false}) {
    final map = {
      if (id != null) DbConstants.idColumn: id,
      'tabla_origen': tablaOrigen,
      'id_origen': idOrigen,
      'observacion': observacion,
      'usuario_id': usuarioId,
      DbConstants.createdAtColumn: createdAt.toIso8601String(),
    };

    // Solo incluimos el campo enviado si es para SQLite
    if (!forSupabase) {
      map[DbConstants.enviadoColumn] = enviado ? 1 : 0;
    }

    return map;
  }

  Observacion copyWith({
    int? id,
    String? tablaOrigen,
    int? idOrigen,
    String? observacion,
    int? usuarioId,
    DateTime? createdAt,
    bool? enviado,
    Usuario? usuario,
  }) {
    return Observacion(
      id: id ?? this.id,
      tablaOrigen: tablaOrigen ?? this.tablaOrigen,
      idOrigen: idOrigen ?? this.idOrigen,
      observacion: observacion ?? this.observacion,
      usuarioId: usuarioId ?? this.usuarioId,
      createdAt: createdAt ?? this.createdAt,
      enviado: enviado ?? this.enviado,
      usuario: usuario ?? this.usuario,
    );
  }

  @override
  String toString() => 'Observacion(id: $id, '
      'tablaOrigen: $tablaOrigen, idOrigen: $idOrigen, '
      'observacion: ${observacion.substring(0, observacion.length > 20 ? 20 : observacion.length)}..., '
      'usuarioId: $usuarioId, enviado: $enviado)';
}
