import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/app/data/models/project_model.dart';
import 'package:zent/app/data/services/session_service.dart';
import 'package:zent/app/shared/models/sidebar_item.dart';
import 'package:zent/app/shared/widgets/dialogs/confirmation_dialog.dart';

/// Controlador responsable de gestionar los elementos de la barra lateral
/// y su comportamiento según el rol del usuario.
class SidebarController extends GetxController {
  // Inyección de dependencias
  final SessionService _sessionService = Get.find<SessionService>();

  // Variables reactivas
  final RxList<SidebarItem> _visibleSidebarItems = <SidebarItem>[].obs;
  final RxList<SidebarItem> _staticSidebarItems = <SidebarItem>[].obs;
  final RxBool isOpen = true.obs;

  // Variable para controlar cuando estamos en un submódulo de proyecto
  final Rx<ProjectModel?> _currentProject = Rx<ProjectModel?>(null);

  // Getters
  List<SidebarItem> get visibleSidebarItems => _visibleSidebarItems;
  List<SidebarItem> get staticSidebarItems => _staticSidebarItems;
  ProjectModel? get currentProject => _currentProject.value;

  @override
  void onInit() {
    super.onInit();
    _initializeSidebarItems();
  }

  /// Inicializa la barra lateral y configura los observers
  void _initializeSidebarItems() {
    try {
      _loadDefaultSidebarItems();
      _updateSidebarIfAuthenticated();

      // Configurar observers para cambios de autenticación y usuario
      ever(_sessionService.rxIsAuthenticated,
          (_) => _updateSidebarIfAuthenticated());
      ever(_sessionService.rxCurrentUser,
          (_) => _updateSidebarIfAuthenticated());

      // Observer para cambio de proyecto actual
      ever(_currentProject, (_) => _updateProjectSubmenuItems());
    } catch (e) {
      if (kDebugMode) {
        print('Error al inicializar SidebarController: $e');
      }
      _loadDefaultSidebarItems();
    }
  }

  /// Actualiza la barra lateral si hay un usuario autenticado
  void _updateSidebarIfAuthenticated() {
    if (_sessionService.isAuthenticated &&
        _sessionService.currentUser != null) {
      updateSidebarItemsByRoleId(_sessionService.currentUser!.roleId);
    } else {
      _loadDefaultSidebarItems();
    }
  }

  /// Establece el proyecto actual para mostrar su submenú
  void setCurrentProject(ProjectModel? project) {
    _currentProject.value = project;
  }

  /// Actualiza la barra lateral con opciones específicas de un proyecto
  void _updateProjectSubmenuItems() {
    final project = _currentProject.value;

    // Si no hay proyecto activo, restauramos el menú normal según el rol
    if (project == null) {
      _updateSidebarIfAuthenticated();
      return;
    }

    // Cargamos los elementos de submódulos de proyecto
    _loadProjectSubmenuItems(project);
  }

  /// Carga los elementos del submenú para un proyecto específico
  void _loadProjectSubmenuItems(ProjectModel project) {
    final int projectId = project.id;
    final String projectName = project.name;

    _visibleSidebarItems.value = [
      // Botón para volver a la lista de proyectos
      SidebarItem(
        icon: Icons.arrow_back,
        label: 'Volver a Proyectos',
        routeName: '/projects',
      ),

      // Título del proyecto (no navegable)
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

  /// Trunca un texto si excede la longitud especificada
  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Carga los elementos predeterminados de la barra lateral
  void _loadDefaultSidebarItems() {
    // Elementos dinámicos según el caso predeterminado
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

    // Elementos estáticos
    _staticSidebarItems.value = [
      SidebarItem(
        icon: Icons.settings,
        label: 'Configuración',
        routeName: '/settings',
        isStatic: true,
      ),
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
    // Si hay un proyecto activo, priorizamos mostrar su menú
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

  /// Actualiza los elementos de la barra lateral según el nombre del rol
  void updateSidebarItemsByRole(String role) {
    // Si hay un proyecto activo, priorizamos mostrar su menú
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

  /// Carga los elementos de la barra lateral para el rol de administrador
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
        icon: Icons.analytics,
        label: 'Reportes',
        routeName: '/reports',
      ),
    ];
  }

  /// Carga los elementos de la barra lateral para el rol de recursos humanos
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

  /// Carga los elementos de la barra lateral para el rol de promotor
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
      SidebarItem(
        icon: Icons.analytics,
        label: 'Reportes',
        routeName: '/reports',
      ),
    ];
  }

  /// Carga los elementos de la barra lateral para el rol de captador
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
        routeName: '/assigned-projects',
      ),
    ];
  }

  /// Verifica si la ruta actual está activa
  bool isRouteActive(String routeName) {
    return Get.currentRoute == routeName;
  }

  /// Navega a la ruta especificada o maneja el cierre de sesión
  void navigateTo(String routeName) {
    if (routeName == '/logout') {
      _handleLogout();
    } else {
      Get.toNamed(routeName);
    }
  }

  /// Maneja el proceso de cierre de sesión con confirmación
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

  /// Muestra un mensaje de error al cerrar sesión
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

  /// Alterna la visibilidad de la barra lateral
  void toggleSidebar() {
    isOpen.value = !isOpen.value;
  }
}
