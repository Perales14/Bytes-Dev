import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/project_service.dart';

class HomeController extends GetxController {
  final textController = TextEditingController();
  final userName = 'Usuario'.obs;
  final isLoading = true.obs;
  
  // Agregar variables para el dashboard
  final totalProjects = 0.obs;
  final planningProjects = 0.obs;
  final inProgressProjects = 0.obs;
  final overdueProjects = 0.obs;
  
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
      
    } catch (e) {
      print('Error cargando datos del dashboard: $e');
    } finally {
      isLoading(false);
    }
  }
}
