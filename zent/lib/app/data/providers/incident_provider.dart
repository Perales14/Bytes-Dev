import '../models/incident_model.dart';
import '../repositories/incident_repository.dart';

class IncidentProvider {
  final IncidentRepository _repository = IncidentRepository();

  // Basic CRUD operations
  Future<List<IncidentModel>> getAll() => _repository.getAll();
  Future<IncidentModel?> getById(int id) => _repository.getById(id);
  Future<IncidentModel> create(IncidentModel incident) =>
      _repository.create(incident);
  Future<IncidentModel> update(IncidentModel incident) =>
      _repository.update(incident);
  Future<void> delete(int id) => _repository.delete(id);

  // Specific operations
  Future<List<IncidentModel>> getByProject(int projectId) =>
      _repository.getByProject(projectId);
  Future<List<IncidentModel>> getByIncidentType(int incidentTypeId) =>
      _repository.getByIncidentType(incidentTypeId);
  Future<List<IncidentModel>> getByImpactLevel(String impactLevel) =>
      _repository.getByImpactLevel(impactLevel);
  Future<List<IncidentModel>> searchByDescription(String description) =>
      _repository.searchByDescription(description);
}
