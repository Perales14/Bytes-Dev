import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/app/data/services/session_service.dart';
import 'package:zent/app/shared/models/sidebar_item.dart';

/// Controlador para manejar el estado y comportamiento de la barra lateral.
///
/// Gestiona los elementos visibles según el rol del usuario y controla
/// la navegación entre diferentes rutas de la aplicación.
class SidebarController extends GetxController {
  // Evita posibles errores de inicialización usando un getter para SessionService
  SessionService get _sessionService => Get.find<SessionService>();

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

    // Cargar los elementos del sidebar de forma segura
    try {
      _loadDefaultSidebarItems();

      // Si hay un usuario autenticado, actualizar elementos según el rol
      if (_sessionService.isAuthenticated &&
          _sessionService.currentUser != null) {
        updateSidebarItemsByRoleId(_sessionService.currentUser!.roleId);
      }
    } catch (e) {
      // Si SessionService no está disponible, cargamos elementos por defecto
      print('Error al cargar elementos del sidebar: $e');
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
        routeName: '/logout',
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
      // Obtener el tema actual para personalizar el diálogo
      final theme = Get.theme;
      final isDark = theme.brightness == Brightness.dark;

      // Colores adaptados al tema para mejor contraste
      final Color primaryColor = theme.colorScheme.primary;
      final Color backgroundColor = isDark
          ? theme.colorScheme.surface.withOpacity(0.9)
          : theme.colorScheme.surface;
      final Color textColor =
          isDark ? theme.colorScheme.onSurface : theme.colorScheme.onSurface;
      final Color cancelButtonColor =
          isDark ? Colors.grey.shade700 : Colors.grey.shade300;

      // Mostrar diálogo de confirmación personalizado
      final bool? confirmLogout = await Get.dialog<bool>(
        AlertDialog(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: primaryColor.withOpacity(0.5), width: 1),
          ),
          title: Text(
            'Cerrar Sesión',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            '¿Estás seguro que deseas cerrar tu sesión?',
            style: TextStyle(color: textColor),
          ),
          actions: [
            // Botón Cancelar
            TextButton(
              onPressed: () => Get.back(result: false),
              style: TextButton.styleFrom(
                backgroundColor: cancelButtonColor,
                foregroundColor: textColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Cancelar',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            // Botón Cerrar Sesión
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: theme.colorScheme.onPrimary,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              child: Text(
                'Cerrar Sesión',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
          titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
        ),
      );

      // Si el usuario no confirmó, cancelar la operación
      if (confirmLogout != true) return;

      // Navega a la pantalla de splash en modo de cierre de sesión
      Get.offAllNamed('/splash', arguments: {'loggingOut': true});
    } catch (e) {
      print('Error al cerrar sesión: $e');
      // Snackbar de error con estilo adaptativo
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

  /// Alterna la visibilidad del sidebar
  void toggleSidebar() {
    isOpen.value = !isOpen.value;
  }
}
