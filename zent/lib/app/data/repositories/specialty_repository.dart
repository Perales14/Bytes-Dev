import '../models/base_model.dart';
import '../models/specialty_model.dart';
import 'base_repository.dart';

class SpecialtyRepository extends BaseRepository<SpecialtyModel> {
  SpecialtyRepository() : super(tableName: 'specialties');

  @override
  SpecialtyModel fromMap(Map<String, dynamic> map) {
    return SpecialtyModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      description: map['description'],
      createdAt: BaseModel.parseDateTime(map['created_at']) ?? DateTime.now(),
      updatedAt: BaseModel.parseDateTime(map['updated_at']) ?? DateTime.now(),
    );
  }

  // Find specialty by name
  Future<SpecialtyModel?> findByName(String name) async {
    try {
      final results = await query('name = ?', [name]);
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      throw Exception('Error finding specialty by name: $e');
    }
  }

  // Search specialties by term in name or description
  Future<List<SpecialtyModel>> findByTerm(String term) async {
    try {
      return await query(
          'name LIKE ? OR description LIKE ?', ['%$term%', '%$term%']);
    } catch (e) {
      throw Exception('Error searching specialties by term: $e');
    }
  }

  // Get specialty by ID with fallback
  @override
  Future<SpecialtyModel?> getById(int id) async {
    try {
      final result = await super.getById(id);
      if (result == null) {
        // Optional: Return a default model when not found
        return SpecialtyModel(
          id: id,
          name: 'Unknown',
          description: 'Specialty not found',
        );
      }
      return result;
    } catch (e) {
      throw Exception('Error getting specialty by ID: $e');
    }
  }

  // Create with validation
  @override
  Future<SpecialtyModel> create(SpecialtyModel model) async {
    try {
      // Check for duplicate name
      final existingSpecialty = await findByName(model.name);
      if (existingSpecialty != null) {
        throw Exception('A specialty with this name already exists');
      }

      return await super.create(model);
    } catch (e) {
      throw Exception('Error creating specialty: $e');
    }
  }

  // Update with validation
  @override
  Future<SpecialtyModel> update(SpecialtyModel model) async {
    try {
      // Check for duplicate name, excluding this specialty's id
      final results =
          await query('name = ? AND id != ?', [model.name, model.id]);
      if (results.isNotEmpty) {
        throw Exception('Another specialty with this name already exists');
      }

      return await super.update(model);
    } catch (e) {
      throw Exception('Error updating specialty: $e');
    }
  }
}
