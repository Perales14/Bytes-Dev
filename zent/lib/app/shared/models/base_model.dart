import 'package:zent/app/shared/widgets/form/widgets/file_upload_panel.dart';

class BaseModel {
  final String? id;
  final String nombre;
  final String apellidoPaterno;
  final String apellidoMaterno;
  final String correo;
  final String telefono;
  final String fechaRegistro;
  final String observaciones;
  final List<FileData> files;

  BaseModel({
    this.id,
    required this.nombre,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    required this.correo,
    required this.telefono,
    required this.fechaRegistro,
    this.observaciones = '',
    this.files = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'apellidoPaterno': apellidoPaterno,
      'apellidoMaterno': apellidoMaterno,
      'correo': correo,
      'telefono': telefono,
      'fechaRegistro': fechaRegistro,
      'observaciones': observaciones,
    };
  }

  // Nuevo método toMap() para bases de datos
  Map<String, dynamic> toMap() {
    final baseMap = {
      'id': id,
      'nombre': nombre,
      'apellidoPaterno': apellidoPaterno,
      'apellidoMaterno': apellidoMaterno,
      'correo': correo,
      'telefono': telefono,
      'fechaRegistro': fechaRegistro,
      'observaciones': observaciones,
      // No incluimos 'files' ya que normalmente se manejan por separado
      // en operaciones de base de datos
    };

    // Eliminar entradas con valores nulos
    baseMap.removeWhere((key, value) => value == null);
    return baseMap;
  }

  factory BaseModel.fromJson(Map<String, dynamic> json) {
    return BaseModel(
      id: json['id'],
      nombre: json['nombre'] ?? '',
      apellidoPaterno: json['apellidoPaterno'] ?? '',
      apellidoMaterno: json['apellidoMaterno'] ?? '',
      correo: json['correo'] ?? '',
      telefono: json['telefono'] ?? '',
      fechaRegistro: json['fechaRegistro'] ?? '',
      observaciones: json['observaciones'] ?? '',
    );
  }

  BaseModel copyWith({
    String? id,
    String? nombre,
    String? apellidoPaterno,
    String? apellidoMaterno,
    String? correo,
    String? telefono,
    String? fechaRegistro,
    String? observaciones,
    List<FileData>? files,
  }) {
    return BaseModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      apellidoPaterno: apellidoPaterno ?? this.apellidoPaterno,
      apellidoMaterno: apellidoMaterno ?? this.apellidoMaterno,
      correo: correo ?? this.correo,
      telefono: telefono ?? this.telefono,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
      observaciones: observaciones ?? this.observaciones,
      files: files ?? this.files,
    );
  }
}
