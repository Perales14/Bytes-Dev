import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/app/data/services/session_service.dart';
import 'package:zent/app/shared/models/sidebar_item.dart';
import 'package:zent/app/shared/widgets/dialogs/confirmation_dialog.dart';

class SidebarController extends GetxController {
  final SessionService _sessionService = Get.find<SessionService>();

  final RxList<SidebarItem> _visibleSidebarItems = <SidebarItem>[].obs;
  final RxList<SidebarItem> _staticSidebarItems = <SidebarItem>[].obs;
  final RxBool isOpen = true.obs;

  List<SidebarItem> get visibleSidebarItems => _visibleSidebarItems;
  List<SidebarItem> get staticSidebarItems => _staticSidebarItems;

  @override
  void onInit() {
    super.onInit();

    try {
      // Inicializar con los elementos por defecto
      _loadDefaultSidebarItems();

      // Si hay un usuario autenticado, actualizar basado en su rol
      _updateSidebarIfAuthenticated();

      // Escuchar cambios en el estado de autenticación y el usuario actual
      ever(_sessionService.rxIsAuthenticated, (_) => _updateSidebarIfAuthenticated());
      ever(_sessionService.rxCurrentUser, (_) => _updateSidebarIfAuthenticated());
    } catch (e) {
      if (kDebugMode) {
        print('Error al inicializar SidebarController: $e');
      }
      _loadDefaultSidebarItems();
    }
  }

  void _updateSidebarIfAuthenticated() {
    if (_sessionService.isAuthenticated && _sessionService.currentUser != null) {
      updateSidebarItemsByRoleId(_sessionService.currentUser!.roleId);
    } else {
      _loadDefaultSidebarItems();
    }
  }

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
    update();
  }

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
    update();
  }

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

  bool isRouteActive(String routeName) {
    return Get.currentRoute == routeName;
  }

  void navigateTo(String routeName) {
    if (routeName == '/logout') {
      _handleLogout();
    } else {
      Get.toNamed(routeName);
    }
  }

  void _handleLogout() async {
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
  }

  void toggleSidebar() {
    isOpen.value = !isOpen.value;
  }
}
