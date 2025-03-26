import 'base_model.dart';

class ActivityModel extends BaseModel {
  int projectId;
  String description;
  int? managerId;
  DateTime? startDate;
  DateTime? endDate;
  int? dependencyId;
  List<String>? evidences;
  int stateId;

  ActivityModel({
    super.id = 0,
    required this.projectId,
    required this.description,
    this.managerId,
    this.startDate,
    this.endDate,
    this.dependencyId,
    this.evidences,
    required this.stateId,
    super.createdAt,
    super.updatedAt,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'project_id': projectId,
      'description': description,
      'manager_id': managerId,
      'start_date':
          startDate != null ? BaseModel.formatDateTime(startDate!) : null,
      'end_date': endDate != null ? BaseModel.formatDateTime(endDate!) : null,
      'dependency_id': dependencyId,
      'evidences': evidences,
      'state_id': stateId,
      'created_at': BaseModel.formatDateTime(createdAt),
      'updated_at': BaseModel.formatDateTime(updatedAt),
    };
  }

  @override
  ActivityModel fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      id: map['id'] ?? 0,
      projectId: map['project_id'] ?? 0,
      description: map['description'] ?? '',
      managerId: map['manager_id'],
      startDate: BaseModel.parseDateTime(map['start_date']),
      endDate: BaseModel.parseDateTime(map['end_date']),
      dependencyId: map['dependency_id'],
      evidences:
          map['evidences'] != null ? List<String>.from(map['evidences']) : null,
      stateId: map['state_id'] ?? 0,
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
    );
  }

  factory ActivityModel.fromJson(Map<String, dynamic> map) {
    return ActivityModel(
      id: map['id'] ?? 0,
      projectId: map['project_id'] ?? 0,
      description: map['description'] ?? '',
      managerId: map['manager_id'],
      startDate: BaseModel.parseDateTime(map['start_date']),
      endDate: BaseModel.parseDateTime(map['end_date']),
      dependencyId: map['dependency_id'],
      evidences:
          map['evidences'] != null ? List<String>.from(map['evidences']) : null,
      stateId: map['state_id'] ?? 0,
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
    );
  }

  ActivityModel copyWith({
    int? id,
    int? projectId,
    String? description,
    int? managerId,
    DateTime? startDate,
    DateTime? endDate,
    int? dependencyId,
    List<String>? evidences,
    int? stateId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      description: description ?? this.description,
      managerId: managerId ?? this.managerId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      dependencyId: dependencyId ?? this.dependencyId,
      evidences: evidences ?? this.evidences,
      stateId: stateId ?? this.stateId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
