import 'base_model.dart';

class AuditModel extends BaseModel {
  String affectedTable;
  String? operation;
  int? affectedId;
  Map<String, dynamic>? previousValues;
  Map<String, dynamic>? newValues;
  int? userId;

  AuditModel({
    super.id = 0,
    required this.affectedTable,
    this.operation,
    this.affectedId,
    this.previousValues,
    this.newValues,
    this.userId,
    super.createdAt,
    super.updatedAt,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'affected_table': affectedTable,
      'operation': operation,
      'affected_id': affectedId,
      'previous_values': previousValues,
      'new_values': newValues,
      'user_id': userId,
      'created_at': BaseModel.formatDateTime(createdAt),
    };
  }

  @override
  AuditModel fromMap(Map<String, dynamic> map) {
    return AuditModel(
      id: map['id'] ?? 0,
      affectedTable: map['affected_table'] ?? '',
      operation: map['operation'],
      affectedId: map['affected_id'],
      previousValues: map['previous_values'] != null
          ? Map<String, dynamic>.from(map['previous_values'])
          : null,
      newValues: map['new_values'] != null
          ? Map<String, dynamic>.from(map['new_values'])
          : null,
      userId: map['user_id'],
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
    );
  }

  factory AuditModel.fromJson(Map<String, dynamic> map) {
    return AuditModel(
      id: map['id'] ?? 0,
      affectedTable: map['affected_table'] ?? '',
      operation: map['operation'],
      affectedId: map['affected_id'],
      previousValues: map['previous_values'],
      newValues: map['new_values'],
      userId: map['user_id'],
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
    );
  }

  AuditModel copyWith({
    int? id,
    String? affectedTable,
    String? operation,
    int? affectedId,
    Map<String, dynamic>? previousValues,
    Map<String, dynamic>? newValues,
    int? userId,
    DateTime? createdAt,
  }) {
    return AuditModel(
      id: id ?? this.id,
      affectedTable: affectedTable ?? this.affectedTable,
      operation: operation ?? this.operation,
      affectedId: affectedId ?? this.affectedId,
      previousValues: previousValues ?? this.previousValues,
      newValues: newValues ?? this.newValues,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
