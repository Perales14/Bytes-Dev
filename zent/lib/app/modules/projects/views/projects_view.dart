import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/widgets/main_layout.dart';
import '../controllers/projects_controller.dart';
import '../widgets/cards/projects_cards_grid.dart';
import '../widgets/add_project_dialog.dart';
import '../widgets/utils/error_state.dart';

class ProjectsView extends GetView<ProjectsController> {
  const ProjectsView({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      textController: controller.textController,
      pageTitle: 'Proyectos',
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 28),
            Expanded(
              child: Obx(() {
                // Mostrar indicador de carga principal mientras los proyectos se cargan
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Mostrar error si hay problemas
                if (controller.hasError.value) {
                  return ErrorState(
                    message: controller.errorMessage.value,
                    onRetry: controller.refreshData,
                  );
                }

                // Si se están cargando los nombres, mostrar un indicador de carga con mensaje
                if (!controller.areClientNamesLoaded.value ||
                    !controller.areManagerNamesLoaded.value) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                            'Cargando información de clientes y responsables...'),
                      ],
                    ),
                  );
                }

                // Obtener los proyectos filtrados del controlador
                final projects = controller.getFilteredProjects();

                // Si no hay proyectos, mostrar un mensaje
                if (projects.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.folder_outlined,
                          size: 48,
                          color: Get.theme.colorScheme.primary.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay proyectos disponibles',
                          style: Get.textTheme.headlineSmall?.copyWith(
                            color: Get.theme.colorScheme.onSurface
                                .withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: _showAddProjectDialog,
                          icon: const Icon(Icons.add),
                          label: const Text('Crear nuevo proyecto'),
                        ),
                      ],
                    ),
                  );
                }

                // Mostrar la cuadrícula de proyectos
                return ProjectsCardsGrid(
                  projects: projects,
                  onAddProject: _showAddProjectDialog,
                  onEditProject: controller.showEditProjectDialog,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddProjectDialog() {
    Get.dialog(
      AddProjectDialog(
        onSaveSuccess: controller.refreshData,
      ),
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
    );
  }
}
