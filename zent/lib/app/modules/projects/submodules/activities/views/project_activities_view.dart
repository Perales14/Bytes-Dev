import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/project_activities_controller.dart';
import '../../../../../../app/shared/widgets/main_layout.dart';
import '../widgets/activities_header.dart';
import '../widgets/activities_grid.dart';

/// Vista principal para la sección de actividades de un proyecto
/// Implementa un tablero Kanban con funcionalidad de arrastrar y soltar
class ProjectActivitiesView extends GetView<ProjectActivitiesController> {
  const ProjectActivitiesView({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      pageTitle: 'Actividades',
      textController: controller.textController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con botón de nueva actividad y filtros
          const ActivitiesHeader(),

          // Tablero Kanban - ocupa el resto del espacio disponible
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.refreshActivities,
              child: const ActivitiesGrid(),
            ),
          ),
        ],
      ),
    );
  }
}
