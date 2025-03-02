import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/controllers/theme_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String pageTitle;
  final VoidCallback? onMenuPressed;

  const CustomAppBar({
    super.key,
    required this.pageTitle,
    this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
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
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
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
                  height: 40,
                  width: 280,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.grey[800]
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
                          decoration: InputDecoration(
                            hintText: 'Buscar',
                            hintStyle: TextStyle(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.5),
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
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
                    icon: const Icon(Icons.notifications_outlined),
                    iconSize: 20,
                    onPressed: () {},
                    tooltip: 'Notificaciones',
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    iconSize: 20,
                    onPressed: () {},
                    tooltip: 'Configuración',
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
