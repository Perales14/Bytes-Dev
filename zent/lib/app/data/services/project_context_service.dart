import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/project_model.dart';
import '../../shared/controllers/sidebar_controller.dart';
import '../services/session_service.dart';

/// Servicio para compartir contexto de proyecto entre submódulos
///
/// Este servicio permite compartir información del proyecto activo
/// entre diferentes submódulos sin tener que pasar argumentos entre rutas.
class ProjectContextService extends GetxService {
  // Proyecto actualmente seleccionado
  final Rx<ProjectModel?> _currentProject = Rx<ProjectModel?>(null);

  // Para rastrear el estado previo y detectar transiciones
  final Rx<ProjectModel?> _previousProject = Rx<ProjectModel?>(null);

  // Indicador de si se acaba de salir de un proyecto
  final RxBool _justExitedProject = false.obs;

  // Última ruta visitada (reactiva)
  final RxString _lastVisitedRoute = ''.obs;

  // Getters
  ProjectModel? get currentProject => _currentProject.value;
  ProjectModel? get previousProject => _previousProject.value;
  bool get justExitedProject => _justExitedProject.value;
  String get lastVisitedRoute => _lastVisitedRoute.value;

  // Observables
  Rx<ProjectModel?> get rxCurrentProject => _currentProject;
  Rx<ProjectModel?> get rxPreviousProject => _previousProject;
  RxBool get rxJustExitedProject => _justExitedProject;
  RxString get rxLastVisitedRoute => _lastVisitedRoute;

  @override
  void onInit() {
    super.onInit();

    // Inicializar la ruta actual
    _lastVisitedRoute.value = Get.currentRoute;

    // Configurar listener para cambios de ruta
    Get.rootController.addListener(_updateCurrentRoute);
  }

  @override
  void onClose() {
    Get.rootController.removeListener(_updateCurrentRoute);
    super.onClose();
  }

  /// Actualiza la ruta actual y maneja lógica relacionada
  void _updateCurrentRoute() {
    String currentRoute = Get.currentRoute;

    // Si la ruta ha cambiado
    if (currentRoute != _lastVisitedRoute.value) {
      // Guardar la ruta anterior
      String previousRoute = _lastVisitedRoute.value;

      // Actualizar la ruta actual
      _lastVisitedRoute.value = currentRoute;

      // Si la nueva ruta es /projects y teníamos un proyecto activo, marcarlo como recién salido
      if (currentRoute == '/projects' && _currentProject.value != null) {
        _previousProject.value = _currentProject.value;
        _currentProject.value = null;
        _justExitedProject.value = true;

        try {
          // Notificar a otros controladores que dependan de este cambio
          if (Get.isRegistered<SidebarController>()) {
            Get.find<SidebarController>().updateForProjectExit();
          }
        } catch (e) {
          print('Error al notificar salida de proyecto: $e');
        }
      }
    }
  }

  /// Establece el proyecto activo
  void setCurrentProject(ProjectModel project) {
    // Guardar el proyecto actual como previo antes de actualizarlo
    _previousProject.value = _currentProject.value;
    _currentProject.value = project;
    _justExitedProject.value = false;

    // Registrar la última ruta visitada
    _lastVisitedRoute.value = Get.currentRoute;
  }

  /// Limpia el proyecto activo
  void clearCurrentProject() {
    // Guardar el proyecto actual como previo antes de limpiarlo
    _previousProject.value = _currentProject.value;
    final hadProject = _currentProject.value != null;
    _currentProject.value = null;

    // Indicar que acabamos de salir de un proyecto
    if (hadProject) {
      _justExitedProject.value = true;

      try {
        // Notificar a otros controladores que dependan de este cambio
        if (Get.isRegistered<SidebarController>()) {
          Get.find<SidebarController>().updateForProjectExit();
        }
      } catch (e) {
        print('Error al notificar limpieza de proyecto: $e');
      }
    }

    // Registrar la última ruta visitada
    _lastVisitedRoute.value = Get.currentRoute;
  }

  /// Reinicia el indicador de salida de proyecto
  void resetExitedProjectFlag() {
    _justExitedProject.value = false;
  }

  /// Verifica si estábamos en un proyecto específico antes
  bool wasInProject(int projectId) {
    return _previousProject.value?.id == projectId;
  }

  /// Verifica si hubo un cambio de proyecto
  bool hasProjectChanged() {
    if (_currentProject.value == null && _previousProject.value != null) {
      return true; // Salimos de un proyecto
    }
    if (_currentProject.value != null && _previousProject.value == null) {
      return true; // Entramos a un proyecto
    }
    if (_currentProject.value != null && _previousProject.value != null) {
      return _currentProject.value!.id !=
          _previousProject.value!.id; // Cambio entre proyectos
    }
    return false; // No hubo cambio
  }

  /// Navega de regreso a la lista de proyectos, limpiando el estado
  void navigateBackToProjects() {
    // Guardar estado actual como previo
    _previousProject.value = _currentProject.value;

    // Limpiar proyecto actual
    _currentProject.value = null;

    // Establecer flag de salida
    if (_previousProject.value != null) {
      _justExitedProject.value = true;
    }

    // Primero navegar a proyectos para cambiar la ruta
    Get.offNamed('/projects');

    // Luego actualizar el sidebar explícitamente
    if (Get.isRegistered<SidebarController>()) {
      final sidebarController = Get.find<SidebarController>();

      // Establecer que no hay proyecto actual en el sidebar
      sidebarController.setCurrentProject(null);

      // Forzar actualización con el rol correcto
      if (Get.find<SessionService>().currentUser != null) {
        sidebarController.updateSidebarItemsByRoleId(
            Get.find<SessionService>().currentUser!.roleId);
      }

      // Forzar actualización visual
      sidebarController.update();
    }
  }
}
