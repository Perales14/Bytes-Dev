import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/app/shared/models/sidebar_item.dart';

/// Controlador para manejar el estado y comportamiento de la barra lateral.
///
/// Gestiona los elementos visibles según el rol del usuario y controla
/// la navegación entre diferentes rutas de la aplicación.
class SidebarController extends GetxController {
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
// Cargar los elementos del sidebar al iniciar
    _loadSidebarItems();
  }

  /// Carga los elementos predeterminados del sidebar
  void _loadSidebarItems() {
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
        icon: Icons.analytics,
        label: 'Reportes',
        routeName: '/reports',
      ),
      SidebarItem(
        icon: Icons.edit_document,
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
      ),
      SidebarItem(
        icon: Icons.logout,
        label: 'Cerrar Sesión',
        routeName: '/logout',
      ),
    ];
  }

  /// Actualiza los elementos del sidebar según el rol del usuario
  ///
  /// [role] - El rol del usuario (admin, user, etc.)
  void updateSidebarItemsByRole(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        _visibleSidebarItems.value = [
          SidebarItem(
            icon: Icons.dashboard,
            label: 'Panel Principal',
            routeName: '/dashboard',
          ),
          SidebarItem(
            icon: Icons.people,
            label: 'Usuarios',
            routeName: '/users',
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
        break;
      case 'user':
        _visibleSidebarItems.value = [
          SidebarItem(
            icon: Icons.dashboard,
            label: 'Panel Principal',
            routeName: '/dashboard',
          ),
          SidebarItem(
            icon: Icons.analytics,
            label: 'Reportes',
            routeName: '/reports',
          ),
        ];
        break;
      default:
        _loadSidebarItems();
    }
    update(); // Notifica a los widgets que escuchan sobre el cambio
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
  /// [routeName] - Nombre de la ruta a la que ok,
  void navigateTo(String routeName) {
    if (routeName == '/logout') {
      // Lógica especial para cerrar sesión
      Get.offAllNamed('/');
    } else {
      Get.toNamed(routeName);
    }
  }

  /// Alterna la visibilidad del sidebar
  void toggleSidebar() {
    isOpen.value = !isOpen.value;
  }
}
