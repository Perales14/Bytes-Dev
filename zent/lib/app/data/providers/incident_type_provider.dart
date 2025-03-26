import '../models/incident_type_model.dart';
import '../repositories/incident_type_repository.dart';

class IncidentTypeProvider {
  final IncidentTypeRepository _repository = IncidentTypeRepository();

  // Basic CRUD operations
  Future<List<IncidentTypeModel>> getAll() => _repository.getAll();
  Future<IncidentTypeModel?> getById(int id) => _repository.getById(id);
  Future<IncidentTypeModel> create(IncidentTypeModel incidentType) =>
      _repository.create(incidentType);
  Future<IncidentTypeModel> update(IncidentTypeModel incidentType) =>
      _repository.update(incidentType);
  Future<void> delete(int id) => _repository.delete(id);

  // Specific operations
  Future<IncidentTypeModel?> findByName(String name) =>
      _repository.findByName(name);
  Future<List<IncidentTypeModel>> searchIncidentTypes(String searchTerm) =>
      _repository.searchIncidentTypes(searchTerm);
}
