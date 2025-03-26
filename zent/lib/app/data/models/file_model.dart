// app/data/models/file_model.dart
import 'base_model.dart';

class FileModel extends BaseModel {
  final String name;
  final String type;
  final String url;
  final String storagePath;
  final DateTime uploadDate;
  final int entityId;
  final String entityType;
  final int? size;

  FileModel({
    super.id,
    required this.name,
    required this.type,
    required this.url,
    required this.storagePath,
    required this.uploadDate,
    required this.entityId,
    required this.entityType,
    this.size,
    DateTime? createdAt,
    DateTime? updatedAt,
    super.enviado,
  }) : super(
          createdAt: createdAt ?? DateTime.now(),
          updatedAt: updatedAt ?? DateTime.now(),
        );

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'url': url,
      'storage_path': storagePath,
      'upload_date': uploadDate.toIso8601String(),
      'entity_id': entityId,
      'entity_type': entityType,
      'size': size,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'enviado': enviado ? 1 : 0,
    };
  }

  //hacer el meotodo fromMap
  @override
  BaseModel fromMap(Map<String, dynamic> map) {
    return FileModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      url: map['url'] ?? '',
      storagePath: map['storage_path'] ?? '',
      uploadDate: DateTime.parse(map['upload_date']),
      entityId: map['entity_id'],
      entityType: map['entity_type'] ?? '',
      size: map['size'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      enviado: map['enviado'] == 1,
    );
  }

  // @override
  // BaseModel fromMap(Map<String, dynamic> map) {
  //   // TODO: implement fromMap
  //   throw UnimplementedError();
  // }
}
