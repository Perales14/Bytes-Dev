import 'package:zent/core/constants/db_constants.dart';
import 'package:zent/data/models/direccion_model.dart';
import 'package:zent/data/models/estado_model.dart';

enum TipoCliente { particular, empresa, gobierno }

class Cliente {
  final int? id;
  final String? nombreEmpresa;
  final String? telefono;
  final String? email;
  final String? rfc;
  final TipoCliente? tipo;
  final String nombre;
  final String apellidoPaterno;
  final String? apellidoMaterno;
  final int? idDireccion;
  final int estadoId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool enviado;

  // Relaciones - pueden ser nulos hasta que se carguen
  final Direccion? direccion;
  final Estado? estado;

  Cliente({
    this.id,
    this.nombreEmpresa,
    this.telefono,
    this.email,
    this.rfc,
    this.tipo,
    required this.nombre,
    required this.apellidoPaterno,
    this.apellidoMaterno,
    this.idDireccion,
    required this.estadoId,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.enviado = false,
    this.direccion,
    this.estado,
  })  : assert(
            telefono != null || email != null, 'Se requiere teléfono o email'),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory Cliente.fromJson(Map<String, dynamic> json,
      {bool fromSupabase = false}) {
    String? tipoStr = json['tipo'];
    TipoCliente? tipo;

    if (tipoStr != null) {
      switch (tipoStr) {
        case 'Particular':
          tipo = TipoCliente.particular;
          break;
        case 'Empresa':
          tipo = TipoCliente.empresa;
          break;
        case 'Gobierno':
          tipo = TipoCliente.gobierno;
          break;
      }
    }

    return Cliente(
      id: json[DbConstants.idColumn],
      nombreEmpresa: json['nombre_empresa'],
      telefono: json['telefono'],
      email: json['email'],
      rfc: json['rfc'],
      tipo: tipo,
      nombre: json['nombre'],
      apellidoPaterno: json['apellido_paterno'],
      apellidoMaterno: json['apellido_materno'],
      idDireccion: json['id_direccion'],
      estadoId: json['estado_id'],
      createdAt: json[DbConstants.createdAtColumn] != null
          ? DateTime.parse(json[DbConstants.createdAtColumn])
          : null,
      updatedAt: json[DbConstants.updatedAtColumn] != null
          ? DateTime.parse(json[DbConstants.updatedAtColumn])
          : null,
      // Si viene de Supabase, marcamos como enviado por defecto
      enviado: fromSupabase ? true : json[DbConstants.enviadoColumn] == 1,
    );
  }

  Map<String, dynamic> toJson({bool forSupabase = false}) {
    String? tipoStr;
    if (tipo != null) {
      switch (tipo) {
        case TipoCliente.particular:
          tipoStr = 'Particular';
          break;
        case TipoCliente.empresa:
          tipoStr = 'Empresa';
          break;
        case TipoCliente.gobierno:
          tipoStr = 'Gobierno';
          break;
        case null:
          throw UnimplementedError();
      }
    }

    final map = {
      if (id != null) DbConstants.idColumn: id,
      'nombre_empresa': nombreEmpresa,
      'telefono': telefono,
      'email': email,
      'rfc': rfc,
      'tipo': tipoStr,
      'nombre': nombre,
      'apellido_paterno': apellidoPaterno,
      'apellido_materno': apellidoMaterno,
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

  Cliente copyWith({
    int? id,
    String? nombreEmpresa,
    String? telefono,
    String? email,
    String? rfc,
    TipoCliente? tipo,
    String? nombre,
    String? apellidoPaterno,
    String? apellidoMaterno,
    int? idDireccion,
    int? estadoId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? enviado,
    Direccion? direccion,
    Estado? estado,
  }) {
    return Cliente(
      id: id ?? this.id,
      nombreEmpresa: nombreEmpresa ?? this.nombreEmpresa,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      rfc: rfc ?? this.rfc,
      tipo: tipo ?? this.tipo,
      nombre: nombre ?? this.nombre,
      apellidoPaterno: apellidoPaterno ?? this.apellidoPaterno,
      apellidoMaterno: apellidoMaterno ?? this.apellidoMaterno,
      idDireccion: idDireccion ?? this.idDireccion,
      estadoId: estadoId ?? this.estadoId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      enviado: enviado ?? this.enviado,
      direccion: direccion ?? this.direccion,
      estado: estado ?? this.estado,
    );
  }

  String get nombreCompleto =>
      '$nombre $apellidoPaterno${apellidoMaterno != null ? ' $apellidoMaterno' : ''}';

  @override
  String toString() => 'Cliente(id: $id, nombre: $nombreCompleto, '
      'empresa: $nombreEmpresa, tipo: $tipo, enviado: $enviado)';
}
