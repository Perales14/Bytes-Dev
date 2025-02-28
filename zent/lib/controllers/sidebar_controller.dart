import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/models/sidebar_item.dart';

class SidebarController extends GetxController {
  // Lista observable de elementos del sidebar según el rol del usuario
  final RxList<SidebarItem> _visibleSidebarItems = <SidebarItem>[].obs;
  // Lista observable de elementos estáticos (siempre visibles)
  final RxList<SidebarItem> _staticSidebarItems = <SidebarItem>[].obs;

  // Getters para acceder a las listas desde la vista
  List<SidebarItem> get visibleSidebarItems => _visibleSidebarItems;
  List<SidebarItem> get staticSidebarItems => _staticSidebarItems;

  @override
  void onInit() {
    super.onInit();
    // Cargar los elementos del sidebar al iniciar
    _loadSidebarItems();
  }

  // Método para cargar los elementos del sidebar según el rol del usuario
  void _loadSidebarItems() {
    // Elementos dinámicos según el rol (esto podría venir de una API o configuración)
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
      // Puedes añadir más elementos según las necesidades
    ];

    // Elementos estáticos (siempre visibles en la parte inferior)
    _staticSidebarItems.value = [
      SidebarItem(
        icon: Icons.settings,
        label: 'Configuración',
        routeName: '/settings',
      ),
      SidebarItem(
        icon: Icons.help,
        label: 'Ayuda',
        routeName: '/help',
      ),
      SidebarItem(
        icon: Icons.logout,
        label: 'Cerrar Sesión',
        routeName: '/logout',
      ),
    ];
  }

  // Método para actualizar los elementos del sidebar según el rol
  void updateSidebarItemsByRole(String role) {
    // Aquí implementarías la lógica para mostrar diferentes elementos
    // según el rol del usuario (admin, usuario normal, etc.)
    switch (role.toLowerCase()) {
      case 'admin':
        // Mostrar todos los elementos para administradores
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
        // Mostrar elementos limitados para usuarios normales
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
        // Elementos por defecto
        _loadSidebarItems();
    }
    update(); // Notificar a los widgets que escuchan sobre el cambio
  }

  // Método para verificar si una ruta está activa
  bool isRouteActive(String routeName) {
    return Get.currentRoute == routeName;
  }

  // Método para navegar a una ruta específica
  void navigateTo(String routeName) {
    if (routeName == '/logout') {
      // Lógica especial para cerrar sesión
      Get.offAllNamed('/');
    } else {
      Get.toNamed(routeName);
    }
  }
}
