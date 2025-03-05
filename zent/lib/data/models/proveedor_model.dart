import 'package:zent/core/constants/db_constants.dart';
import 'package:zent/data/models/direccion_model.dart';
import 'package:zent/data/models/especialidad_model.dart';
import 'package:zent/data/models/estado_model.dart';

class Proveedor {
  final int? id;
  final int especialidadId;
  final String nombreEmpresa;
  final String? contactoPrincipal;
  final String? telefono;
  final String? email;
  final String? rfc;
  final String? tipoServicio;
  final String? condicionesPago;
  final int? idDireccion;
  final int estadoId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool enviado;

  // Relaciones - pueden ser nulos hasta que se carguen
  final Direccion? direccion;
  final Estado? estado;
  final Especialidad? especialidad;

  Proveedor({
    this.id,
    required this.especialidadId,
    required this.nombreEmpresa,
    this.contactoPrincipal,
    this.telefono,
    this.email,
    this.rfc,
    this.tipoServicio,
    this.condicionesPago,
    this.idDireccion,
    required this.estadoId,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.enviado = false,
    this.direccion,
    this.estado,
    this.especialidad,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory Proveedor.fromJson(Map<String, dynamic> json,
      {bool fromSupabase = false}) {
    return Proveedor(
      id: json[DbConstants.idColumn],
      especialidadId: json['especialidad_id'],
      nombreEmpresa: json['nombre_empresa'],
      contactoPrincipal: json['contacto_principal'],
      telefono: json['telefono'],
      email: json['email'],
      rfc: json['rfc'],
      tipoServicio: json['tipo_servicio'],
      condicionesPago: json['condiciones_pago'],
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
      'especialidad_id': especialidadId,
      'nombre_empresa': nombreEmpresa,
      'contacto_principal': contactoPrincipal,
      'telefono': telefono,
      'email': email,
      'rfc': rfc,
      'tipo_servicio': tipoServicio,
      'condiciones_pago': condicionesPago,
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

  Proveedor copyWith({
    int? id,
    int? especialidadId,
    String? nombreEmpresa,
    String? contactoPrincipal,
    String? telefono,
    String? email,
    String? rfc,
    String? tipoServicio,
    String? condicionesPago,
    int? idDireccion,
    int? estadoId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? enviado,
    Direccion? direccion,
    Estado? estado,
    Especialidad? especialidad,
  }) {
    return Proveedor(
      id: id ?? this.id,
      especialidadId: especialidadId ?? this.especialidadId,
      nombreEmpresa: nombreEmpresa ?? this.nombreEmpresa,
      contactoPrincipal: contactoPrincipal ?? this.contactoPrincipal,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      rfc: rfc ?? this.rfc,
      tipoServicio: tipoServicio ?? this.tipoServicio,
      condicionesPago: condicionesPago ?? this.condicionesPago,
      idDireccion: idDireccion ?? this.idDireccion,
      estadoId: estadoId ?? this.estadoId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      enviado: enviado ?? this.enviado,
      direccion: direccion ?? this.direccion,
      estado: estado ?? this.estado,
      especialidad: especialidad ?? this.especialidad,
    );
  }

  @override
  String toString() => 'Proveedor(id: $id, nombreEmpresa: $nombreEmpresa, '
      'especialidadId: $especialidadId, enviado: $enviado)';
}
