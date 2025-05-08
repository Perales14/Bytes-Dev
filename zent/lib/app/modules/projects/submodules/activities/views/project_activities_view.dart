import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/project_activities_controller.dart';
import '../../../../../../app/shared/widgets/main_layout.dart';
import '../widgets/activities_header.dart';
import '../widgets/activities_grid.dart';
import '../../../../../data/services/project_context_service.dart';

/// Vista principal para la sección de actividades de un proyecto
/// Implementa un tablero Kanban con funcionalidad de arrastrar y soltar
class ProjectActivitiesView extends GetView<ProjectActivitiesController> {
  const ProjectActivitiesView({super.key});

  @override
  Widget build(BuildContext context) {
    // Verificar que el proyecto actual esté configurado correctamente
    final projectContextService = Get.find<ProjectContextService>();
    final currentProject = projectContextService.currentProject;

    return MainLayout(
      pageTitle: 'Actividades',
      textController: controller.textController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header con botón de nueva actividad y filtros
          const ActivitiesHeader(),

          // Mensaje si no hay proyecto activo
          if (currentProject == null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'No hay un proyecto seleccionado actualmente',
                  style: TextStyle(color: Colors.red[800], fontSize: 16),
                ),
              ),
            ),

          // Tablero Kanban - el scroll horizontal se maneja dentro de ActivitiesGrid
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.refreshActivities,
              // Usar directamente el ActivitiesGrid
              child: const ActivitiesGrid(),
            ),
          ),
        ],
      ),
    );
  }
}
