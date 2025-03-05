import 'package:zent/core/constants/db_constants.dart';
import 'package:zent/data/models/especialidad_model.dart';
import 'package:zent/data/models/estado_model.dart';
import 'package:zent/data/models/rol_model.dart';

enum TipoContrato { temporal, indefinido, porObra }

class Usuario {
  final int? id;
  final int rolId;
  final int? especialidadId;
  final String nombreCompleto;
  final String email;
  final String? telefono;
  final String nss;
  final String contrasenaHash;
  final DateTime fechaIngreso;
  final double? salario;
  final TipoContrato? tipoContrato;
  final int? supervisorId;
  final String? cargo;
  final String? departamento;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int estadoId;
  final bool enviado;

  // Relaciones - pueden ser nulos hasta que se carguen
  final Rol? rol;
  final Especialidad? especialidad;
  final Estado? estado;
  final Usuario? supervisor;

  Usuario({
    this.id,
    required this.rolId,
    this.especialidadId,
    required this.nombreCompleto,
    required this.email,
    this.telefono,
    required this.nss,
    required this.contrasenaHash,
    required this.fechaIngreso,
    this.salario,
    this.tipoContrato,
    this.supervisorId,
    this.cargo,
    this.departamento,
    DateTime? createdAt,
    DateTime? updatedAt,
    required this.estadoId,
    this.enviado = false,
    this.rol,
    this.especialidad,
    this.estado,
    this.supervisor,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        assert(nss.length == 11, 'NSS debe tener exactamente 11 caracteres');

  factory Usuario.fromJson(Map<String, dynamic> json) {
    String? tipoContratoStr = json['tipo_contrato'];
    TipoContrato? tipoContrato;

    if (tipoContratoStr != null) {
      switch (tipoContratoStr) {
        case 'Temporal':
          tipoContrato = TipoContrato.temporal;
          break;
        case 'Indefinido':
          tipoContrato = TipoContrato.indefinido;
          break;
        case 'Por Obra':
          tipoContrato = TipoContrato.porObra;
          break;
      }
    }

    return Usuario(
      id: json[DbConstants.idColumn],
      rolId: json['rol_id'],
      especialidadId: json['especialidad_id'],
      nombreCompleto: json['nombre_completo'],
      email: json['email'],
      telefono: json['telefono'],
      nss: json['nss'],
      contrasenaHash: json['contrasena_hash'],
      fechaIngreso: DateTime.parse(json['fecha_ingreso']),
      salario: json['salario'],
      tipoContrato: tipoContrato,
      supervisorId: json['supervisor_id'],
      cargo: json['cargo'],
      departamento: json['departamento'],
      createdAt: json[DbConstants.createdAtColumn] != null
          ? DateTime.parse(json[DbConstants.createdAtColumn])
          : null,
      updatedAt: json[DbConstants.updatedAtColumn] != null
          ? DateTime.parse(json[DbConstants.updatedAtColumn])
          : null,
      estadoId: json['estado_id'],
      enviado: json[DbConstants.enviadoColumn] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    String? tipoContratoStr;
    if (tipoContrato != null) {
      switch (tipoContrato) {
        case TipoContrato.temporal:
          tipoContratoStr = 'Temporal';
          break;
        case TipoContrato.indefinido:
          tipoContratoStr = 'Indefinido';
          break;
        case TipoContrato.porObra:
          tipoContratoStr = 'Por Obra';
          break;
        case null:
          throw UnimplementedError();
      }
    }

    return {
      if (id != null) DbConstants.idColumn: id,
      'rol_id': rolId,
      'especialidad_id': especialidadId,
      'nombre_completo': nombreCompleto,
      'email': email,
      'telefono': telefono,
      'nss': nss,
      'contrasena_hash': contrasenaHash,
      'fecha_ingreso': fechaIngreso.toIso8601String(),
      'salario': salario,
      'tipo_contrato': tipoContratoStr,
      'supervisor_id': supervisorId,
      'cargo': cargo,
      'departamento': departamento,
      DbConstants.createdAtColumn: createdAt.toIso8601String(),
      DbConstants.updatedAtColumn: updatedAt.toIso8601String(),
      'estado_id': estadoId,
      DbConstants.enviadoColumn: enviado ? 1 : 0,
    };
  }

  Usuario copyWith({
    int? id,
    int? rolId,
    int? especialidadId,
    String? nombreCompleto,
    String? email,
    String? telefono,
    String? nss,
    String? contrasenaHash,
    DateTime? fechaIngreso,
    double? salario,
    TipoContrato? tipoContrato,
    int? supervisorId,
    String? cargo,
    String? departamento,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? estadoId,
    bool? enviado,
    Rol? rol,
    Especialidad? especialidad,
    Estado? estado,
    Usuario? supervisor,
  }) {
    return Usuario(
      id: id ?? this.id,
      rolId: rolId ?? this.rolId,
      especialidadId: especialidadId ?? this.especialidadId,
      nombreCompleto: nombreCompleto ?? this.nombreCompleto,
      email: email ?? this.email,
      telefono: telefono ?? this.telefono,
      nss: nss ?? this.nss,
      contrasenaHash: contrasenaHash ?? this.contrasenaHash,
      fechaIngreso: fechaIngreso ?? this.fechaIngreso,
      salario: salario ?? this.salario,
      tipoContrato: tipoContrato ?? this.tipoContrato,
      supervisorId: supervisorId ?? this.supervisorId,
      cargo: cargo ?? this.cargo,
      departamento: departamento ?? this.departamento,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      estadoId: estadoId ?? this.estadoId,
      enviado: enviado ?? this.enviado,
      rol: rol ?? this.rol,
      especialidad: especialidad ?? this.especialidad,
      estado: estado ?? this.estado,
      supervisor: supervisor ?? this.supervisor,
    );
  }

  @override
  String toString() => 'Usuario(id: $id, nombreCompleto: $nombreCompleto, '
      'email: $email, nss: $nss, estadoId: $estadoId, enviado: $enviado)';
}
