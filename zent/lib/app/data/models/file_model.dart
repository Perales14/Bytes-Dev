import 'base_model.dart';

class FileModel extends BaseModel {
  String name;
  String type;
  String url;
  String storagePath;
  DateTime uploadDate;
  int entityId;
  String entityType;
  int? size;
  bool sent;

  FileModel({
    super.id = 0,
    required this.name,
    required this.type,
    required this.url,
    required this.storagePath,
    required this.uploadDate,
    required this.entityId,
    required this.entityType,
    this.size,
    this.sent = false,
    super.createdAt,
    super.updatedAt,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'url': url,
      'storage_path': storagePath,
      'upload_date': BaseModel.formatDateTime(uploadDate),
      'entity_id': entityId,
      'entity_type': entityType,
      'size': size,
      'created_at': BaseModel.formatDateTime(createdAt),
      'updated_at': BaseModel.formatDateTime(updatedAt),
      'sent': sent ? 1 : 0,
    };
  }

  @override
  FileModel fromMap(Map<String, dynamic> map) {
    return FileModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      url: map['url'] ?? '',
      storagePath: map['storage_path'] ?? '',
      uploadDate: BaseModel.parseDateTime(map['upload_date']) ?? DateTime.now(),
      entityId: map['entity_id'] ?? 0,
      entityType: map['entity_type'] ?? '',
      size: map['size'],
      sent: map['sent'] == 1,
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
    );
  }

  factory FileModel.fromJson(Map<String, dynamic> map) {
    return FileModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      url: map['url'] ?? '',
      storagePath: map['storage_path'] ?? '',
      uploadDate: BaseModel.parseDateTime(map['upload_date']) ?? DateTime.now(),
      entityId: map['entity_id'] ?? 0,
      entityType: map['entity_type'] ?? '',
      size: map['size'],
      sent: map['sent'] == 1,
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
    );
  }

  FileModel copyWith({
    int? id,
    String? name,
    String? type,
    String? url,
    String? storagePath,
    DateTime? uploadDate,
    int? entityId,
    String? entityType,
    int? size,
    bool? sent,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      url: url ?? this.url,
      storagePath: storagePath ?? this.storagePath,
      uploadDate: uploadDate ?? this.uploadDate,
      entityId: entityId ?? this.entityId,
      entityType: entityType ?? this.entityType,
      size: size ?? this.size,
      sent: sent ?? this.sent,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper methods
  String get extension {
    final parts = name.split('.');
    return parts.length > 1 ? parts.last.toLowerCase() : '';
  }

  String get fileSize {
    if (size == null) return 'Unknown';
    if (size! < 1024) return '$size B';
    if (size! < 1024 * 1024) return '${(size! / 1024).toStringAsFixed(2)} KB';
    return '${(size! / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  bool get isImage {
    return ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension);
  }

  bool get isPdf {
    return extension == 'pdf';
  }

  bool get isDocument {
    return ['doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt', 'pdf']
        .contains(extension);
  }
}
