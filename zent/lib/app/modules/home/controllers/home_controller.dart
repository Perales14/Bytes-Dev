import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/project_model.dart';
import '../../../data/services/project_service.dart';
import '../../../data/services/session_service.dart';

/// Controlador para la pantalla principal (Home)
/// Gestiona datos de proyectos y métricas del dashboard
class HomeController extends GetxController {
  // Controlador para campos de texto
  final textController = TextEditingController();

  // Variables observables
  final userName = 'Usuario'.obs;
  final isLoading = true.obs;

  // Métricas de proyectos
  final totalProjects = 0.obs;
  final planningProjects = 0.obs;
  final inProgressProjects = 0.obs;
  final overdueProjects = 0.obs;

  // Listado de proyectos recientes
  final recentProjects = <ProjectModel>[].obs;

  // Servicios inyectados
  final ProjectService _projectService = Get.find<ProjectService>();
  final SessionService _sessionService = Get.find<SessionService>();

  @override
  void onInit() {
    super.onInit();
    _getUserName();
    loadDashboardData();
  }

  /// Obtiene y actualiza el nombre del usuario de la sesión actual
  void _getUserName() {
    final currentUser = _sessionService.currentUser;
    if (currentUser != null) {
      userName.value = currentUser.name;
    }
  }

  /// Carga todos los datos necesarios para el dashboard
  Future<void> loadDashboardData() async {
    try {
      isLoading(true);

      final allProjects = await _projectService.getAllProjects();

      _updateProjectMetrics(allProjects);
      _updateRecentProjects(allProjects);
    } catch (e) {
      Get.log('Error cargando datos del dashboard: $e');
    } finally {
      isLoading(false);
    }
  }

  /// Actualiza las métricas de proyectos según los datos recibidos
  void _updateProjectMetrics(List<ProjectModel> projects) {
    totalProjects.value = projects.length;
    planningProjects.value = projects.where((p) => p.stateId == 1).length;
    inProgressProjects.value = projects.where((p) => p.stateId == 2).length;

    overdueProjects.value = projects
        .where((p) =>
            p.estimatedEndDate != null &&
            DateTime.now().isAfter(p.estimatedEndDate!) &&
            p.actualEndDate == null)
        .length;
  }

  /// Actualiza la lista de proyectos recientes
  void _updateRecentProjects(List<ProjectModel> projects) {
    // Ordenamos por fecha de creación (más recientes primero)
    projects.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    // Tomamos solo los más recientes
    final recent = projects.take(5).toList();
    recentProjects.assignAll(recent);
  }

  /// Método para refrescar manualmente los datos del dashboard
  Future<void> refreshData() async {
    await loadDashboardData();
    Get.snackbar(
      'Datos Actualizados',
      'La información del dashboard ha sido actualizada',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}
