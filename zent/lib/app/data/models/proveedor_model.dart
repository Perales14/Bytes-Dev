import 'base_model.dart';

class ProveedorModel extends BaseModel {
  int especialidadId;
  String nombreEmpresa;
  String? contactoPrincipal;
  String? telefono;
  String? email;
  String? rfc;
  String? tipoServicio;
  String? condicionesPago;
  int? idDireccion;
  int estadoId;

  ProveedorModel({
    super.id = 0,
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
    super.createdAt,
    super.updatedAt,
    super.enviado = false,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
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
      'created_at': BaseModel.formatDateTime(createdAt),
      'updated_at': BaseModel.formatDateTime(updatedAt),
      'enviado': enviado ? 1 : 0,
    };
  }

  @override
  ProveedorModel fromMap(Map<String, dynamic> map) {
    return ProveedorModel(
      id: map['id'] ?? 0,
      especialidadId: map['especialidad_id'] ?? 0,
      nombreEmpresa: map['nombre_empresa'] ?? '',
      contactoPrincipal: map['contacto_principal'],
      telefono: map['telefono'],
      email: map['email'],
      rfc: map['rfc'],
      tipoServicio: map['tipo_servicio'],
      condicionesPago: map['condiciones_pago'],
      idDireccion: map['id_direccion'],
      estadoId: map['estado_id'] ?? 0,
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
      enviado: map['enviado'] == 1 || map['enviado'] == true,
    );
  }

  factory ProveedorModel.fromJson(Map<String, dynamic> map) {
    return ProveedorModel(
      id: map['id'] ?? 0,
      especialidadId: map['especialidad_id'] ?? 0,
      nombreEmpresa: map['nombre_empresa'] ?? '',
      contactoPrincipal: map['contacto_principal'],
      telefono: map['telefono'],
      email: map['email'],
      rfc: map['rfc'],
      tipoServicio: map['tipo_servicio'],
      condicionesPago: map['condiciones_pago'],
      idDireccion: map['id_direccion'],
      estadoId: map['estado_id'] ?? 0,
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
      enviado: map['enviado'] == 1 || map['enviado'] == true,
    );
  }
}
