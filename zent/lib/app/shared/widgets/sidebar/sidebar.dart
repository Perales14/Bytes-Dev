import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/sidebar_controller.dart';
import '../../models/sidebar_item.dart';
import 'sidebar_button.dart';
import 'sidebar_user_header.dart';
import '../../../data/services/session_service.dart';

class Sidebar extends GetView<SidebarController> {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Obtener el servicio de sesión de forma segura
    String userName = 'Usuario';
    String userRole = '';

    try {
      final sessionService = Get.find<SessionService>();
      if (sessionService.isAuthenticated &&
          sessionService.currentUser != null) {
        userName = sessionService.currentUser?.fullName ?? 'Usuario';
        userRole = sessionService.userRole;
      }
    } catch (e) {
      // Si hay un error al obtener el servicio o los datos, usar valores predeterminados
      print('Error al acceder a SessionService: $e');
    }

    return Obx(() {
      // Use a condition to check if sidebar is visible enough to show content
      final bool showContent = controller.isOpen.value;

      return Container(
        height: double.infinity,
        width: controller.isOpen.value ? 212 : 0,
        clipBehavior: Clip.hardEdge, // Add clipping to prevent overflow
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            right: BorderSide(
              color: isDark
                  ? Colors.white.withOpacity(0.2)
                  : Colors.black.withOpacity(0.2),
              width: controller.isOpen.value ? 1 : 0, // Hide border when closed
            ),
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          child: showContent
              ? SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Información del usuario
                          Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: SidebarUserHeader(
                              userName: userName,
                              userRole: userRole,
                              userImageUrl:
                                  null, // Se puede implementar después
                            ),
                          ),

                          // Título "Dashboards"
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8.0),
                            child: Text(
                              'Dashboards',
                              style: theme.textTheme.headlineMedium,
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),

                          // Botones dinámicos (según el rol)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Obx(() => Column(
                                  children: controller.visibleSidebarItems
                                      .map((item) => Column(
                                            children: [
                                              SidebarButton(
                                                item: item,
                                                isSelected:
                                                    controller.isRouteActive(
                                                        item.routeName),
                                                onPressed: () {
                                                  controller.navigateTo(
                                                      item.routeName);
                                                  // Close drawer after navigation on mobile
                                                  if (MediaQuery.of(context)
                                                          .size
                                                          .width <
                                                      600) {
                                                    Navigator.pop(context);
                                                  }
                                                },
                                              ),
                                              const SizedBox(height: 16),
                                            ],
                                          ))
                                      .toList(),
                                )),
                          ),

                          const Spacer(),

                          // Botones estáticos (siempre visibles)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Obx(() => Column(
                                  children: controller.staticSidebarItems
                                      .map((item) => Column(
                                            children: [
                                              SidebarButton(
                                                item: item,
                                                isSelected:
                                                    controller.isRouteActive(
                                                        item.routeName),
                                                onPressed: () {
                                                  controller.navigateTo(
                                                      item.routeName);
                                                  // Close drawer after action on mobile
                                                  if (MediaQuery.of(context)
                                                          .size
                                                          .width <
                                                      600) {
                                                    Navigator.pop(context);
                                                  }
                                                },
                                              ),
                                              const SizedBox(height: 16),
                                            ],
                                          ))
                                      .toList(),
                                )),
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
                    ),
                  ),
                )
              : const SizedBox(), // Empty box when sidebar is closed
        ),
      );
    });
  }
}
