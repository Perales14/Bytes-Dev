import 'base_model.dart';

class ObservacionModel extends BaseModel {
  String tablaOrigen;
  int idOrigen;
  String observacion;
  int usuarioId;

  ObservacionModel({
    super.id = 0,
    required this.tablaOrigen,
    required this.idOrigen,
    required this.observacion,
    required this.usuarioId,
    super.createdAt,
    super.enviado = false,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tabla_origen': tablaOrigen,
      'id_origen': idOrigen,
      'observacion': observacion,
      'usuario_id': usuarioId,
      'created_at': BaseModel.formatDateTime(createdAt),
      'enviado': enviado ? 1 : 0,
    };
  }

  @override
  ObservacionModel fromMap(Map<String, dynamic> map) {
    return ObservacionModel(
      id: map['id'] ?? 0,
      tablaOrigen: map['tabla_origen'] ?? '',
      idOrigen: map['id_origen'] ?? 0,
      observacion: map['observacion'] ?? '',
      usuarioId: map['usuario_id'] ?? 0,
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      enviado: map['enviado'] == 1 || map['enviado'] == true,
    );
  }

  factory ObservacionModel.fromJson(Map<String, dynamic> map) {
    return ObservacionModel(
      id: map['id'] ?? 0,
      tablaOrigen: map['tabla_origen'] ?? '',
      idOrigen: map['id_origen'] ?? 0,
      observacion: map['observacion'] ?? '',
      usuarioId: map['usuario_id'] ?? 0,
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      enviado: map['enviado'] == 1 || map['enviado'] == true,
    );
  }
}
