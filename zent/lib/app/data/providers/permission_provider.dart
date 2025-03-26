import '../models/permission_model.dart';
import '../repositories/permission_repository.dart';

class PermissionProvider {
  final PermissionRepository _repository = PermissionRepository();

  // Basic operations
  Future<List<PermissionModel>> getAll() => _repository.getAll();
  Future<PermissionModel?> getByRoleId(int roleId) =>
      _repository.getByRoleId(roleId);
  Future<int> updatePermissions(
          int roleId, Map<String, dynamic> newPermissions) =>
      _repository.updatePermissions(roleId, newPermissions);

  // Permission validation
  Future<bool> hasPermission(int roleId, String module, String action) =>
      _repository.hasPermission(roleId, module, action);

  // Permission management
  Future<void> addPermission(int roleId, String module, String action) =>
      _repository.addPermission(roleId, module, action);
  Future<void> revokePermission(int roleId, String module, String action) =>
      _repository.revokePermission(roleId, module, action);
}
