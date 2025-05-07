import 'package:get/get.dart';
import '../../../../../data/models/project_model.dart';
import '../../../../../data/services/project_service.dart';

/// Controlador para el dashboard de un proyecto específico
class ProjectDashboardController extends GetxController {
  final ProjectService _projectService = Get.find<ProjectService>();

  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // Datos del proyecto
  final Rx<ProjectModel?> project = Rx<ProjectModel?>(null);

  // Métricas y estadísticas del proyecto
  final RxInt totalActivities = 0.obs;
  final RxInt completedActivities = 0.obs;
  final RxInt pendingDocuments = 0.obs;
  final RxDouble budget = 0.0.obs;
  final RxDouble completion = 0.0.obs;
  final RxInt daysLeft = 0.obs;

  /// Carga los datos del dashboard para un proyecto específico
  void loadDashboard(int projectId) {
    isLoading.value = true;
    hasError.value = false;

    try {
      // Aquí se cargarían los datos reales desde el servicio
      // Por ahora usamos datos de ejemplo
      _loadMockDashboardData(projectId);
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Error cargando datos del dashboard: $e';
    }
  }

  /// Carga datos de ejemplo para el dashboard
  void _loadMockDashboardData(int projectId) {
    Future.delayed(const Duration(milliseconds: 800), () {
      final now = DateTime.now();

      // Simular proyecto
      final mockProject = ProjectModel(
        id: projectId,
        name: 'Proyecto Demo',
        description: 'Este es un proyecto de demostración',
        clientId: 1,
        managerId: 1,
        startDate: now.subtract(const Duration(days: 30)),
        estimatedEndDate: now.add(const Duration(days: 60)),
        estimatedBudget: 50000.0,
        stateId: 2,
        commissionPercentage: 10.0,
      );

      // Actualizar proyecto
      project.value = mockProject;

      // Calcular días restantes
      if (mockProject.estimatedEndDate != null) {
        daysLeft.value = mockProject.estimatedEndDate!.difference(now).inDays;
      }

      // Actualizar métricas simuladas
      totalActivities.value = 12;
      completedActivities.value = 5;
      pendingDocuments.value = 3;
      budget.value = mockProject.estimatedBudget ?? 0.0;
      completion.value = 42.0; // Porcentaje de avance

      isLoading.value = false;
    });
  }

  /// Refresca los datos del dashboard
  void refreshData(int projectId) {
    loadDashboard(projectId);
  }

  /// Calcula el porcentaje de actividades completadas
  double getActivitiesCompletionRate() {
    if (totalActivities.value == 0) return 0.0;
    return (completedActivities.value / totalActivities.value) * 100;
  }

  /// Obtiene el estado de salud del proyecto basado en diversas métricas
  String getProjectHealthStatus() {
    // Aquí se podría implementar lógica más compleja
    if (completion.value < 20) {
      return 'En riesgo';
    } else if (completion.value < 50) {
      return 'Atención requerida';
    } else {
      return 'Saludable';
    }
  }
}
