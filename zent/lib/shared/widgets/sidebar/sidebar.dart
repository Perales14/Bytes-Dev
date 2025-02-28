// shared/widgets/sidebar/sidebar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/controllers/sidebar_controller.dart';
import 'package:zent/models/sidebar_item.dart';
import 'package:zent/shared/widgets/sidebar/sidebar_button.dart';
import 'package:zent/shared/widgets/sidebar/sidebar_user_header.dart';

class Sidebar extends GetView<SidebarController> {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    // Accedemos a los colores directamente del Theme
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 212,
      constraints: const BoxConstraints(
        minHeight: 750,
      ),
      decoration: BoxDecoration(
        // Usamos la superficie como color de fondo del sidebar
        color: theme.colorScheme.surface,
        border: Border(
          right: BorderSide(
            // Usamos un color con opacidad para el borde
            color: isDark
                ? Colors.white.withOpacity(0.2)
                : Colors.black.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Usuario
          const Padding(
            padding: EdgeInsets.only(top: 18.0),
            child: SidebarUserHeader(
              userName: 'Juan Marín', // Datos de prueba
              userRole: 'Admin',
              userImageUrl: null,
            ),
          ),

          // Título "Dashboards"
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Text(
              'Dashboards',
              style: theme.textTheme.titleSmall,
            ),
          ),

          // Botones dinámicos (según el rol)
          Column(
            children: controller.visibleSidebarItems
                .map((item) => Column(
                      children: [
                        SidebarButton(
                          item: item,
                          isSelected: Get.currentRoute == item.routeName,
                          onPressed: () => Get.toNamed(item.routeName),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ))
                .toList(),
          ),

          const Spacer(),

          Column(
            children: controller.staticSidebarItems
                .map((item) => Column(
                      children: [
                        SidebarButton(
                          item: item,
                          isSelected: Get.currentRoute == item.routeName,
                          onPressed: () {
                            if (item.label == 'Cerrar Sesión') {
                              Get.offAllNamed('/');
                            } else {
                              Get.toNamed(item.routeName);
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    ))
                .toList(),
          ),

          // Logo
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                'assets/images/Logo_Consultoria.png',
                width: 70,
                height: 70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
