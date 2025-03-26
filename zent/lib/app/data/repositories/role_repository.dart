import '../models/base_model.dart';
import '../models/role_model.dart';
import 'base_repository.dart';

class RoleRepository extends BaseRepository<RoleModel> {
  RoleRepository() : super(tableName: 'roles');

  @override
  RoleModel fromMap(Map<String, dynamic> map) {
    return RoleModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      description: map['description'],
      createdAt: BaseModel.parseDateTime(map['created_at']),
      updatedAt: BaseModel.parseDateTime(map['updated_at']),
    );
  }

  // Find role by name
  Future<RoleModel?> findByName(String name) async {
    try {
      final results = await query('name = ?', [name]);
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      throw Exception('Error finding role by name: $e');
    }
  }

  // Search roles by name or description
  Future<List<RoleModel>> searchRoles(String searchTerm) async {
    try {
      String term = '%$searchTerm%';
      return await query('name LIKE ? OR description LIKE ?', [term, term]);
    } catch (e) {
      throw Exception('Error searching roles: $e');
    }
  }

  // Create with validation
  @override
  Future<RoleModel> create(RoleModel model) async {
    try {
      // Check for duplicate name
      final existingRole = await findByName(model.name);
      if (existingRole != null) {
        throw Exception('A role with this name already exists');
      }

      return await super.create(model);
    } catch (e) {
      throw Exception('Error creating role: $e');
    }
  }

  // Update with validation
  @override
  Future<RoleModel> update(RoleModel model) async {
    try {
      // Check for duplicate name, excluding this role's id
      final results =
          await query('name = ? AND id != ?', [model.name, model.id]);
      if (results.isNotEmpty) {
        throw Exception('Another role with this name already exists');
      }

      return await super.update(model);
    } catch (e) {
      throw Exception('Error updating role: $e');
    }
  }
}
