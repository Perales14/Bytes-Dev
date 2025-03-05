import 'dart:convert';
import 'package:zent/core/constants/db_constants.dart';
import 'package:zent/data/models/usuario_model.dart';

enum TipoOperacion { insert, update, delete }

class Auditoria {
  final int? id;
  final String tablaAfectada;
  final TipoOperacion? operacion;
  final int? idAfectado;
  final String? valoresAnteriores;
  final String? valoresNuevos;
  final int? usuarioId;
  final DateTime createdAt;
  final bool enviado;

  // Relaciones
  final Usuario? usuario;

  Auditoria({
    this.id,
    required this.tablaAfectada,
    this.operacion,
    this.idAfectado,
    this.valoresAnteriores,
    this.valoresNuevos,
    this.usuarioId,
    DateTime? createdAt,
    this.enviado = false,
    this.usuario,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Auditoria.fromJson(Map<String, dynamic> json,
      {bool fromSupabase = false}) {
    // Convertir string a enum para operación
    TipoOperacion? operacionEnum;
    String? operacionStr = json['operacion'];
    if (operacionStr != null) {
      switch (operacionStr) {
        case 'INSERT':
          operacionEnum = TipoOperacion.insert;
          break;
        case 'UPDATE':
          operacionEnum = TipoOperacion.update;
          break;
        case 'DELETE':
          operacionEnum = TipoOperacion.delete;
          break;
      }
    }

    return Auditoria(
      id: json[DbConstants.idColumn],
      tablaAfectada: json['tabla_afectada'],
      operacion: operacionEnum,
      idAfectado: json['id_afectado'],
      valoresAnteriores: json['valores_anteriores'],
      valoresNuevos: json['valores_nuevos'],
      usuarioId: json['usuario_id'],
      createdAt: json[DbConstants.createdAtColumn] != null
          ? DateTime.parse(json[DbConstants.createdAtColumn])
          : null,
      enviado: fromSupabase ? true : json[DbConstants.enviadoColumn] == 1,
    );
  }

  Map<String, dynamic> toJson({bool forSupabase = false}) {
    // Convertir enum a string para operación
    String? operacionStr;
    if (operacion != null) {
      switch (operacion) {
        case TipoOperacion.insert:
          operacionStr = 'INSERT';
          break;
        case TipoOperacion.update:
          operacionStr = 'UPDATE';
          break;
        case TipoOperacion.delete:
          operacionStr = 'DELETE';
          break;
        case null:
          // TODO: Handle this case.
          throw UnimplementedError();
      }
    }

    final map = {
      if (id != null) DbConstants.idColumn: id,
      'tabla_afectada': tablaAfectada,
      'operacion': operacionStr,
      'id_afectado': idAfectado,
      'valores_anteriores': valoresAnteriores,
      'valores_nuevos': valoresNuevos,
      'usuario_id': usuarioId,
      DbConstants.createdAtColumn: createdAt.toIso8601String(),
    };

    // Solo incluimos el campo enviado si es para SQLite
    if (!forSupabase) {
      map[DbConstants.enviadoColumn] = enviado ? 1 : 0;
    }

    return map;
  }

  Auditoria copyWith({
    int? id,
    String? tablaAfectada,
    TipoOperacion? operacion,
    int? idAfectado,
    String? valoresAnteriores,
    String? valoresNuevos,
    int? usuarioId,
    DateTime? createdAt,
    bool? enviado,
    Usuario? usuario,
  }) {
    return Auditoria(
      id: id ?? this.id,
      tablaAfectada: tablaAfectada ?? this.tablaAfectada,
      operacion: operacion ?? this.operacion,
      idAfectado: idAfectado ?? this.idAfectado,
      valoresAnteriores: valoresAnteriores ?? this.valoresAnteriores,
      valoresNuevos: valoresNuevos ?? this.valoresNuevos,
      usuarioId: usuarioId ?? this.usuarioId,
      createdAt: createdAt ?? this.createdAt,
      enviado: enviado ?? this.enviado,
      usuario: usuario ?? this.usuario,
    );
  }

  // Métodos de utilidad para trabajar con los valores anteriores/nuevos como objetos
  Map<String, dynamic>? get valoresAnterioresMap {
    if (valoresAnteriores == null) return null;
    try {
      return jsonDecode(valoresAnteriores!) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic>? get valoresNuevosMap {
    if (valoresNuevos == null) return null;
    try {
      return jsonDecode(valoresNuevos!) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  @override
  String toString() => 'Auditoria(id: $id, tablaAfectada: $tablaAfectada, '
      'operacion: $operacion, idAfectado: $idAfectado, '
      'usuarioId: $usuarioId, enviado: $enviado)';
}
