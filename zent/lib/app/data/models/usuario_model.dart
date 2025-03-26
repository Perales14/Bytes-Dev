import 'base_model.dart';

class UsuarioModel extends BaseModel {
  int rolId;
  int? especialidadId;
  String nombre;
  String apellidoPaterno;
  String? apellidoMaterno;
  String email;
  String? telefono;
  String nss;
  String contrasenaHash;
  DateTime fechaIngreso;
  double? salario;
  String? tipoContrato;
  int? supervisorId;
  String? departamento;
  int estadoId;

  UsuarioModel({
    super.id = 0,
    required this.rolId,
    this.especialidadId,
    required this.nombre,
    required this.apellidoPaterno,
    this.apellidoMaterno,
    required this.email,
    this.telefono,
    required this.nss,
    required this.contrasenaHash,
    required this.fechaIngreso,
    this.salario,
    this.tipoContrato,
    this.supervisorId,
    this.departamento,
    required this.estadoId,
    super.createdAt,
    super.updatedAt,
    super.enviado = false,
  });

  // Propiedad calculada para obtener el nombre completo
  String get nombreCompleto =>
      '$nombre $apellidoPaterno${apellidoMaterno != null ? ' $apellidoMaterno' : ''}';

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rol_id': rolId,
      'especialidad_id': especialidadId,
      'nombre': nombre,
      'apellido_paterno': apellidoPaterno,
      'apellido_materno': apellidoMaterno,
      'email': email,
      'telefono': telefono,
      'nss': nss,
      'contrasena_hash': contrasenaHash,
      'fecha_ingreso': BaseModel.formatDateTime(fechaIngreso),
      'salario': salario,
      'tipo_contrato': tipoContrato,
      'supervisor_id': supervisorId,
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
      nombre: map['nombre'] ?? '',
      apellidoPaterno: map['apellido_paterno'] ?? '',
      apellidoMaterno: map['apellido_materno'],
      email: map['email'] ?? '',
      telefono: map['telefono'],
      nss: map['nss'] ?? '',
      contrasenaHash: map['contrasena_hash'] ?? '',
      fechaIngreso:
          BaseModel.parseDateTime(map['fecha_ingreso']) ?? DateTime.now(),
      salario: map['salario'] != null
          ? (map['salario'] is double
              ? map['salario']
              : double.parse(map['salario'].toString()))
          : null,
      tipoContrato: map['tipo_contrato'],
      supervisorId: map['supervisor_id'],
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
      nombre: map['nombre'] ?? '',
      apellidoPaterno: map['apellido_paterno'] ?? '',
      apellidoMaterno: map['apellido_materno'],
      email: map['email'] ?? '',
      telefono: map['telefono'],
      nss: map['nss'] ?? '',
      contrasenaHash: map['contrasena_hash'] ?? '',
      fechaIngreso:
          BaseModel.parseDateTime(map['fecha_ingreso']) ?? DateTime.now(),
      salario: map['salario'] != null
          ? (map['salario'] is double
              ? map['salario']
              : double.parse(map['salario'].toString()))
          : null,
      tipoContrato: map['tipo_contrato'],
      supervisorId: map['supervisor_id'],
      departamento: map['departamento'],
      estadoId: map['estado_id'] ?? 0,
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
      enviado: map['enviado'] == 1 || map['enviado'] == true,
    );
  }

  // Método para clonar el objeto con modificaciones
  UsuarioModel copyWith({
    int? id,
    int? rolId,
    int? especialidadId,
    String? nombre,
    String? apellidoPaterno,
    String? apellidoMaterno,
    String? email,
    String? telefono,
    String? nss,
    String? contrasenaHash,
    DateTime? fechaIngreso,
    double? salario,
    String? tipoContrato,
    int? supervisorId,
    String? departamento,
    int? estadoId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? enviado,
  }) {
    return UsuarioModel(
      id: id ?? this.id,
      rolId: rolId ?? this.rolId,
      especialidadId: especialidadId ?? this.especialidadId,
      nombre: nombre ?? this.nombre,
      apellidoPaterno: apellidoPaterno ?? this.apellidoPaterno,
      apellidoMaterno: apellidoMaterno ?? this.apellidoMaterno,
      email: email ?? this.email,
      telefono: telefono ?? this.telefono,
      nss: nss ?? this.nss,
      contrasenaHash: contrasenaHash ?? this.contrasenaHash,
      fechaIngreso: fechaIngreso ?? this.fechaIngreso,
      salario: salario ?? this.salario,
      tipoContrato: tipoContrato ?? this.tipoContrato,
      supervisorId: supervisorId ?? this.supervisorId,
      departamento: departamento ?? this.departamento,
      estadoId: estadoId ?? this.estadoId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      enviado: enviado ?? this.enviado,
    );
  }
}
