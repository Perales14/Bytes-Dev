import 'base_model.dart';

class IncidentModel extends BaseModel {
  int projectId;
  int? incidentTypeId;
  String description;
  String? impactLevel;
  String? actions;

  IncidentModel({
    super.id = 0,
    required this.projectId,
    this.incidentTypeId,
    required this.description,
    this.impactLevel,
    this.actions,
    super.createdAt,
    super.updatedAt,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'project_id': projectId,
      'incident_type_id': incidentTypeId,
      'description': description,
      'impact_level': impactLevel,
      'actions': actions,
      'created_at': BaseModel.formatDateTime(createdAt),
      'updated_at': BaseModel.formatDateTime(updatedAt),
    };
  }

  @override
  IncidentModel fromMap(Map<String, dynamic> map) {
    return IncidentModel(
      id: map['id'] ?? 0,
      projectId: map['project_id'] ?? 0,
      incidentTypeId: map['incident_type_id'],
      description: map['description'] ?? '',
      impactLevel: map['impact_level'],
      actions: map['actions'],
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
    );
  }

  factory IncidentModel.fromJson(Map<String, dynamic> map) {
    return IncidentModel(
      id: map['id'] ?? 0,
      projectId: map['project_id'] ?? 0,
      incidentTypeId: map['incident_type_id'],
      description: map['description'] ?? '',
      impactLevel: map['impact_level'],
      actions: map['actions'],
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
    );
  }

  IncidentModel copyWith({
    int? id,
    int? projectId,
    int? incidentTypeId,
    String? description,
    String? impactLevel,
    String? actions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return IncidentModel(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      incidentTypeId: incidentTypeId ?? this.incidentTypeId,
      description: description ?? this.description,
      impactLevel: impactLevel ?? this.impactLevel,
      actions: actions ?? this.actions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
