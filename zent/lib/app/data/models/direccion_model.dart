import 'base_model.dart';

class DireccionModel extends BaseModel {
  String calle;
  String numero;
  String colonia;
  String cp;
  String? estado;
  String? pais;

  DireccionModel({
    super.id = 0,
    required this.calle,
    required this.numero,
    required this.colonia,
    required this.cp,
    this.estado,
    this.pais,
    super.createdAt,
    super.updatedAt,
    super.enviado = false,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'calle': calle,
      'numero': numero,
      'colonia': colonia,
      'cp': cp,
      'estado': estado,
      'pais': pais,
      'created_at': BaseModel.formatDateTime(createdAt),
      'updated_at': BaseModel.formatDateTime(updatedAt),
      'enviado': enviado ? 1 : 0,
    };
  }

  @override
  DireccionModel fromMap(Map<String, dynamic> map) {
    return DireccionModel(
      id: map['id'] ?? 0,
      calle: map['calle'] ?? '',
      numero: map['numero'] ?? '',
      colonia: map['colonia'] ?? '',
      cp: map['cp'] ?? '',
      estado: map['estado'],
      pais: map['pais'],
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
      enviado: map['enviado'] == 1 || map['enviado'] == true,
    );
  }

  factory DireccionModel.fromJson(Map<String, dynamic> map) {
    return DireccionModel(
      id: map['id'] ?? 0,
      calle: map['calle'] ?? '',
      numero: map['numero'] ?? '',
      colonia: map['colonia'] ?? '',
      cp: map['cp'] ?? '',
      estado: map['estado'],
      pais: map['pais'],
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
      enviado: map['enviado'] == 1 || map['enviado'] == true,
    );
  }
}
