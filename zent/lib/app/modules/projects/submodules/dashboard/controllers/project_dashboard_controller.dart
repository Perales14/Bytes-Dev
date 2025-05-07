import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../data/models/project_model.dart';
import '../../../../../data/services/project_service.dart';
import '../../../../../data/services/project_context_service.dart';

class ProjectDashboardController extends GetxController {
  final ProjectService projectService;
  final ProjectContextService projectContextService;

  // Mantener el proyecto como observable
  final Rx<ProjectModel?> _project = Rx<ProjectModel?>(null);

  // Variables para estado de la UI
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // Getters
  ProjectModel? get project => _project.value;

  ProjectDashboardController({
    required this.projectService,
    required this.projectContextService,
  });

  @override
  void onInit() {
    super.onInit();
    _loadProjectData();
  }

  @override
  void onClose() {
    // Limpieza adicional si es necesaria
    super.onClose();
  }

  Future<void> _loadProjectData() async {
    try {
      isLoading(true);
      hasError(false);

      // Intentar obtener el proyecto del contexto
      ProjectModel? contextProject = projectContextService.currentProject;

      // Si no hay proyecto en el contexto, intentar obtenerlo de la ruta
      if (contextProject == null) {
        final String currentRoute = Get.currentRoute;
        final RegExp regex = RegExp(r'/projects/(\d+)/');
        final match = regex.firstMatch(currentRoute);

        if (match != null && match.groupCount >= 1) {
          final String projectIdStr = match.group(1)!;
          final int projectId = int.tryParse(projectIdStr) ?? 0;

          if (projectId > 0) {
            // Cargar el proyecto desde el servicio
            contextProject = await projectService.getProjectById(projectId);

            // Actualizar el contexto con este proyecto
            if (contextProject != null) {
              projectContextService.setCurrentProject(contextProject);
            }
          }
        }
      }

      // Verificar si tenemos un proyecto válido
      if (contextProject != null) {
        _project.value = contextProject;
      } else {
        // No se pudo cargar el proyecto
        hasError(true);
        errorMessage('No se pudo obtener el proyecto actual.');
        _showErrorAndNavigateBack();
      }
    } catch (e) {
      hasError(true);
      errorMessage('Error al cargar datos del proyecto: $e');
      _showErrorAndNavigateBack();
    } finally {
      isLoading(false);
    }
  }

  void _showErrorAndNavigateBack() {
    // Mostrar error y regresar a la lista de proyectos
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        duration: const Duration(seconds: 3),
      );

      // Regresar a la lista de proyectos después de mostrar el error
      Future.delayed(const Duration(seconds: 2), () {
        Get.offNamed('/projects');
      });
    });
  }

  void refreshData() {
    _loadProjectData();
  }

  void navigateBack() {
    // Limpiar el proyecto actual al salir
    projectContextService.clearCurrentProject();

    // Navegar a la vista de proyectos
    Get.offNamed('/projects');
  }
}
