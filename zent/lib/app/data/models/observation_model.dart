import 'base_model.dart';

class ObservationModel extends BaseModel {
  String sourceTable;
  int sourceId;
  String observation;
  int userId;

  ObservationModel({
    super.id = 0,
    required this.sourceTable,
    required this.sourceId,
    required this.observation,
    required this.userId,
    super.createdAt,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'source_table': sourceTable,
      'source_id': sourceId,
      'observation': observation,
      'user_id': userId,
      'created_at': BaseModel.formatDateTime(createdAt),
    };
  }

  @override
  ObservationModel fromMap(Map<String, dynamic> map) {
    return ObservationModel(
      id: map['id'] ?? 0,
      sourceTable: map['source_table'] ?? '',
      sourceId: map['source_id'] ?? 0,
      observation: map['observation'] ?? '',
      userId: map['user_id'] ?? 0,
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
    );
  }

  factory ObservationModel.fromJson(Map<String, dynamic> map) {
    return ObservationModel(
      id: map['id'] ?? 0,
      sourceTable: map['source_table'] ?? '',
      sourceId: map['source_id'] ?? 0,
      observation: map['observation'] ?? '',
      userId: map['user_id'] ?? 0,
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
    );
  }

  ObservationModel copyWith({
    int? id,
    String? sourceTable,
    int? sourceId,
    String? observation,
    int? userId,
    DateTime? createdAt,
  }) {
    return ObservationModel(
      id: id ?? this.id,
      sourceTable: sourceTable ?? this.sourceTable,
      sourceId: sourceId ?? this.sourceId,
      observation: observation ?? this.observation,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
