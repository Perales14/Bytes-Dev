import 'package:get/get.dart';
import '../models/permission_model.dart';
import '../providers/permission_provider.dart';

class PermissionService extends GetxService {
  final PermissionProvider _provider = PermissionProvider();

  // Cache for quick permission checks
  final Map<String, bool> _permissionCache = {};

  // Basic operations
  Future<List<PermissionModel>> getAllPermissions() => _provider.getAll();
  Future<PermissionModel?> getPermissionsByRoleId(int roleId) =>
      _provider.getByRoleId(roleId);
  Future<int> updateRolePermissions(
          int roleId, Map<String, dynamic> newPermissions) =>
      _provider.updatePermissions(roleId, newPermissions);

  // Check if a role has a specific permission (with caching)
  Future<bool> hasPermission(int roleId, String module, String action) async {
    final cacheKey = '$roleId:$module:$action';

    if (_permissionCache.containsKey(cacheKey)) {
      return _permissionCache[cacheKey]!;
    }

    final result = await _provider.hasPermission(roleId, module, action);
    _permissionCache[cacheKey] = result;
    return result;
  }

  // Grant a specific permission to a role
  Future<void> grantPermission(int roleId, String module, String action) async {
    await _provider.addPermission(roleId, module, action);
    // Clear cache for this permission
    _permissionCache.remove('$roleId:$module:$action');
  }

  // Revoke a specific permission from a role
  Future<void> revokePermission(
      int roleId, String module, String action) async {
    await _provider.revokePermission(roleId, module, action);
    // Clear cache for this permission
    _permissionCache.remove('$roleId:$module:$action');
  }

  // Clear permission cache (e.g., after bulk updates)
  void clearPermissionCache() {
    _permissionCache.clear();
  }

  // Grant multiple permissions at once
  Future<void> grantMultiplePermissions(
      int roleId, Map<String, List<String>> moduleActions) async {
    for (final module in moduleActions.keys) {
      for (final action in moduleActions[module]!) {
        await grantPermission(roleId, module, action);
      }
    }
  }

  // Create a complete set of default permissions for a role
  Future<void> setupDefaultPermissions(int roleId,
      {bool isAdmin = false}) async {
    Map<String, dynamic> defaultPermissions = {};

    // Define modules with their actions
    final modules = {
      'users': ['view', 'create', 'edit', 'delete'],
      'projects': ['view', 'create', 'edit', 'delete'],
      'clients': ['view', 'create', 'edit', 'delete'],
      'documents': ['view', 'create', 'edit', 'delete'],
      'reports': ['view', 'generate', 'export'],
      'settings': ['view', 'edit'],
    };

    // For admin roles, grant all permissions
    if (isAdmin) {
      for (final module in modules.keys) {
        defaultPermissions[module] = {};
        for (final action in modules[module]!) {
          defaultPermissions[module][action] = true;
        }
      }
    }
    // For regular roles, grant only view permissions
    else {
      for (final module in modules.keys) {
        defaultPermissions[module] = {};
        for (final action in modules[module]!) {
          defaultPermissions[module][action] = action == 'view';
        }
      }
    }

    await updateRolePermissions(roleId, defaultPermissions);
    clearPermissionCache();
  }
}
