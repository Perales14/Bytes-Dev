import 'package:zent/shared/widgets/form/file_upload_panel.dart';
import 'package:zent/shared/models/base_model.dart';

class ProviderModel extends BaseModel {
  // Proveedor específico
  final String nombreEmpresa;
  final String cargo;
  final String calle;
  final String colonia;
  final String cp;
  final String rfc;
  final String tipoServicio;

  ProviderModel({
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
    required this.nombreEmpresa,
    required this.cargo,
    required this.calle,
    required this.colonia,
    required this.cp,
    required this.rfc,
    required this.tipoServicio,
  });

  @override
  Map<String, dynamic> toJson() {
    final baseJson = super.toJson();
    return {
      ...baseJson,
      'nombreEmpresa': nombreEmpresa,
      'cargo': cargo,
      'calle': calle,
      'colonia': colonia,
      'cp': cp,
      'rfc': rfc,
      'tipoServicio': tipoServicio,
    };
  }

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      id: json['id'],
      nombre: json['nombre'] ?? '',
      apellidoPaterno: json['apellidoPaterno'] ?? '',
      apellidoMaterno: json['apellidoMaterno'] ?? '',
      correo: json['correo'] ?? '',
      telefono: json['telefono'] ?? '',
      fechaRegistro: json['fechaRegistro'] ?? '',
      observaciones: json['observaciones'] ?? '',
      nombreEmpresa: json['nombreEmpresa'] ?? '',
      cargo: json['cargo'] ?? '',
      calle: json['calle'] ?? '',
      colonia: json['colonia'] ?? '',
      cp: json['cp'] ?? '',
      rfc: json['rfc'] ?? '',
      tipoServicio: json['tipoServicio'] ?? '',
    );
  }

  @override
  ProviderModel copyWith({
    String? id,
    String? nombre,
    String? apellidoPaterno,
    String? apellidoMaterno,
    String? correo,
    String? telefono,
    String? fechaRegistro,
    String? observaciones,
    List<FileData>? files,
    String? nombreEmpresa,
    String? cargo,
    String? calle,
    String? colonia,
    String? cp,
    String? rfc,
    String? tipoServicio,
  }) {
    return ProviderModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      apellidoPaterno: apellidoPaterno ?? this.apellidoPaterno,
      apellidoMaterno: apellidoMaterno ?? this.apellidoMaterno,
      correo: correo ?? this.correo,
      telefono: telefono ?? this.telefono,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
      observaciones: observaciones ?? this.observaciones,
      files: files ?? this.files,
      nombreEmpresa: nombreEmpresa ?? this.nombreEmpresa,
      cargo: cargo ?? this.cargo,
      calle: calle ?? this.calle,
      colonia: colonia ?? this.colonia,
      cp: cp ?? this.cp,
      rfc: rfc ?? this.rfc,
      tipoServicio: tipoServicio ?? this.tipoServicio,
    );
  }
}
