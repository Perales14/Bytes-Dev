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
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.hasError.value) {
                  return ErrorState(
                    message: controller.errorMessage.value,
                    onRetry: controller.refreshData,
                  );
                }
                final projects = controller.getFilteredProjects();
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
