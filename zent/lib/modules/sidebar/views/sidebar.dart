import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/core/theme/app_theme.dart';
import 'package:zent/controllers/sidebar_controller.dart';
import 'package:zent/models/sidebar_item.dart';
import 'package:zent/shared/widgets/sidebar_button.dart';
import 'package:zent/shared/widgets/sidebar_user_header.dart';

class Sidebar extends GetView<SidebarController> {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppTheme>()!.colors;

    return Container(
      width: 212,
      constraints: const BoxConstraints(
        minHeight: 750,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border(
          right: BorderSide(
            color: colors.black20,
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
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          // Botones dinámicos (según el rol)
          // QUITAMOS el Obx exterior
          Column(
            children: controller.visibleSidebarItems
                .map((item) => SidebarButton(
                      item: item,
                      isSelected: Get.currentRoute == item.routeName,
                      onPressed: () => Get.toNamed(item.routeName),
                    ))
                .toList(),
          ),

          const Spacer(), // Empuja los siguientes elementos hacia abajo

          // Botones estáticos (Perfil y Cerrar Sesión)
          // QUITAMOS el Obx exterior
          Column(
            children: controller.staticSidebarItems
                .map((item) => SidebarButton(
                      item: item,
                      isSelected: Get.currentRoute == item.routeName,
                      onPressed: () {
                        if (item.label == 'Cerrar Sesión') {
                          Get.offAllNamed('/');
                        } else {
                          Get.toNamed(item.routeName);
                        }
                      },
                    ))
                .toList(),
          ),

          // Logo
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              /*child: Image.asset(
                'assets/logo.png',
                width: 70,
                height: 70,
              ),*/
            ),
          ),
        ],
      ),
    );
  }
}
