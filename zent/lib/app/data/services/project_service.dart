import 'package:get/get.dart';
import '../models/project_model.dart';
import '../providers/project_provider.dart';

class ProjectService extends GetxService {
  final ProjectProvider _provider = ProjectProvider();

  // Basic CRUD operations
  Future<List<ProjectModel>> getAllProjects() => _provider.getAll();
  Future<ProjectModel?> getProjectById(int id) => _provider.getById(id);
  Future<ProjectModel> createProject(ProjectModel project) =>
      _provider.create(project);
  Future<ProjectModel> updateProject(ProjectModel project) =>
      _provider.update(project);
  Future<void> deleteProject(int id) => _provider.delete(id);

  // Specific operations
  Future<List<ProjectModel>> getProjectsByClient(int clientId) =>
      _provider.getByClient(clientId);
  Future<List<ProjectModel>> getProjectsByManager(int managerId) =>
      _provider.getByManager(managerId);
  Future<List<ProjectModel>> getProjectsByProvider(int providerId) =>
      _provider.getByProvider(providerId);
  Future<List<ProjectModel>> getProjectsByState(int stateId) =>
      _provider.getByState(stateId);
  Future<List<ProjectModel>> getInProgressProjects() =>
      _provider.getInProgressProjects();
  Future<List<ProjectModel>> getProjectsByDateRange(
          DateTime startDate, DateTime endDate) =>
      _provider.getByDateRange(startDate, endDate);
  Future<List<ProjectModel>> getOverdueProjects() =>
      _provider.getOverdueProjects();
  Future<List<ProjectModel>> getCompletedProjects() =>
      _provider.getCompletedProjects();
  Future<List<ProjectModel>> searchProjectsByName(String term) =>
      _provider.searchByName(term);

  // Business logic methods

  // Check if project is in progress
  bool isInProgress(ProjectModel project) {
    return project.startDate != null && project.actualEndDate == null;
  }

  // Check if project is completed
  bool isCompleted(ProjectModel project) {
    return project.actualEndDate != null;
  }

  // Check if project is overdue
  bool isOverdue(ProjectModel project) {
    if (project.estimatedEndDate == null || project.actualEndDate != null) {
      return false;
    }
    return DateTime.now().isAfter(project.estimatedEndDate!);
  }

  // Calculate days remaining until estimated end date
  int? daysRemaining(ProjectModel project) {
    if (project.estimatedEndDate == null || isCompleted(project)) {
      return null;
    }

    final today = DateTime.now();
    final difference = project.estimatedEndDate!.difference(today);
    return difference.inDays;
  }

  // Calculate project completion percentage
  double? calculateCompletionPercentage(ProjectModel project) {
    if (project.startDate == null) {
      return 0.0;
    }

    if (project.actualEndDate != null) {
      return 100.0;
    }

    if (project.estimatedEndDate == null) {
      return null;
    }

    final totalDuration =
        project.estimatedEndDate!.difference(project.startDate!).inDays;
    if (totalDuration <= 0) {
      return 0.0;
    }

    final today = DateTime.now();
    final elapsed = today.difference(project.startDate!).inDays;

    // Calculate percentage with max of 99% until actually completed
    return (elapsed / totalDuration * 100).clamp(0.0, 99.0);
  }

  // Calculate budget variance
  double? calculateBudgetVariance(ProjectModel project) {
    if (project.estimatedBudget == null || project.actualCost == null) {
      return null;
    }

    return project.actualCost! - project.estimatedBudget!;
  }

  // Calculate budget variance percentage
  double? calculateBudgetVariancePercentage(ProjectModel project) {
    if (project.estimatedBudget == null ||
        project.actualCost == null ||
        project.estimatedBudget == 0) {
      return null;
    }

    return ((project.actualCost! - project.estimatedBudget!) /
        project.estimatedBudget! *
        100);
  }
}
