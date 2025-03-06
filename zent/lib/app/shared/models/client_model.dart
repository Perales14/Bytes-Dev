import 'package:zent/app/shared/widgets/form/widgets/file_upload_panel.dart';
import 'package:zent/app/shared/models/base_model.dart';

class ClientModel extends BaseModel {
  // Cliente específico
  final String nombreEmpresa;
  final String cargo;
  final String calle;
  final String colonia;
  final String cp;
  final String rfc;
  final String tipoCliente;

  ClientModel({
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
    required this.tipoCliente,
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
      'tipoCliente': tipoCliente,
    };
  }

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();

    return {
      ...baseMap,
      'nombreEmpresa': nombreEmpresa,
      'cargo': cargo,
      'calle': calle,
      'colonia': colonia,
      'cp': cp,
      'rfc': rfc,
      'tipoCliente': tipoCliente,
    };
  }

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    final baseModel = BaseModel.fromJson(json);

    return ClientModel(
      id: baseModel.id,
      nombre: baseModel.nombre,
      apellidoPaterno: baseModel.apellidoPaterno,
      apellidoMaterno: baseModel.apellidoMaterno,
      correo: baseModel.correo,
      telefono: baseModel.telefono,
      fechaRegistro: baseModel.fechaRegistro,
      observaciones: baseModel.observaciones,
      files: baseModel.files,

      // Campos específicos de ClientModel
      nombreEmpresa: json['nombreEmpresa'] ?? '',
      cargo: json['cargo'] ?? '',
      calle: json['calle'] ?? '',
      colonia: json['colonia'] ?? '',
      cp: json['cp'] ?? '',
      rfc: json['rfc'] ?? '',
      tipoCliente: json['tipoCliente'] ?? '',
    );
  }

  @override
  ClientModel copyWith({
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
    String? tipoCliente,
  }) {
    return ClientModel(
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
      tipoCliente: tipoCliente ?? this.tipoCliente,
    );
  }
}
