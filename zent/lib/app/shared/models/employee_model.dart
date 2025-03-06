import 'package:zent/app/shared/widgets/form/widgets/file_upload_panel.dart';
import 'package:zent/app/shared/models/base_model.dart';

class EmployeeModel extends BaseModel {
  // Empleado específico
  final String nss;
  final String password;
  final String salario;
  final String rol;
  final String tipoContrato;

  EmployeeModel({
    // Campos base
    super.id,
    required super.nombre,
    required super.apellidoPaterno,
    required super.apellidoMaterno,
    required super.correo,
    required super.telefono,
    required super.fechaRegistro,
    super.observaciones,
    super.files,

    // Campos específicos
    required this.nss,
    required this.password,
    required this.salario,
    required this.rol,
    required this.tipoContrato,
  });

  @override
  Map<String, dynamic> toJson() {
    final baseJson = super.toJson();
    return {
      ...baseJson,
      'nss': nss,
      'password':
          password, // Nota: en producción, asegurar que esto esté hasheado
      'salario': salario,
      'rol': rol,
      'tipoContrato': tipoContrato,
    };
  }

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'],
      nombre: json['nombre'] ?? '',
      apellidoPaterno: json['apellidoPaterno'] ?? '',
      apellidoMaterno: json['apellidoMaterno'] ?? '',
      correo: json['correo'] ?? '',
      telefono: json['telefono'] ?? '',
      fechaRegistro: json['fechaRegistro'] ?? '',
      observaciones: json['observaciones'] ?? '',
      nss: json['nss'] ?? '',
      password: json['password'] ?? '',
      salario: json['salario'] ?? '',
      rol: json['rol'] ?? '',
      tipoContrato: json['tipoContrato'] ?? '',
    );
  }

  @override
  EmployeeModel copyWith({
    String? id,
    String? nombre,
    String? apellidoPaterno,
    String? apellidoMaterno,
    String? correo,
    String? telefono,
    String? fechaRegistro,
    String? observaciones,
    List<FileData>? files,
    String? nss,
    String? password,
    String? salario,
    String? rol,
    String? tipoContrato,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      apellidoPaterno: apellidoPaterno ?? this.apellidoPaterno,
      apellidoMaterno: apellidoMaterno ?? this.apellidoMaterno,
      correo: correo ?? this.correo,
      telefono: telefono ?? this.telefono,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
      observaciones: observaciones ?? this.observaciones,
      files: files ?? this.files,
      nss: nss ?? this.nss,
      password: password ?? this.password,
      salario: salario ?? this.salario,
      rol: rol ?? this.rol,
      tipoContrato: tipoContrato ?? this.tipoContrato,
    );
  }
}
