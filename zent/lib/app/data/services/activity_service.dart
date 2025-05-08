import 'package:get/get.dart';
import '../models/activity_model.dart';
import '../providers/activity_provider.dart';

/// Servicio para gestionar operaciones de actividades
class ActivityService extends GetxService {
  final ActivityProvider _provider = ActivityProvider();

  // CRUD básico
  Future<List<ActivityModel>> getAllActivities() => _provider.getAll();
  Future<ActivityModel?> getActivityById(int id) => _provider.getById(id);
  Future<ActivityModel> createActivity(ActivityModel activity) =>
      _provider.create(activity);
  Future<ActivityModel> updateActivity(ActivityModel activity) =>
      _provider.update(activity);
  Future<void> deleteActivity(int id) => _provider.delete(id);

  // Operaciones específicas
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

  /// Lógica de negocio

  /// Verifica si una actividad está atrasada
  bool isActivityOverdue(ActivityModel activity) {
    if (activity.endDate == null) return false;
    return DateTime.now().isAfter(activity.endDate!);
  }

  /// Verifica si una actividad está completa
  bool isActivityCompleted(ActivityModel activity) {
    // Usando ID 3 para estado "Finalizado"
    return activity.stateId == 3;
  }

  /// Verifica si una actividad está pendiente
  bool isActivityPending(ActivityModel activity) {
    return activity.endDate == null;
  }

  /// Verifica si una actividad puede iniciar
  bool canActivityStart(ActivityModel activity) {
    if (activity.dependencyId == null) return true;

    // En una implementación real, se verificaría que la dependencia esté completa
    return false;
  }

  /// Calcula días restantes
  int? daysRemaining(ActivityModel activity) {
    if (activity.endDate == null || isActivityCompleted(activity)) return null;

    final today = DateTime.now();
    final difference = activity.endDate!.difference(today);
    return difference.inDays;
  }

  /// Obtiene actividades que bloquean otras
  Future<List<ActivityModel>> getBlockingActivities() async {
    final allActivities = await getAllActivities();
    List<int> dependencyIds = [];

    // Obtener IDs de dependencias
    for (var activity in allActivities) {
      if (activity.dependencyId != null) {
        dependencyIds.add(activity.dependencyId!);
      }
    }

    // Filtrar actividades que son dependencias y no están completadas
    return allActivities
        .where((activity) =>
            dependencyIds.contains(activity.id) &&
            !isActivityCompleted(activity))
        .toList();
  }
}
