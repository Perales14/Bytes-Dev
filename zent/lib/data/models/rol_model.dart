import 'package:zent/core/constants/db_constants.dart';

class Rol {
  final int? id;
  final String nombre;
  final String? descripcion;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool enviado;

  Rol({
    this.id,
    required this.nombre,
    this.descripcion,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.enviado = false,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory Rol.fromJson(Map<String, dynamic> json) {
    return Rol(
      id: json[DbConstants.idColumn],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      createdAt: json[DbConstants.createdAtColumn] != null
          ? DateTime.parse(json[DbConstants.createdAtColumn])
          : null,
      updatedAt: json[DbConstants.updatedAtColumn] != null
          ? DateTime.parse(json[DbConstants.updatedAtColumn])
          : null,
      enviado: json[DbConstants.enviadoColumn] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) DbConstants.idColumn: id,
      'nombre': nombre,
      'descripcion': descripcion,
      DbConstants.createdAtColumn: createdAt.toIso8601String(),
      DbConstants.updatedAtColumn: updatedAt.toIso8601String(),
      DbConstants.enviadoColumn: enviado ? 1 : 0,
    };
  }

  Rol copyWith({
    int? id,
    String? nombre,
    String? descripcion,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? enviado,
  }) {
    return Rol(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      enviado: enviado ?? this.enviado,
    );
  }

  @override
  String toString() =>
      'Rol(id: $id, nombre: $nombre, descripcion: $descripcion, enviado: $enviado)';
}
