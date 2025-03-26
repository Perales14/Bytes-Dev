import 'package:get/get.dart';
import '../models/activity_model.dart';
import '../providers/activity_provider.dart';

class ActivityService extends GetxService {
  final ActivityProvider _provider = ActivityProvider();

  // Basic CRUD operations
  Future<List<ActivityModel>> getAllActivities() => _provider.getAll();
  Future<ActivityModel?> getActivityById(int id) => _provider.getById(id);
  Future<ActivityModel> createActivity(ActivityModel activity) =>
      _provider.create(activity);
  Future<ActivityModel> updateActivity(ActivityModel activity) =>
      _provider.update(activity);
  Future<void> deleteActivity(int id) => _provider.delete(id);

  // Specific operations
  Future<List<ActivityModel>> getActivitiesByProject(int projectId) =>
      _provider.getByProject(projectId);
  Future<List<ActivityModel>> getActivitiesByManager(int managerId) =>
      _provider.getByManager(managerId);
  Future<List<ActivityModel>> getActivitiesByState(int stateId) =>
      _provider.getByState(stateId);
  Future<List<ActivityModel>> getPendingActivities() =>
      _provider.getPendingActivities();
  Future<List<ActivityModel>> getActivitiesByDependency(int dependencyId) =>
      _provider.getByDependency(dependencyId);
  Future<List<ActivityModel>> getActivitiesByDateRange(
          DateTime startDate, DateTime endDate) =>
      _provider.getByDateRange(startDate, endDate);
  Future<List<ActivityModel>> getOverdueActivities() =>
      _provider.getOverdueActivities();
  Future<List<ActivityModel>> getActivitiesWithEvidences() =>
      _provider.getActivitiesWithEvidences();

  // Business logic methods
  bool isActivityOverdue(ActivityModel activity) {
    if (activity.endDate == null) {
      return false;
    }
    return DateTime.now().isAfter(activity.endDate!);
  }

  bool isActivityCompleted(ActivityModel activity) {
    // Assuming state_id 3 is 'Completed'
    return activity.stateId == 3;
  }

  bool isActivityPending(ActivityModel activity) {
    return activity.endDate == null;
  }

  bool canActivityStart(ActivityModel activity) {
    if (activity.dependencyId == null) {
      return true;
    }

    // This would need to check if the dependency is completed
    // In a real implementation, you'd fetch the dependency activity and check its state
    return false;
  }

  // Calculate days remaining
  int? daysRemaining(ActivityModel activity) {
    if (activity.endDate == null || isActivityCompleted(activity)) {
      return null;
    }

    final today = DateTime.now();
    final difference = activity.endDate!.difference(today);
    return difference.inDays;
  }

  // Get activities blocking others
  Future<List<ActivityModel>> getBlockingActivities() async {
    final allActivities = await getAllActivities();
    List<int> dependencyIds = [];

    // Get all dependency IDs
    for (var activity in allActivities) {
      if (activity.dependencyId != null) {
        dependencyIds.add(activity.dependencyId!);
      }
    }

    // Filter activities that are dependencies and not completed
    return allActivities
        .where((activity) =>
            dependencyIds.contains(activity.id) &&
            !isActivityCompleted(activity))
        .toList();
  }
}
