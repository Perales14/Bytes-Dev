import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/app/shared/controllers/theme_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String pageTitle;
  final VoidCallback? onMenuPressed;
  final TextEditingController buscarappbar;


  CustomAppBar({
    super.key,
    required this.buscarappbar,
    required this.pageTitle,
    this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    // buscarappbar = TextEditingController();
    
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final ThemeController themeController = Get.find<ThemeController>();

    return Container(
      height: 68,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Menu toggle button
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: const Icon(Icons.menu),
                  iconSize: 20,
                  onPressed: onMenuPressed,
                  tooltip: 'Menu',
                ),
              ),

              // Theme toggle button
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Obx(() => IconButton(
                      icon: Icon(
                        themeController.theme.value == ThemeMode.dark
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined,
                      ),
                      iconSize: 20,
                      onPressed: () => themeController.toggleTheme(),
                      tooltip: themeController.theme.value == ThemeMode.dark
                          ? 'Cambiar a modo claro'
                          : 'Cambiar a modo oscuro',
                    )),
              ),
            ],
          ),

          // Middle - Page title
          Expanded(
            child: Center(
              child: Text(
                pageTitle,
                style: theme.textTheme.displayLarge?.copyWith(
                  letterSpacing: 1.2,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 38,
                  width: 350,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? theme.colorScheme.onSurfaceVariant.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        size: 16,
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: buscarappbar,
                          decoration: InputDecoration(
                            hintText: 'Buscar',
                            hintStyle: TextStyle(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.5),
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            // Replace zero padding with centered alignment
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 10),
                            // These properties ensure the TextField is transparent
                            filled: true,
                            fillColor: Colors.transparent,
                            // Remove any default background
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            // Add this to help with vertical alignment
                            isCollapsed: true,
                          ),
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 14,
                          ),
                          cursorColor: theme.colorScheme.onSurface,
                          textAlignVertical: TextAlignVertical.center,
                        ),
                      ),
                      Text(
                        '⌘+F',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.filter_alt_outlined),
                    iconSize: 20,
                    onPressed: () {},
                    tooltip: 'Filtros',
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    iconSize: 20,
                    onPressed: () {},
                    tooltip: 'Notificaciones',
                  ),
                ],
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(68);
}
