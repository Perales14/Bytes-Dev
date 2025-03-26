import '../models/base_model.dart';
import '../models/incident_type_model.dart';
import 'base_repository.dart';

class IncidentTypeRepository extends BaseRepository<IncidentTypeModel> {
  IncidentTypeRepository() : super(tableName: 'incident_types');

  @override
  IncidentTypeModel fromMap(Map<String, dynamic> map) {
    return IncidentTypeModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      description: map['description'],
      createdAt: BaseModel.parseDateTime(map['created_at']),
      updatedAt: BaseModel.parseDateTime(map['updated_at']),
    );
  }

  // Find incident type by name
  Future<IncidentTypeModel?> findByName(String name) async {
    try {
      final results = await query('name = ?', [name]);
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      throw Exception('Error finding incident type by name: $e');
    }
  }

  // Search incident types
  Future<List<IncidentTypeModel>> searchIncidentTypes(String searchTerm) async {
    try {
      String term = '%$searchTerm%';
      return await query('name LIKE ? OR description LIKE ?', [term, term]);
    } catch (e) {
      throw Exception('Error searching incident types: $e');
    }
  }

  // Create with validation
  @override
  Future<IncidentTypeModel> create(IncidentTypeModel model) async {
    try {
      // Check for duplicate name
      final existingType = await findByName(model.name);
      if (existingType != null) {
        throw Exception('An incident type with this name already exists');
      }

      return await super.create(model);
    } catch (e) {
      throw Exception('Error creating incident type: $e');
    }
  }

  // Update with validation
  @override
  Future<IncidentTypeModel> update(IncidentTypeModel model) async {
    try {
      // Check for duplicate name, excluding this type's id
      final results =
          await query('name = ? AND id != ?', [model.name, model.id]);
      if (results.isNotEmpty) {
        throw Exception('Another incident type with this name already exists');
      }

      return await super.update(model);
    } catch (e) {
      throw Exception('Error updating incident type: $e');
    }
  }
}
