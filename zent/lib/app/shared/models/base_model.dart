import 'package:zent/app/shared/widgets/form/widgets/file_upload_panel.dart';

// metodos para revisar su uso, y asegurarse que el cambio sea correcto
// toJson, toMap, fromJson
// la razon es que estos no van a marcar error a comparacion de los otros metodos

//Modelo base para todos los modelos de la aplicación
//Se utiliza para definir los atributos comunes de los modelos
class BaseModel {
  final String? id;
  final String firstName;
  final String fatherLastName;
  final String motherLastName;
  final String email;
  final String phone;
  final String registrationDate;
  final String notes;
  final List<FileData> files;

  BaseModel({
    this.id,
    required this.firstName,
    required this.fatherLastName,
    required this.motherLastName,
    required this.email,
    required this.phone,
    required this.registrationDate,
    this.notes = '',
    this.files = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'fatherLastName': fatherLastName,
      'motherLastName': motherLastName,
      'email': email,
      'phone': phone,
      'registrationDate': registrationDate,
      'notes': notes,
    };
  }

  // Nuevo método toMap() para bases de datos
  Map<String, dynamic> toMap() {
    final baseMap = {
      'id': id,
      'firstName': firstName,
      'fatherLastName': fatherLastName,
      'motherLastName': motherLastName,
      'email': email,
      'phone': phone,
      'registrationDate': registrationDate,
      'notes': notes,
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
      firstName: json['firstName'] ?? '',
      fatherLastName: json['fatherLastName'] ?? '',
      motherLastName: json['motherLastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      registrationDate: json['registrationDate'] ?? '',
      notes: json['notes'] ?? '',
    );
  }

  BaseModel copyWith({
    String? id,
    String? firstName,
    String? fatherLastName,
    String? motherLastName,
    String? email,
    String? phone,
    String? registrationDate,
    String? notes,
    List<FileData>? files,
  }) {
    return BaseModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      fatherLastName: fatherLastName ?? this.fatherLastName,
      motherLastName: motherLastName ?? this.motherLastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      registrationDate: registrationDate ?? this.registrationDate,
      notes: notes ?? this.notes,
      files: files ?? this.files,
    );
  }
}
