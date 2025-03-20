import 'base_model.dart';

class UsuarioModel extends BaseModel {
  int rolId;
  int? especialidadId;
  String nombreCompleto;
  String email;
  String? telefono;
  String nss;
  String contrasenaHash;
  DateTime fechaIngreso;
  double? salario;
  String? tipoContrato;
  int? supervisorId;
  // String? cargo;
  String? departamento;
  int estadoId;

  UsuarioModel({
    super.id = 3,
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
    // this.cargo,
    this.departamento,
    required this.estadoId,
    super.createdAt,
    super.updatedAt,
    super.enviado = false,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rol_id': rolId,
      'especialidad_id': especialidadId,
      'nombre_completo': nombreCompleto,
      'email': email,
      'telefono': telefono,
      'nss': nss,
      'contrasena_hash': contrasenaHash,
      'fecha_ingreso': BaseModel.formatDateTime(fechaIngreso),
      'salario': salario,
      'tipo_contrato': tipoContrato,
      'supervisor_id': supervisorId,
      // 'cargo': cargo,
      'departamento': departamento,
      'estado_id': estadoId,
      'created_at': BaseModel.formatDateTime(createdAt),
      'updated_at': BaseModel.formatDateTime(updatedAt),
      'enviado': enviado ? 1 : 0,
    };
  }

  @override
  UsuarioModel fromMap(Map<String, dynamic> map) {
    return UsuarioModel(
      id: map['id'] ?? 0,
      rolId: map['rol_id'] ?? 0,
      especialidadId: map['especialidad_id'],
      nombreCompleto: map['nombre_completo'] ?? '',
      email: map['email'] ?? '',
      telefono: map['telefono'],
      nss: map['nss'] ?? '',
      contrasenaHash: map['contrasena_hash'] ?? '',
      fechaIngreso:
          BaseModel.parseDateTime(map['fecha_ingreso']) ?? DateTime.now(),
      salario: map['salario'],
      tipoContrato: map['tipo_contrato'],
      supervisorId: map['supervisor_id'],
      // cargo: map['cargo'],
      departamento: map['departamento'],
      estadoId: map['estado_id'] ?? 0,
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
      enviado: map['enviado'] == 1 || map['enviado'] == true,
    );
  }

  // Factory constructor para crear desde Map
  factory UsuarioModel.fromJson(Map<String, dynamic> map) {
    return UsuarioModel(
      id: map['id'] ?? 0,
      rolId: map['rol_id'] ?? 0,
      especialidadId: map['especialidad_id'],
      nombreCompleto: map['nombre_completo'] ?? '',
      email: map['email'] ?? '',
      telefono: map['telefono'],
      nss: map['nss'] ?? '',
      contrasenaHash: map['contrasena_hash'] ?? '',
      fechaIngreso:
          BaseModel.parseDateTime(map['fecha_ingreso']) ?? DateTime.now(),
      salario: map['salario'],
      tipoContrato: map['tipo_contrato'],
      supervisorId: map['supervisor_id'],
      // cargo: map['cargo'],
      departamento: map['departamento'],
      estadoId: map['estado_id'] ?? 0,
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
      enviado: map['enviado'] == 1 || map['enviado'] == true,
    );
  }
}
