import '../models/activity_model.dart';
import '../repositories/activity_repository.dart';

class ActivityProvider {
  final ActivityRepository _repository = ActivityRepository();

  // Basic CRUD operations
  Future<List<ActivityModel>> getAll() => _repository.getAll();
  Future<ActivityModel?> getById(int id) => _repository.getById(id);
  Future<ActivityModel> create(ActivityModel activity) =>
      _repository.create(activity);
  Future<ActivityModel> update(ActivityModel activity) =>
      _repository.update(activity);
  Future<void> delete(int id) => _repository.delete(id);

  // Specific operations
  Future<List<ActivityModel>> getByProject(int projectId) =>
      _repository.getByProject(projectId);
  Future<List<ActivityModel>> getByManager(int managerId) =>
      _repository.getByManager(managerId);
  Future<List<ActivityModel>> getByState(int stateId) =>
      _repository.getByState(stateId);
  Future<List<ActivityModel>> getPendingActivities() =>
      _repository.getPendingActivities();
  Future<List<ActivityModel>> getByDependency(int dependencyId) =>
      _repository.getByDependency(dependencyId);
  Future<List<ActivityModel>> getByDateRange(
          DateTime startDate, DateTime endDate) =>
      _repository.getByDateRange(startDate, endDate);
  Future<List<ActivityModel>> getOverdueActivities() =>
      _repository.getOverdueActivities();
  Future<List<ActivityModel>> getActivitiesWithEvidences() =>
      _repository.getActivitiesWithEvidences();
}
