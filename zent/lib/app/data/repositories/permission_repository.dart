import 'dart:convert';
import '../models/base_model.dart';
import '../models/permission_model.dart';
import 'base_repository.dart';

class PermissionRepository extends BaseRepository<PermissionModel> {
  PermissionRepository() : super(tableName: 'permissions');

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
      createdAt: BaseModel.parseDateTime(map['created_at']),
      updatedAt: BaseModel.parseDateTime(map['updated_at']),
    );
  }

  // Get permissions by role ID
  Future<PermissionModel?> getByRoleId(int roleId) async {
    try {
      final results = await query('role_id = ?', [roleId]);
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      throw Exception('Error getting permissions by role: $e');
    }
  }

  // Update permissions for a specific role
  Future<int> updatePermissions(
      int roleId, Map<String, dynamic> newPermissions) async {
    try {
      PermissionModel? permission = await getByRoleId(roleId);

      if (permission != null) {
        // Update existing permissions
        permission.permissionsJson = newPermissions;
        await update(permission);
        return 1; // Return 1 indicating success
      } else {
        // Create new permissions record
        permission = PermissionModel(
          roleId: roleId,
          permissionsJson: newPermissions,
        );
        final created = await create(permission);
        return created.roleId; // Return the inserted ID
      }
    } catch (e) {
      throw Exception('Error updating permissions: $e');
    }
  }

  // Check if a role has a specific permission
  Future<bool> hasPermission(int roleId, String module, String action) async {
    try {
      final permission = await getByRoleId(roleId);
      if (permission == null || permission.permissionsJson == null) {
        return false;
      }

      // Navigate through the JSON to verify if the permission exists
      final modulePermissions = permission.permissionsJson![module];
      if (modulePermissions == null) {
        return false;
      }

      return modulePermissions[action] == true;
    } catch (e) {
      throw Exception('Error checking permission: $e');
    }
  }

  // Add a specific permission to a role
  Future<void> addPermission(int roleId, String module, String action) async {
    try {
      PermissionModel? permission = await getByRoleId(roleId);

      if (permission == null) {
        // Create new record with this permission
        final newPermissions = {
          module: {action: true}
        };
        await create(PermissionModel(
          roleId: roleId,
          permissionsJson: newPermissions,
        ));
      } else {
        // Update existing permissions
        final permissions = permission.permissionsJson ?? {};

        if (!permissions.containsKey(module)) {
          permissions[module] = {};
        }

        permissions[module][action] = true;
        permission.permissionsJson = permissions;
        await update(permission);
      }
    } catch (e) {
      throw Exception('Error adding permission: $e');
    }
  }

  // Revoke a specific permission from a role
  Future<void> revokePermission(
      int roleId, String module, String action) async {
    try {
      final permission = await getByRoleId(roleId);
      if (permission == null || permission.permissionsJson == null) {
        return;
      }

      final permissions = permission.permissionsJson!;
      if (permissions.containsKey(module) &&
          permissions[module] is Map &&
          permissions[module].containsKey(action)) {
        permissions[module][action] = false;
        permission.permissionsJson = permissions;
        await update(permission);
      }
    } catch (e) {
      throw Exception('Error revoking permission: $e');
    }
  }
}
