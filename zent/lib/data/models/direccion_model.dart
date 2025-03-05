import 'package:zent/core/constants/db_constants.dart';
import 'package:zent/core/database/database_helper.dart';

class Direccion {
  final int? id;
  final String calle;
  final String numero;
  final String colonia;
  final String cp;
  final String? estado;
  final String? pais;
  final String createdAt;
  final String updatedAt;
  final bool enviado;

  Direccion({
    this.id,
    required this.calle,
    required this.numero,
    required this.colonia,
    required this.cp,
    this.estado,
    this.pais,
    String? createdAt,
    String? updatedAt,
    this.enviado = false,
  })  : createdAt = createdAt ?? DateTime.now().toIso8601String(),
        updatedAt = updatedAt ?? DateTime.now().toIso8601String();

  factory Direccion.fromJson(Map<String, dynamic> json,
      {bool fromSupabase = false}) {
    return Direccion(
      id: json['id'],
      calle: json['calle'],
      numero: json['numero'],
      colonia: json['colonia'],
      cp: json['cp'],
      estado: json['estado'],
      pais: json['pais'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      enviado: fromSupabase ? true : json['enviado'] == 1,
    );
  }

  Map<String, dynamic> toJson({bool forSupabase = false}) {
    final Map<String, dynamic> data = {
      'calle': calle,
      'numero': numero,
      'colonia': colonia,
      'cp': cp,
      'estado': estado,
      'pais': pais,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };

    if (id != null) data['id'] = id;
    if (!forSupabase) data['enviado'] = enviado ? 1 : 0;

    return data;
  }

  Direccion copyWith({
    int? id,
    String? calle,
    String? numero,
    String? colonia,
    String? cp,
    String? estado,
    String? pais,
    String? createdAt,
    String? updatedAt,
    bool? enviado,
  }) {
    return Direccion(
      id: id ?? this.id,
      calle: calle ?? this.calle,
      numero: numero ?? this.numero,
      colonia: colonia ?? this.colonia,
      cp: cp ?? this.cp,
      estado: estado ?? this.estado,
      pais: pais ?? this.pais,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      enviado: enviado ?? this.enviado,
    );
  }
}
