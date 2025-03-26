import '../models/base_model.dart';
import '../models/incident_model.dart';
import 'base_repository.dart';

class IncidentRepository extends BaseRepository<IncidentModel> {
  IncidentRepository() : super(tableName: 'incidents');

  @override
  IncidentModel fromMap(Map<String, dynamic> map) {
    return IncidentModel(
      id: map['id'] ?? 0,
      projectId: map['project_id'] ?? 0,
      incidentTypeId: map['incident_type_id'],
      description: map['description'] ?? '',
      impactLevel: map['impact_level'],
      actions: map['actions'],
      createdAt: BaseModel.parseDateTime(map['created_at']),
      updatedAt: BaseModel.parseDateTime(map['updated_at']),
    );
  }

  // Get incidents by project
  Future<List<IncidentModel>> getByProject(int projectId) async {
    try {
      return await query('project_id = ?', [projectId]);
    } catch (e) {
      throw Exception('Error getting incidents by project: $e');
    }
  }

  // Get incidents by incident type
  Future<List<IncidentModel>> getByIncidentType(int incidentTypeId) async {
    try {
      return await query('incident_type_id = ?', [incidentTypeId]);
    } catch (e) {
      throw Exception('Error getting incidents by type: $e');
    }
  }

  // Get incidents by impact level
  Future<List<IncidentModel>> getByImpactLevel(String impactLevel) async {
    try {
      return await query('impact_level = ?', [impactLevel]);
    } catch (e) {
      throw Exception('Error getting incidents by impact level: $e');
    }
  }

  // Search incidents by description
  Future<List<IncidentModel>> searchByDescription(String description) async {
    try {
      return await query('description LIKE ?', ['%$description%']);
    } catch (e) {
      throw Exception('Error searching incidents by description: $e');
    }
  }

  // Create with validation
  @override
  Future<IncidentModel> create(IncidentModel model) async {
    try {
      // Validate impact level
      if (model.impactLevel != null &&
          !['Low', 'Medium', 'High'].contains(model.impactLevel)) {
        throw Exception('Invalid impact level. Must be Low, Medium or High');
      }

      return await super.create(model);
    } catch (e) {
      throw Exception('Error creating incident: $e');
    }
  }

  // Update with validation
  @override
  Future<IncidentModel> update(IncidentModel model) async {
    try {
      // Validate impact level
      if (model.impactLevel != null &&
          !['Low', 'Medium', 'High'].contains(model.impactLevel)) {
        throw Exception('Invalid impact level. Must be Low, Medium or High');
      }

      return await super.update(model);
    } catch (e) {
      throw Exception('Error updating incident: $e');
    }
  }
}
