import 'base_model.dart';

class DocumentModel extends BaseModel {
  int? projectId;
  String? documentType;
  String title;
  String? content;
  String? fileUrl;
  int userId;

  DocumentModel({
    super.id = 0,
    this.projectId,
    this.documentType,
    required this.title,
    this.content,
    this.fileUrl,
    required this.userId,
    super.createdAt,
    super.updatedAt,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'project_id': projectId,
      'document_type': documentType,
      'title': title,
      'content': content,
      'file_url': fileUrl,
      'user_id': userId,
      'created_at': BaseModel.formatDateTime(createdAt),
      'updated_at': BaseModel.formatDateTime(updatedAt),
    };
  }

  @override
  DocumentModel fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      id: map['id'] ?? 0,
      projectId: map['project_id'],
      documentType: map['document_type'],
      title: map['title'] ?? '',
      content: map['content'],
      fileUrl: map['file_url'],
      userId: map['user_id'] ?? 0,
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
    );
  }

  factory DocumentModel.fromJson(Map<String, dynamic> map) {
    return DocumentModel(
      id: map['id'] ?? 0,
      projectId: map['project_id'],
      documentType: map['document_type'],
      title: map['title'] ?? '',
      content: map['content'],
      fileUrl: map['file_url'],
      userId: map['user_id'] ?? 0,
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
    );
  }

  DocumentModel copyWith({
    int? id,
    int? projectId,
    String? documentType,
    String? title,
    String? content,
    String? fileUrl,
    int? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      documentType: documentType ?? this.documentType,
      title: title ?? this.title,
      content: content ?? this.content,
      fileUrl: fileUrl ?? this.fileUrl,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
