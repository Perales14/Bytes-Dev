import 'package:get/get.dart';
import '../models/role_model.dart';
import '../providers/role_provider.dart';

class RoleService extends GetxService {
  final RoleProvider _provider = RoleProvider();

  // Basic CRUD operations
  Future<List<RoleModel>> getAllRoles() => _provider.getAll();
  Future<RoleModel?> getRoleById(int id) => _provider.getById(id);
  Future<RoleModel> createRole(RoleModel role) => _provider.create(role);
  Future<RoleModel> updateRole(RoleModel role) => _provider.update(role);
  Future<void> deleteRole(int id) => _provider.delete(id);

  // Search operations
  Future<RoleModel?> findRoleByName(String name) => _provider.findByName(name);
  Future<List<RoleModel>> searchRoles(String searchTerm) =>
      _provider.searchRoles(searchTerm);

  // Get default role IDs
  Future<int> getAdminRoleId() async {
    final role = await findRoleByName('Administrador');
    return role?.id ?? 1;
  }

  Future<int> getEmployeeRoleId() async {
    final role = await findRoleByName('Empleado');
    return role?.id ?? 2;
  }

  // Business logic methods
  bool isValidRoleName(String name) {
    return name.isNotEmpty && name.length >= 3;
  }

  // Check if role is a system role (shouldn't be deleted)
  Future<bool> isSystemRole(int id) async {
    final role = await getRoleById(id);
    if (role == null) return false;

    // Define system roles that should not be deleted
    return ['Administrador', 'Empleado'].contains(role.name);
  }
}
