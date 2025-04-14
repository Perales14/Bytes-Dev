import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/app/data/services/session_service.dart';
import 'package:zent/app/shared/models/sidebar_item.dart';

/// Controlador para manejar el estado y comportamiento de la barra lateral.
///
/// Gestiona los elementos visibles según el rol del usuario y controla
/// la navegación entre diferentes rutas de la aplicación.
class SidebarController extends GetxController {
  // Servicios
  late final SessionService _sessionService;

  /// Lista observable de elementos del sidebar según el rol del usuario
  final RxList<SidebarItem> _visibleSidebarItems = <SidebarItem>[].obs;

  /// Lista observable de elementos estáticos (siempre visibles)
  final RxList<SidebarItem> _staticSidebarItems = <SidebarItem>[].obs;

  /// Estado observable de apertura/cierre del sidebar
  final RxBool isOpen = true.obs;

  /// Obtiene los elementos visibles del sidebar
  List<SidebarItem> get visibleSidebarItems => _visibleSidebarItems;

  /// Obtiene los elementos estáticos del sidebar (parte inferior)
  List<SidebarItem> get staticSidebarItems => _staticSidebarItems;

  @override
  void onInit() {
    super.onInit();

    // Intentar obtener la instancia de SessionService de forma segura
    try {
      _sessionService = Get.find<SessionService>();
      // Cargar los elementos del sidebar al iniciar
      _loadDefaultSidebarItems();

      // Si hay un usuario autenticado, actualizar elementos según el rol
      if (_sessionService.isAuthenticated &&
          _sessionService.currentUser != null) {
        updateSidebarItemsByRoleId(_sessionService.currentUser!.roleId);
      }
    } catch (e) {
      // Si SessionService no está disponible, cargamos elementos por defecto
      print('SessionService no disponible: $e');
      _loadDefaultSidebarItems();
    }
  }

  /// Carga los elementos predeterminados del sidebar
  void _loadDefaultSidebarItems() {
    // Elementos dinámicos según el rol
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
        icon: Icons.people_rounded,
        label: 'Clientes',
        routeName: '/clients',
      ),
      SidebarItem(
        icon: Icons.store_rounded,
        label: 'Provedores',
        routeName: '/providers',
      ),
      SidebarItem(
        icon: Icons.business_center_rounded,
        label: 'Proyectos',
        routeName: '/projects',
      ),
      SidebarItem(
        icon: Icons.description_rounded,
        label: 'Documentos',
        routeName: '/documents',
      ),
    ];

    // Elementos estáticos (siempre visibles en la parte inferior)
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
        routeName: '/logout', // Cambiar a una ruta especial para logout
        isStatic: true,
      ),
    ];
  }

  /// Actualiza los elementos del sidebar según el rol del usuario por ID
  ///
  /// [roleId] - El ID del rol del usuario
  void updateSidebarItemsByRoleId(int roleId) {
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
    update(); // Notifica a los widgets que escuchan sobre el cambio
  }

  /// Actualiza los elementos del sidebar según el rol del usuario por nombre
  ///
  /// [role] - El nombre del rol del usuario
  void updateSidebarItemsByRole(String role) {
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
    update(); // Notifica a los widgets que escuchan sobre el cambio
  }

  /// Elementos del sidebar para Administradores
  void _loadAdminSidebarItems() {
    _visibleSidebarItems.value = [
      SidebarItem(
        icon: Icons.dashboard,
        label: 'Panel Principal',
        routeName: '/home',
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
        icon: Icons.business_center_rounded,
        label: 'Proyectos',
        routeName: '/projects',
      ),
      SidebarItem(
        icon: Icons.analytics,
        label: 'Reportes',
        routeName: '/reports',
      ),
      SidebarItem(
        icon: Icons.admin_panel_settings,
        label: 'Administración',
        routeName: '/admin',
      ),
    ];
  }

  /// Elementos del sidebar para Promotores
  void _loadPromotorSidebarItems() {
    _visibleSidebarItems.value = [
      SidebarItem(
        icon: Icons.dashboard,
        label: 'Inicio',
        routeName: '/home',
      ),
      SidebarItem(
        icon: Icons.business_center_rounded,
        label: 'Mis Proyectos',
        routeName: '/projects',
      ),
      SidebarItem(
        icon: Icons.people_rounded,
        label: 'Clientes',
        routeName: '/clients',
      ),
      SidebarItem(
        icon: Icons.description_rounded,
        label: 'Documentos',
        routeName: '/documents',
      ),
    ];
  }

  /// Elementos del sidebar para Captadores de campo
  void _loadCaptadorSidebarItems() {
    _visibleSidebarItems.value = [
      SidebarItem(
        icon: Icons.dashboard,
        label: 'Inicio',
        routeName: '/home',
      ),
      SidebarItem(
        icon: Icons.map,
        label: 'Zonas de Trabajo',
        routeName: '/zones',
      ),
      SidebarItem(
        icon: Icons.people_rounded,
        label: 'Prospectos',
        routeName: '/prospects',
      ),
      SidebarItem(
        icon: Icons.task_alt,
        label: 'Mis Tareas',
        routeName: '/tasks',
      ),
    ];
  }

  /// Elementos del sidebar para Recursos Humanos
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
        icon: Icons.groups,
        label: 'Gestión de Personal',
        routeName: '/personnel',
      ),
      SidebarItem(
        icon: Icons.assignment,
        label: 'Contratos',
        routeName: '/contracts',
      ),
      SidebarItem(
        icon: Icons.analytics,
        label: 'Reportes RRHH',
        routeName: '/hr-reports',
      ),
    ];
  }

  /// Verifica si una ruta está activa actualmente
  ///
  /// [routeName] - Nombre de la ruta a verificar
  /// Returns: true si la ruta está activa, false en caso contrario
  bool isRouteActive(String routeName) {
    return Get.currentRoute == routeName;
  }

  /// Navega a una ruta específica
  ///
  /// [routeName] - Nombre de la ruta a navegar
  void navigateTo(String routeName) {
    if (routeName == '/logout') {
      // Cerrar sesión usando el servicio de sesión
      _handleLogout();
    } else {
      Get.toNamed(routeName);
    }
  }

  /// Maneja el proceso de cierre de sesión
  void _handleLogout() async {
    try {
      await _sessionService.logout();
      Get.offAllNamed('/login');
    } catch (e) {
      print('Error al cerrar sesión: $e');
      Get.snackbar(
        'Error',
        'Ocurrió un error al cerrar sesión',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Alterna la visibilidad del sidebar
  void toggleSidebar() {
    isOpen.value = !isOpen.value;
  }
}
