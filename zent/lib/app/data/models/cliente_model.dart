import 'base_model.dart';

class ClienteModel extends BaseModel {
  String? nombreEmpresa;
  String? telefono;
  String? email;
  String? rfc;
  String? tipo;
  String nombre;
  String apellidoPaterno;
  String? apellidoMaterno;
  int? idDireccion;
  int estadoId;

  ClienteModel({
    super.id = 0,
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
    super.createdAt,
    super.updatedAt,
    super.enviado = false,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre_empresa': nombreEmpresa,
      'telefono': telefono,
      'email': email,
      'rfc': rfc,
      'tipo': tipo,
      'nombre': nombre,
      'apellido_paterno': apellidoPaterno,
      'apellido_materno': apellidoMaterno,
      'id_direccion': idDireccion,
      'estado_id': estadoId,
      'created_at': BaseModel.formatDateTime(createdAt),
      'updated_at': BaseModel.formatDateTime(updatedAt),
      'enviado': enviado ? 1 : 0,
    };
  }

  @override
  ClienteModel fromMap(Map<String, dynamic> map) {
    return ClienteModel(
      id: map['id'] ?? 0,
      nombreEmpresa: map['nombre_empresa'],
      telefono: map['telefono'],
      email: map['email'],
      rfc: map['rfc'],
      tipo: map['tipo'],
      nombre: map['nombre'] ?? '',
      apellidoPaterno: map['apellido_paterno'] ?? '',
      apellidoMaterno: map['apellido_materno'],
      idDireccion: map['id_direccion'],
      estadoId: map['estado_id'] ?? 0,
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
      enviado: map['enviado'] == 1 || map['enviado'] == true,
    );
  }

  factory ClienteModel.fromJson(Map<String, dynamic> map) {
    return ClienteModel(
      id: map['id'] ?? 0,
      nombreEmpresa: map['nombre_empresa'],
      telefono: map['telefono'],
      email: map['email'],
      rfc: map['rfc'],
      tipo: map['tipo'],
      nombre: map['nombre'] ?? '',
      apellidoPaterno: map['apellido_paterno'] ?? '',
      apellidoMaterno: map['apellido_materno'],
      idDireccion: map['id_direccion'],
      estadoId: map['estado_id'] ?? 0,
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
      enviado: map['enviado'] == 1 || map['enviado'] == true,
    );
  }
}
