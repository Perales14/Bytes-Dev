import '../models/base_model.dart';
import '../models/project_model.dart';
import 'base_repository.dart';

class ProjectRepository extends BaseRepository<ProjectModel> {
  ProjectRepository() : super(tableName: 'projects');

  @override
  ProjectModel fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      description: map['description'],
      clientId: map['client_id'] ?? 0,
      managerId: map['manager_id'] ?? 0,
      providerId: map['provider_id'],
      startDate: BaseModel.parseDateTime(map['start_date']),
      estimatedEndDate: BaseModel.parseDateTime(map['estimated_end_date']),
      actualEndDate: BaseModel.parseDateTime(map['actual_end_date']),
      deliveryDate: BaseModel.parseDateTime(map['delivery_date']),
      estimatedBudget: map['estimated_budget'] != null
          ? double.tryParse(map['estimated_budget'].toString())
          : null,
      actualCost: map['actual_cost'] != null
          ? double.tryParse(map['actual_cost'].toString())
          : null,
      commissionPercentage: map['commission_percentage'] != null
          ? double.tryParse(map['commission_percentage'].toString())
          : null,
      addressId: map['address_id'],
      stateId: map['state_id'] ?? 0,
      createdAt: BaseModel.parseDateTime(map['created_at']),
      updatedAt: BaseModel.parseDateTime(map['updated_at']),
    );
  }

  // Get projects by client
  Future<List<ProjectModel>> getByClient(int clientId) async {
    try {
      return await query('client_id = ?', [clientId]);
    } catch (e) {
      throw Exception('Error getting projects by client: $e');
    }
  }

  // Get projects by manager
  Future<List<ProjectModel>> getByManager(int managerId) async {
    try {
      return await query('manager_id = ?', [managerId]);
    } catch (e) {
      throw Exception('Error getting projects by manager: $e');
    }
  }

  // Get projects by provider
  Future<List<ProjectModel>> getByProvider(int providerId) async {
    try {
      return await query('provider_id = ?', [providerId]);
    } catch (e) {
      throw Exception('Error getting projects by provider: $e');
    }
  }

  // Get projects by state
  Future<List<ProjectModel>> getByState(int stateId) async {
    try {
      return await query('state_id = ?', [stateId]);
    } catch (e) {
      throw Exception('Error getting projects by state: $e');
    }
  }

  // Get in-progress projects (with start date but no actual end date)
  Future<List<ProjectModel>> getInProgressProjects() async {
    try {
      return await query(
          'start_date IS NOT NULL AND actual_end_date IS NULL', []);
    } catch (e) {
      throw Exception('Error getting in-progress projects: $e');
    }
  }

  // Get projects by date range
  Future<List<ProjectModel>> getByDateRange(
      DateTime startDate, DateTime endDate) async {
    try {
      return await query('start_date >= ? AND start_date <= ?', [
        BaseModel.formatDateTime(startDate),
        BaseModel.formatDateTime(endDate)
      ]);
    } catch (e) {
      throw Exception('Error getting projects by date range: $e');
    }
  }

  // Get overdue projects
  Future<List<ProjectModel>> getOverdueProjects() async {
    try {
      final now = BaseModel.formatDateTime(DateTime.now());
      return await query(
          'estimated_end_date < ? AND actual_end_date IS NULL', [now]);
    } catch (e) {
      throw Exception('Error getting overdue projects: $e');
    }
  }

  // Get completed projects
  Future<List<ProjectModel>> getCompletedProjects() async {
    try {
      return await query('actual_end_date IS NOT NULL', []);
    } catch (e) {
      throw Exception('Error getting completed projects: $e');
    }
  }

  // Search projects by name
  Future<List<ProjectModel>> searchByName(String term) async {
    try {
      return await query('name LIKE ?', ['%$term%']);
    } catch (e) {
      throw Exception('Error searching projects by name: $e');
    }
  }
}
