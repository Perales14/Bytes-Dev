import 'package:zent/core/constants/db_constants.dart';

class Estado {
  final int? id;
  final String tabla;
  final String codigo;
  final String nombre;
  final String? descripcion;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool enviado;

  Estado({
    this.id,
    required this.tabla,
    required this.codigo,
    required this.nombre,
    this.descripcion,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.enviado = false,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory Estado.fromJson(Map<String, dynamic> json) {
    return Estado(
      id: json[DbConstants.idColumn],
      tabla: json['tabla'],
      codigo: json['codigo'],
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
      'tabla': tabla,
      'codigo': codigo,
      'nombre': nombre,
      'descripcion': descripcion,
      DbConstants.createdAtColumn: createdAt.toIso8601String(),
      DbConstants.updatedAtColumn: updatedAt.toIso8601String(),
      DbConstants.enviadoColumn: enviado ? 1 : 0,
    };
  }

  Estado copyWith({
    int? id,
    String? tabla,
    String? codigo,
    String? nombre,
    String? descripcion,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? enviado,
  }) {
    return Estado(
      id: id ?? this.id,
      tabla: tabla ?? this.tabla,
      codigo: codigo ?? this.codigo,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      enviado: enviado ?? this.enviado,
    );
  }

  @override
  String toString() => 'Estado(id: $id, tabla: $tabla, '
      'codigo: $codigo, nombre: $nombre, enviado: $enviado)';
}
