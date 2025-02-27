import 'package:get/get.dart';
import 'package:zent/models/sidebar_item.dart'; // Asegúrate de tener la ruta correcta
import 'package:flutter/material.dart';
import 'package:zent/routes/app_pages.dart'; // Importa las rutas nombradas

class SidebarController extends GetxController {
  // Lista de *todos* los posibles elementos del sidebar.
  final List<SidebarItem> allSidebarItems = [
    SidebarItem(
      icon: Icons.home,
      label: 'Inicio',
      routeName: AppPages.INITIAL, // Usa las rutas nombradas
      roles: ['admin', 'rrhh', 'promotor', 'captador_campo'],
    ),
    SidebarItem(
      icon: Icons.folder,
      label: 'Proyectos',
      routeName:
          '/', // Reemplaza '/proyectos' con la ruta real a la pantalla de proyectos
      roles: ['admin', 'rrhh', 'promotor', 'captador_campo'],
    ),
    SidebarItem(
      icon: Icons.assignment,
      label: 'Reportes',
      routeName:
          '/', // Reemplaza '/reportes' con la ruta real a la pantalla de reportes
      roles: ['admin', 'rrhh'],
    ),
    SidebarItem(
      icon: Icons.warning,
      label: 'Incidencias',
      routeName: '/',
      roles: ['admin', 'rrhh', 'promotor', 'captador_campo'],
    ),
    SidebarItem(
      icon: Icons.description,
      label: 'Documentos',
      routeName: '/',
      roles: ['admin', 'rrhh', 'captador_campo'],
    ),
    SidebarItem(
      icon: Icons.people,
      label: 'Clientes',
      routeName: '/',
      roles: ['admin', 'promotor'],
    ),
    SidebarItem(
      icon: Icons.person,
      label: 'Empleados',
      routeName: '/',
      roles: ['admin', 'rrhh'],
    ),
  ];

  // Método para filtrar los elementos visibles según el rol del usuario.
  List<SidebarItem> get visibleSidebarItems {
    // Simulamos un rol de usuario.  En una app real, obtendrías esto
    // de tu AuthController o similar.

    String? userRole; //Este sería nulo en la pantalla de login.
    //Descomentar cuando tengamos auth_controller
    // String? userRole = Get.find<AuthController>().user?.role;

    //Si el usuario no esta logueado, que muestre solo los botones estaticos
    //return [];

    return allSidebarItems
        .where((item) => item.roles.contains(userRole))
        .toList();
  }

  // Ítems estáticos del sidebar (Perfil y Cerrar Sesión)
  final List<SidebarItem> staticSidebarItems = [
    SidebarItem(
      icon: Icons.account_circle,
      label: 'Perfil',
      routeName: '/', // Reemplaza con la ruta a la pantalla de perfil
      roles: [
        'admin',
        'rrhh',
        'promotor',
        'captador_campo'
      ], // Todos los roles pueden ver su perfil
    ),
    SidebarItem(
      icon: Icons.exit_to_app,
      label: 'Cerrar Sesión',
      routeName:
          '/', // No necesitamos ruta real aquí, manejaremos esto directamente
      roles: [
        'admin',
        'rrhh',
        'promotor',
        'captador_campo'
      ], // Todos los roles pueden cerrar sesión
    ),
  ];
}
