import '../models/project_model.dart';
import '../repositories/project_repository.dart';

class ProjectProvider {
  final ProjectRepository _repository = ProjectRepository();

  // Basic CRUD operations
  Future<List<ProjectModel>> getAll() => _repository.getAll();
  Future<ProjectModel?> getById(int id) => _repository.getById(id);
  Future<ProjectModel> create(ProjectModel project) =>
      _repository.create(project);
  Future<ProjectModel> update(ProjectModel project) =>
      _repository.update(project);
  Future<void> delete(int id) => _repository.delete(id);

  // Specific operations
  Future<List<ProjectModel>> getByClient(int clientId) =>
      _repository.getByClient(clientId);
  Future<List<ProjectModel>> getByManager(int managerId) =>
      _repository.getByManager(managerId);
  Future<List<ProjectModel>> getByProvider(int providerId) =>
      _repository.getByProvider(providerId);
  Future<List<ProjectModel>> getByState(int stateId) =>
      _repository.getByState(stateId);
  Future<List<ProjectModel>> getInProgressProjects() =>
      _repository.getInProgressProjects();
  Future<List<ProjectModel>> getByDateRange(
          DateTime startDate, DateTime endDate) =>
      _repository.getByDateRange(startDate, endDate);
  Future<List<ProjectModel>> getOverdueProjects() =>
      _repository.getOverdueProjects();
  Future<List<ProjectModel>> getCompletedProjects() =>
      _repository.getCompletedProjects();
  Future<List<ProjectModel>> searchByName(String term) =>
      _repository.searchByName(term);
}
