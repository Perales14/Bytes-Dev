import 'dart:convert';
import 'package:zent/core/constants/db_constants.dart';
import 'package:zent/data/models/rol_model.dart';

class Permiso {
  final int rolId;
  final Map<String, dynamic>? permisosJson;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool enviado;

  // Relaciones
  final Rol? rol;

  Permiso({
    required this.rolId,
    this.permisosJson,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.enviado = false,
    this.rol,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory Permiso.fromJson(Map<String, dynamic> json,
      {bool fromSupabase = false}) {
    Map<String, dynamic>? permisosParsed;
    if (json['permisos_json'] != null) {
      try {
        permisosParsed =
            jsonDecode(json['permisos_json']) as Map<String, dynamic>;
      } catch (e) {
        permisosParsed = null;
      }
    }

    return Permiso(
      rolId: json['rol_id'],
      permisosJson: permisosParsed,
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
      'rol_id': rolId,
      'permisos_json': permisosJson != null ? jsonEncode(permisosJson) : null,
      DbConstants.createdAtColumn: createdAt.toIso8601String(),
      DbConstants.updatedAtColumn: updatedAt.toIso8601String(),
    };

    // Solo incluimos el campo enviado si es para SQLite
    if (!forSupabase) {
      map[DbConstants.enviadoColumn] = enviado ? 1 : 0;
    }

    return map;
  }

  Permiso copyWith({
    int? rolId,
    Map<String, dynamic>? permisosJson,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? enviado,
    Rol? rol,
  }) {
    return Permiso(
      rolId: rolId ?? this.rolId,
      permisosJson: permisosJson ?? this.permisosJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      enviado: enviado ?? this.enviado,
      rol: rol ?? this.rol,
    );
  }

  // Métodos de utilidad para trabajar con permisos
  bool tienePermiso(String modulo, String accion) {
    if (permisosJson == null) return false;

    final permisoModulo = permisosJson![modulo];
    if (permisoModulo == null) return false;

    return permisoModulo[accion] == true;
  }

  @override
  String toString() => 'Permiso(rolId: $rolId, '
      'permisosJson: ${permisosJson?.keys.length ?? 0} permisos definidos, '
      'enviado: $enviado)';
}
