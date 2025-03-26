import 'dart:convert';
import 'base_model.dart';

class PermissionModel extends BaseModel {
  int roleId;
  Map<String, dynamic>? permissionsJson;
  bool sent;

  PermissionModel({
    required this.roleId,
    this.permissionsJson,
    this.sent = false,
    super.createdAt,
    super.updatedAt,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'role_id': roleId,
      'permissions_json':
          permissionsJson != null ? json.encode(permissionsJson) : null,
      'created_at': BaseModel.formatDateTime(createdAt),
      'updated_at': BaseModel.formatDateTime(updatedAt),
      'sent': sent ? 1 : 0,
    };
  }

  @override
  PermissionModel fromMap(Map<String, dynamic> map) {
    return PermissionModel(
      roleId: map['role_id'] ?? 0,
      permissionsJson: map['permissions_json'] != null
          ? (map['permissions_json'] is String
              ? json.decode(map['permissions_json'])
              : Map<String, dynamic>.from(map['permissions_json']))
          : null,
      sent: map['sent'] == 1 || map['sent'] == true,
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
    );
  }

  factory PermissionModel.fromJson(Map<String, dynamic> map) {
    return PermissionModel(
      roleId: map['role_id'] ?? 0,
      permissionsJson: map['permissions_json'],
      sent: map['sent'] == 1 || map['sent'] == true,
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
    );
  }

  PermissionModel copyWith({
    int? roleId,
    Map<String, dynamic>? permissionsJson,
    bool? sent,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PermissionModel(
      roleId: roleId ?? this.roleId,
      permissionsJson: permissionsJson ?? this.permissionsJson,
      sent: sent ?? this.sent,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
