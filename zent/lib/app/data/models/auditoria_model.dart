import 'base_model.dart';

class AuditoriaModel extends BaseModel {
  String tablaAfectada;
  String? operacion;
  int? idAfectado;
  Map<String, dynamic>? valoresAnteriores;
  Map<String, dynamic>? valoresNuevos;
  int? usuarioId;

  AuditoriaModel({
    super.id = 0,
    required this.tablaAfectada,
    this.operacion,
    this.idAfectado,
    this.valoresAnteriores,
    this.valoresNuevos,
    this.usuarioId,
    super.createdAt,
    super.enviado = false,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tabla_afectada': tablaAfectada,
      'operacion': operacion,
      'id_afectado': idAfectado,
      'valores_anteriores': valoresAnteriores,
      'valores_nuevos': valoresNuevos,
      'usuario_id': usuarioId,
      'created_at': BaseModel.formatDateTime(createdAt),
      'enviado': enviado ? 1 : 0,
    };
  }

  @override
  AuditoriaModel fromMap(Map<String, dynamic> map) {
    return AuditoriaModel(
      id: map['id'] ?? 0,
      tablaAfectada: map['tabla_afectada'] ?? '',
      operacion: map['operacion'],
      idAfectado: map['id_afectado'],
      valoresAnteriores: map['valores_anteriores'] != null
          ? Map<String, dynamic>.from(map['valores_anteriores'])
          : null,
      valoresNuevos: map['valores_nuevos'] != null
          ? Map<String, dynamic>.from(map['valores_nuevos'])
          : null,
      usuarioId: map['usuario_id'],
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      enviado: map['enviado'] == 1 || map['enviado'] == true,
    );
  }

  factory AuditoriaModel.fromJson(Map<String, dynamic> map) {
    return AuditoriaModel(
      id: map['id'] ?? 0,
      tablaAfectada: map['tabla_afectada'] ?? '',
      operacion: map['operacion'],
      idAfectado: map['id_afectado'],
      valoresAnteriores: map['valores_anteriores'] != null
          ? Map<String, dynamic>.from(map['valores_anteriores'])
          : null,
      valoresNuevos: map['valores_nuevos'] != null
          ? Map<String, dynamic>.from(map['valores_nuevos'])
          : null,
      usuarioId: map['usuario_id'],
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      enviado: map['enviado'] == 1 || map['enviado'] == true,
    );
  }
}
