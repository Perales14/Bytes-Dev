import 'base_model.dart';

class RoleModel extends BaseModel {
  String name;
  String? description;

  RoleModel({
    super.id = 0,
    required this.name,
    this.description,
    super.createdAt,
    super.updatedAt,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': BaseModel.formatDateTime(createdAt),
      'updated_at': BaseModel.formatDateTime(updatedAt),
    };
  }

  @override
  RoleModel fromMap(Map<String, dynamic> map) {
    return RoleModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      description: map['description'],
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
    );
  }

  factory RoleModel.fromJson(Map<String, dynamic> map) {
    return RoleModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      description: map['description'],
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
    );
  }

  RoleModel copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RoleModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
