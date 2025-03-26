import '../models/role_model.dart';
import '../repositories/role_repository.dart';

class RoleProvider {
  final RoleRepository _repository = RoleRepository();

  // Basic CRUD operations
  Future<List<RoleModel>> getAll() => _repository.getAll();
  Future<RoleModel?> getById(int id) => _repository.getById(id);
  Future<RoleModel> create(RoleModel role) => _repository.create(role);
  Future<RoleModel> update(RoleModel role) => _repository.update(role);
  Future<void> delete(int id) => _repository.delete(id);

  // Search operations
  Future<RoleModel?> findByName(String name) => _repository.findByName(name);
  Future<List<RoleModel>> searchRoles(String searchTerm) =>
      _repository.searchRoles(searchTerm);
}
