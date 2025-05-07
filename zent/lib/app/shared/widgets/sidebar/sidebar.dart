import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/sidebar_controller.dart';
import '../../models/sidebar_item.dart';
import 'sidebar_button.dart';
import 'sidebar_user_header.dart';
import '../../../data/services/session_service.dart';
import '../../../data/services/project_context_service.dart';

class Sidebar extends GetView<SidebarController> {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GetBuilder<SidebarController>(builder: (controller) {
      // Obtener datos del usuario
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
        print('Error al acceder a SessionService: $e');
      }

      return Obx(() {
        final bool showContent = controller.isOpen.value;

        // Verificar el estado del contexto del proyecto
        final projectContextService = Get.find<ProjectContextService>();
        if (projectContextService.justExitedProject) {
          // Asegurar de que el sidebar refleje que ya no hay un proyecto activo
          controller.updateForProjectExit();
          // Limpiar la bandera para que no se repita esta actualización
          projectContextService.resetExitedProjectFlag();
        }

        return Container(
          height: double.infinity,
          width: controller.isOpen.value ? 212 : 0,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              right: BorderSide(
                color: isDark
                    ? Colors.white.withOpacity(0.2)
                    : Colors.black.withOpacity(0.2),
                width: controller.isOpen.value ? 1 : 0,
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
                            // Cabecera de usuario
                            Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: SidebarUserHeader(
                                userName: userName,
                                userRole: userRole,
                                userImageUrl: null,
                              ),
                            ),

                            // Título Dashboards
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 8.0),
                              child: Text(
                                'Dashboards',
                                style: theme.textTheme.headlineMedium,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Elementos dinámicos
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

                            // Elementos estáticos
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
                : const SizedBox(),
          ),
        );
      });
    });
  }
}
