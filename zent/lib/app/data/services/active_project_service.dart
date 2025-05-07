import 'package:get/get.dart';
import '../models/project_model.dart';
import '../../shared/controllers/sidebar_controller.dart';

/// Servicio centralizado para gestionar el proyecto actualmente seleccionado
///
/// Permite compartir el estado del proyecto activo entre diferentes módulos
/// y asegurar que el sidebar se actualice correctamente cuando cambia el proyecto activo
class ActiveProjectService extends GetxService {
  // Proyecto actualmente seleccionado
  final Rx<ProjectModel?> _currentProject = Rx<ProjectModel?>(null);

  // Observable para detectar si acabamos de salir de un proyecto
  final RxBool _justExitedProject = false.obs;

  // Getters
  ProjectModel? get currentProject => _currentProject.value;
  bool get justExitedProject => _justExitedProject.value;

  // Observable para uso externo
  Rx<ProjectModel?> get rxCurrentProject => _currentProject;

  @override
  void onInit() {
    super.onInit();

    // Observar cambios de ruta para detectar cuando salimos de una vista de proyecto
    ever(_currentProject, (_) => _updateSidebar());

    // Setup listener para cambios de ruta
    Get.rootController.addListener(_handleRouteChange);
  }

  @override
  void onClose() {
    Get.rootController.removeListener(_handleRouteChange);
    super.onClose();
  }

  /// Maneja los cambios de ruta para detectar cuando salimos de una vista de proyecto
  void _handleRouteChange() {
    final currentRoute = Get.currentRoute;

    // Si la ruta actual es la lista de proyectos y teníamos un proyecto activo
    // significa que estamos saliendo de una vista de proyecto
    if (currentRoute == '/projects' && _currentProject.value != null) {
      // Limpiar el proyecto actual
      final previousProject = _currentProject.value;
      _currentProject.value = null;

      // Marcar que acabamos de salir de un proyecto
      _justExitedProject.value = true;

      // Actualizar el sidebar
      _updateSidebar();

      // Programar reseteo del flag para evitar múltiples actualizaciones
      Future.delayed(const Duration(milliseconds: 300), () {
        _justExitedProject.value = false;
      });
    }
  }

  /// Establece el proyecto actualmente seleccionado
  void setActiveProject(ProjectModel project) {
    _currentProject.value = project;
    _justExitedProject.value = false;
  }

  /// Limpia el proyecto actualmente seleccionado
  void clearActiveProject() {
    if (_currentProject.value != null) {
      _currentProject.value = null;
      _justExitedProject.value = true;

      // Actualizar el sidebar
      _updateSidebar();

      // Programar reseteo del flag para evitar múltiples actualizaciones
      Future.delayed(const Duration(milliseconds: 300), () {
        _justExitedProject.value = false;
      });
    }
  }

  /// Actualiza el sidebar según el estado actual
  void _updateSidebar() {
    try {
      if (Get.isRegistered<SidebarController>()) {
        final sidebarController = Get.find<SidebarController>();

        // Actualizar el proyecto en el sidebar
        sidebarController.setCurrentProject(_currentProject.value);

        // Forzar actualización
        sidebarController.update();
      }
    } catch (e) {
      print('Error al actualizar sidebar: $e');
    }
  }

  /// Navega de regreso a la lista de proyectos
  void navigateBackToProjects() {
    // Primero navegar a la lista de proyectos
    Get.offNamed('/projects');

    // Luego limpiar el proyecto activo para actualizar el sidebar
    clearActiveProject();
  }
}
