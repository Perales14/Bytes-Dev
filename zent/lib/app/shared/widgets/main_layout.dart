// lib/shared/layouts/main_layout.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/app/shared/controllers/sidebar_controller.dart';
import 'package:zent/app/shared/widgets/appbar.dart';
import 'package:zent/app/shared/widgets/sidebar/sidebar.dart';

/// Layout principal de la aplicación que incluye sidebar y appbar.
///
/// Este widget proporciona un estructura consistente para las páginas de la aplicación,
/// incluyendo una barra lateral y una barra superior personalizada.
class MainLayout extends StatelessWidget {
  /// Título de la página que se muestra en la barra superior
  final String pageTitle;

  /// Contenido principal de la página
  final Widget child;

  /// Controlador para el campo de búsqueda en la barra superior
  final TextEditingController textController; // Antes: text_controler

  /// Constructor para el layout principal
  const MainLayout({
    super.key,
    required this.textController, // Antes: text_controler
    required this.pageTitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final SidebarController sidebarController = Get.find<SidebarController>();

    return Scaffold(
      body: Obx(() => Row(
            children: [
              // Barra lateral con ancho animado
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: sidebarController.isOpen.value ? 212 : 0,
                height: double.infinity,
                child: const Sidebar(),
              ),

              // Contenido principal con barra superior personalizada
              Expanded(
                child: Column(
                  children: [
                    CustomAppBar(
                      searchController: textController, // Antes: text_controler
                      pageTitle: pageTitle,
                      onMenuPressed: () => sidebarController.toggleSidebar(),
                    ),
                    Expanded(child: child),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
