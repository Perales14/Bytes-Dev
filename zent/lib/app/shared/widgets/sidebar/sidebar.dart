import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/app/shared/controllers/sidebar_controller.dart';
import 'package:zent/app/shared/widgets/sidebar/sidebar_button.dart';
import 'package:zent/app/shared/widgets/sidebar/sidebar_user_header.dart';

class Sidebar extends GetView<SidebarController> {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8.0),
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
                                          isSelected: Get.currentRoute ==
                                              item.routeName,
                                          onPressed: () {
                                            Get.toNamed(item.routeName);
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
                          ),

                          const Spacer(),

                          Column(
                            children: controller.staticSidebarItems
                                .map((item) => Column(
                                      children: [
                                        SidebarButton(
                                          item: item,
                                          isSelected: Get.currentRoute ==
                                              item.routeName,
                                          onPressed: () {
                                            if (item.label == 'Cerrar Sesión') {
                                              Get.offAllNamed('/');
                                            } else {
                                              Get.toNamed(item.routeName);
                                            }
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
