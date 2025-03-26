import '../models/base_model.dart';
import '../models/activity_model.dart';
import 'base_repository.dart';

class ActivityRepository extends BaseRepository<ActivityModel> {
  ActivityRepository() : super(tableName: 'activities');

  @override
  ActivityModel fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      id: map['id'] ?? 0,
      projectId: map['project_id'] ?? 0,
      description: map['description'] ?? '',
      managerId: map['manager_id'],
      startDate: BaseModel.parseDateTime(map['start_date']),
      endDate: BaseModel.parseDateTime(map['end_date']),
      dependencyId: map['dependency_id'],
      evidences:
          map['evidences'] != null ? List<String>.from(map['evidences']) : null,
      stateId: map['state_id'] ?? 0,
      createdAt: BaseModel.parseDateTime(map['created_at']),
      updatedAt: BaseModel.parseDateTime(map['updated_at']),
    );
  }

  // Get activities by project
  Future<List<ActivityModel>> getByProject(int projectId) async {
    try {
      return await query('project_id = ?', [projectId]);
    } catch (e) {
      throw Exception('Error getting activities by project: $e');
    }
  }

  // Get activities by manager
  Future<List<ActivityModel>> getByManager(int managerId) async {
    try {
      return await query('manager_id = ?', [managerId]);
    } catch (e) {
      throw Exception('Error getting activities by manager: $e');
    }
  }

  // Get activities by state
  Future<List<ActivityModel>> getByState(int stateId) async {
    try {
      return await query('state_id = ?', [stateId]);
    } catch (e) {
      throw Exception('Error getting activities by state: $e');
    }
  }

  // Get pending activities (no end date)
  Future<List<ActivityModel>> getPendingActivities() async {
    try {
      return await query('end_date IS NULL', []);
    } catch (e) {
      throw Exception('Error getting pending activities: $e');
    }
  }

  // Get activities by dependency
  Future<List<ActivityModel>> getByDependency(int dependencyId) async {
    try {
      return await query('dependency_id = ?', [dependencyId]);
    } catch (e) {
      throw Exception('Error getting activities by dependency: $e');
    }
  }

  // Get activities with date range
  Future<List<ActivityModel>> getByDateRange(
      DateTime startDate, DateTime endDate) async {
    try {
      return await query('start_date >= ? AND start_date <= ?', [
        BaseModel.formatDateTime(startDate),
        BaseModel.formatDateTime(endDate)
      ]);
    } catch (e) {
      throw Exception('Error getting activities by date range: $e');
    }
  }

  // Get overdue activities (past estimated end date but not completed)
  Future<List<ActivityModel>> getOverdueActivities() async {
    try {
      final now = BaseModel.formatDateTime(DateTime.now());
      return await query('end_date < ? AND state_id != ?',
          [now, 3] // Assuming state_id 3 is 'Completed'
          );
    } catch (e) {
      throw Exception('Error getting overdue activities: $e');
    }
  }

  // Get activities with evidences
  Future<List<ActivityModel>> getActivitiesWithEvidences() async {
    try {
      return await query('evidences IS NOT NULL', []);
    } catch (e) {
      throw Exception('Error getting activities with evidences: $e');
    }
  }
}
