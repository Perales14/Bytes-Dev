import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/project_model.dart';
import '../../../data/services/project_service.dart';

class HomeController extends GetxController {
  final textController = TextEditingController();
  final userName = 'Usuario'.obs;
  final isLoading = true.obs;
  
  // Dashboard
  final totalProjects = 0.obs;
  final planningProjects = 0.obs;
  final inProgressProjects = 0.obs;
  final overdueProjects = 0.obs;
  
  // Proyectos recientes
  final recentProjects = <ProjectModel>[].obs;
  
  final ProjectService _projectService = Get.find<ProjectService>();

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    try {
      isLoading(true);
      
      // Obtener todos los proyectos
      final allProjects = await _projectService.getAllProjects();
      totalProjects.value = allProjects.length;
      
      // Contar proyectos por estado
      planningProjects.value = allProjects.where((p) => p.stateId == 1).length;
      inProgressProjects.value = allProjects.where((p) => p.stateId == 2).length;
      
      // Contar proyectos atrasados
      overdueProjects.value = allProjects.where((p) => 
        p.estimatedEndDate != null && 
        DateTime.now().isAfter(p.estimatedEndDate!) &&
        p.actualEndDate == null
      ).length;
      
      // Cargar proyectos recientes (ordenados por fecha de creación)
      await loadRecentProjects(allProjects);
      
    } catch (e) {
      print('Error cargando datos del dashboard: $e');
    } finally {
      isLoading(false);
    }
  }
  
  Future<void> loadRecentProjects([List<ProjectModel>? projects]) async {
    try {
      // Si ya tenemos los proyectos, no hacemos otra consulta
      final allProjects = projects ?? await _projectService.getAllProjects();
      
      // Ordenamos por fecha de creación (más recientes primero)
      allProjects.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      // Tomamos solo los 5 más recientes
      final recent = allProjects.take(5).toList();
      
      // Imprimimos para debug
      print('Proyectos recientes cargados: ${recent.length}');
      for (var project in recent) {
        print('  - ${project.name} (${project.createdAt})');
      }
      
      // Actualizamos la lista observable
      recentProjects.assignAll(recent);
    } catch (e) {
      print('Error cargando proyectos recientes: $e');
    }
  }

  // Método para refrescar manualmente los datos
  Future<void> refreshData() async {
    await loadDashboardData();
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}
