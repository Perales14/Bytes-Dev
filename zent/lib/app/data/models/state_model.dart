import 'base_model.dart';

class StateModel extends BaseModel {
  String tableName;
  String code;
  String name;
  String? description;

  StateModel({
    super.id = 0,
    required this.tableName,
    required this.code,
    required this.name,
    this.description,
    super.createdAt,
    super.updatedAt,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'table_name': tableName,
      'code': code,
      'name': name,
      'description': description,
      'created_at': BaseModel.formatDateTime(createdAt),
      'updated_at': BaseModel.formatDateTime(updatedAt),
    };
  }

  @override
  StateModel fromMap(Map<String, dynamic> map) {
    return StateModel(
      id: map['id'] ?? 0,
      tableName: map['table_name'] ?? '',
      code: map['code'] ?? '',
      name: map['name'] ?? '',
      description: map['description'],
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
    );
  }

  factory StateModel.fromJson(Map<String, dynamic> map) {
    return StateModel(
      id: map['id'] ?? 0,
      tableName: map['table_name'] ?? '',
      code: map['code'] ?? '',
      name: map['name'] ?? '',
      description: map['description'],
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
    );
  }

  StateModel copyWith({
    int? id,
    String? tableName,
    String? code,
    String? name,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StateModel(
      id: id ?? this.id,
      tableName: tableName ?? this.tableName,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
