import 'package:zent/core/constants/db_constants.dart';

class Especialidad {
  final int? id;
  final String nombre;
  final String? descripcion;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool enviado;

  Especialidad({
    this.id,
    required this.nombre,
    this.descripcion,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.enviado = false,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Constructor desde mapa/json
  factory Especialidad.fromJson(Map<String, dynamic> json) {
    return Especialidad(
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

  // Convertir a mapa/json
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

  // Crear copia con campos actualizados
  Especialidad copyWith({
    int? id,
    String? nombre,
    String? descripcion,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? enviado,
  }) {
    return Especialidad(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      enviado: enviado ?? this.enviado,
    );
  }

  @override
  String toString() => 'Especialidad(id: $id, nombre: $nombre, '
      'descripcion: $descripcion, enviado: $enviado)';
}
