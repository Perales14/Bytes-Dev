import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/app/data/models/project_model.dart';
import 'package:zent/app/data/services/project_context_service.dart';
import 'package:zent/app/data/services/session_service.dart';
import 'package:zent/app/shared/models/sidebar_item.dart';
import 'package:zent/app/shared/widgets/dialogs/confirmation_dialog.dart';

/// Controlador responsable de gestionar los elementos de la barra lateral
/// y su comportamiento según el rol del usuario.
class SidebarController extends GetxController {
  final SessionService _sessionService = Get.find<SessionService>();
  final ProjectContextService _projectContextService =
      Get.find<ProjectContextService>();

  final RxList<SidebarItem> _visibleSidebarItems = <SidebarItem>[].obs;
  final RxList<SidebarItem> _staticSidebarItems = <SidebarItem>[].obs;
  final RxBool isOpen = true.obs;
  final Rx<ProjectModel?> _currentProject = Rx<ProjectModel?>(null);
  final RxString _currentRoute = ''.obs;

  List<SidebarItem> get visibleSidebarItems => _visibleSidebarItems;
  List<SidebarItem> get staticSidebarItems => _staticSidebarItems;
  ProjectModel? get currentProject => _currentProject.value;

  @override
  void onInit() {
    super.onInit();
    _initializeSidebarItems();
    _setupObservers();
  }

  void _setupObservers() {
    ever(_projectContextService.rxCurrentProject, _handleProjectContextChange);
    ever(_projectContextService.rxJustExitedProject, _handleProjectExit);

    _currentRoute.value = Get.currentRoute;
    ever(_currentRoute, _handleRouteChange);

    Get.rootController.addListener(() {
      if (Get.currentRoute != _currentRoute.value) {
        _currentRoute.value = Get.currentRoute;
      }
    });
  }

  void _handleProjectContextChange(ProjectModel? project) {
    _currentProject.value = project;
    _updateSidebarBasedOnCurrentState();
  }

  void _handleProjectExit(bool justExited) {
    if (justExited) {
      _currentProject.value = null;
      _updateSidebarIfAuthenticated();
      _projectContextService.resetExitedProjectFlag();
    }
  }

  void _handleRouteChange(String route) {
    if (route == '/projects') {
      _currentProject.value = null;
      _updateSidebarIfAuthenticated();
    } else if (route.contains('/projects/') && _currentProject.value == null) {
      final projectFromContext = _projectContextService.currentProject;
      if (projectFromContext != null) {
        _currentProject.value = projectFromContext;
        _updateProjectSubmenuItems();
      }
    }
  }

  void _updateProjectSubmenuItems() {
    if (_currentProject.value != null) {
      _loadProjectSubmenuItems(_currentProject.value!);
    }
  }

  void _initializeSidebarItems() {
    try {
      _loadDefaultSidebarItems();
      _updateSidebarIfAuthenticated();

      ever(_sessionService.rxIsAuthenticated,
          (_) => _updateSidebarIfAuthenticated());
      ever(_sessionService.rxCurrentUser,
          (_) => _updateSidebarIfAuthenticated());
    } catch (e) {
      if (kDebugMode) {
        print('Error al inicializar SidebarController: $e');
      }
      _loadDefaultSidebarItems();
    }
  }

  void _updateSidebarIfAuthenticated() {
    if (_sessionService.isAuthenticated &&
        _sessionService.currentUser != null) {
      updateSidebarItemsByRoleId(_sessionService.currentUser!.roleId);
    } else {
      _loadDefaultSidebarItems();
    }
  }

  void setCurrentProject(ProjectModel? project) {
    _currentProject.value = project;
    _updateSidebarBasedOnCurrentState();
  }

  void _updateSidebarBasedOnCurrentState() {
    if (_currentProject.value != null) {
      _loadProjectSubmenuItems(_currentProject.value!);
    } else {
      _updateSidebarIfAuthenticated();
    }
  }

  void _loadProjectSubmenuItems(ProjectModel project) {
    final int projectId = project.id;
    final String projectName = project.name;

    _visibleSidebarItems.value = [
      SidebarItem(
        icon: Icons.arrow_back,
        label: 'Volver a Proyectos',
        routeName: '/projects',
      ),
      SidebarItem(
        icon: Icons.business_center_rounded,
        label: 'Proyecto: ${_truncateText(projectName, 15)}',
        routeName: '/projects/$projectId/dashboard',
      ),
      SidebarItem(
        icon: Icons.event_note,
        label: 'Actividades',
        routeName: '/projects/$projectId/activities',
      ),
      SidebarItem(
        icon: Icons.description,
        label: 'Documentos',
        routeName: '/projects/$projectId/documents',
      ),
      SidebarItem(
        icon: Icons.analytics,
        label: 'Reportes',
        routeName: '/projects/$projectId/reports',
      ),
    ];
  }

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  void _loadDefaultSidebarItems() {
    _visibleSidebarItems.value = [
      SidebarItem(
        icon: Icons.dashboard,
        label: 'Inicio',
        routeName: '/home',
      ),
      SidebarItem(
        icon: Icons.business_center_rounded,
        label: 'Proyectos',
        routeName: '/projects',
      ),
      SidebarItem(
        icon: Icons.work_rounded,
        label: 'Empleados',
        routeName: '/employees',
      ),
      SidebarItem(
        icon: Icons.people_rounded,
        label: 'Clientes',
        routeName: '/clients',
      ),
      SidebarItem(
        icon: Icons.store_rounded,
        label: 'Proveedores',
        routeName: '/providers',
      ),
    ];

    _staticSidebarItems.value = [
      SidebarItem(
        icon: Icons.logout,
        label: 'Cerrar Sesión',
        routeName: '/logout',
        isStatic: true,
      ),
    ];
  }

  /// Actualiza los elementos de la barra lateral según el ID del rol
  void updateSidebarItemsByRoleId(int roleId) {
    if (_currentProject.value != null) {
      _loadProjectSubmenuItems(_currentProject.value!);
      return;
    }

    switch (roleId) {
      case SessionService.ROLE_ADMIN:
        _loadAdminSidebarItems();
        break;
      case SessionService.ROLE_PROMOTOR:
        _loadPromotorSidebarItems();
        break;
      case SessionService.ROLE_CAPTADOR:
        _loadCaptadorSidebarItems();
        break;
      case SessionService.ROLE_RRHH:
        _loadRRHHSidebarItems();
        break;
      default:
        _loadDefaultSidebarItems();
    }
    update();
  }

  void updateSidebarItemsByRole(String role) {
    if (_currentProject.value != null) {
      _loadProjectSubmenuItems(_currentProject.value!);
      return;
    }

    switch (role.toLowerCase()) {
      case 'administrador':
        _loadAdminSidebarItems();
        break;
      case 'promotor':
        _loadPromotorSidebarItems();
        break;
      case 'captador de campo':
        _loadCaptadorSidebarItems();
        break;
      case 'recursos humanos':
        _loadRRHHSidebarItems();
        break;
      default:
        _loadDefaultSidebarItems();
    }
    update();
  }

  void _loadAdminSidebarItems() {
    _visibleSidebarItems.value = [
      SidebarItem(
        icon: Icons.dashboard,
        label: 'Inicio',
        routeName: '/home',
      ),
      SidebarItem(
        icon: Icons.business_center_rounded,
        label: 'Proyectos',
        routeName: '/projects',
      ),
      SidebarItem(
        icon: Icons.work_rounded,
        label: 'Empleados',
        routeName: '/employees',
      ),
      SidebarItem(
        icon: Icons.people_rounded,
        label: 'Clientes',
        routeName: '/clients',
      ),
      SidebarItem(
        icon: Icons.store_rounded,
        label: 'Proveedores',
        routeName: '/providers',
      ),
      SidebarItem(
        icon: Icons.description_rounded,
        label: 'Documentos',
        routeName: '/documents',
      ),
    ];
  }

  void _loadRRHHSidebarItems() {
    _visibleSidebarItems.value = [
      SidebarItem(
        icon: Icons.dashboard,
        label: 'Inicio',
        routeName: '/home',
      ),
      SidebarItem(
        icon: Icons.work_rounded,
        label: 'Empleados',
        routeName: '/employees',
      ),
      SidebarItem(
        icon: Icons.store_rounded,
        label: 'Proveedores',
        routeName: '/providers',
      ),
      SidebarItem(
        icon: Icons.description_rounded,
        label: 'Documentos',
        routeName: '/documents',
      ),
    ];
  }

  void _loadPromotorSidebarItems() {
    _visibleSidebarItems.value = [
      SidebarItem(
        icon: Icons.dashboard,
        label: 'Inicio',
        routeName: '/home',
      ),
      SidebarItem(
        icon: Icons.business_center_rounded,
        label: 'Proyectos',
        routeName: '/projects',
      ),
      SidebarItem(
        icon: Icons.people_rounded,
        label: 'Clientes',
        routeName: '/clients',
      ),
    ];
  }

  void _loadCaptadorSidebarItems() {
    _visibleSidebarItems.value = [
      SidebarItem(
        icon: Icons.people_rounded,
        label: 'Clientes',
        routeName: '/clients',
      ),
      SidebarItem(
        icon: Icons.business_center_rounded,
        label: 'Proyectos Asignados',
        routeName: '/projects',
      ),
    ];
  }

  bool isRouteActive(String routeName) {
    if (routeName == '/projects' && _projectContextService.justExitedProject) {
      return true;
    }

    if (Get.currentRoute == '/projects' && routeName == '/projects') {
      return true;
    }

    return Get.currentRoute == routeName;
  }

  void navigateTo(String routeName) {
    if (routeName == '/logout') {
      _handleLogout();
    } else if (routeName == '/projects' && _currentProject.value != null) {
      navigateBackToProjects();
    } else {
      Get.toNamed(routeName);
    }
  }

  Future<void> _handleLogout() async {
    try {
      final bool? confirmLogout = await ConfirmationDialog.show(
        title: 'Cerrar Sesión',
        message: '¿Estás seguro que deseas cerrar tu sesión?',
        cancelButtonText: 'Cancelar',
        confirmButtonText: 'Cerrar Sesión',
      );

      if (confirmLogout != true) return;

      Get.offAllNamed('/splash', arguments: {'loggingOut': true});
    } catch (e) {
      if (kDebugMode) {
        print('Error al cerrar sesión: $e');
      }
      _showLogoutErrorSnackbar();
    }
  }

  void _showLogoutErrorSnackbar() {
    final theme = Get.theme;
    Get.snackbar(
      'Error',
      'Ocurrió un error al cerrar sesión. Intenta nuevamente.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: theme.colorScheme.error,
      colorText: theme.colorScheme.onError,
      duration: const Duration(seconds: 4),
      borderRadius: 8,
      margin: const EdgeInsets.all(12),
      icon: const Icon(Icons.error_outline, color: Colors.white),
    );
  }

  void toggleSidebar() {
    isOpen.value = !isOpen.value;
  }

  void updateForProjectExit() {
    _currentProject.value = null;
    _updateSidebarIfAuthenticated();
    update();
  }

  void navigateBackToProjects() {
    Get.offNamed('/projects');
    _currentProject.value = null;
    _updateSidebarIfAuthenticated();
    update();
  }
}
