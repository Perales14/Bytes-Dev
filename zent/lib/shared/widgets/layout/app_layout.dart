import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/shared/widgets/sidebar/sidebar.dart';
import 'package:zent/controllers/theme_controller.dart';

class AppLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;

  const AppLayout({
    super.key,
    required this.child,
    this.title = '',
    this.showBackButton = false,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ThemeController themeController = Get.find<ThemeController>();

    return Scaffold(
      body: Row(
        children: [
          // Sidebar siempre presente
          const Sidebar(),

          // Contenido principal
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Barra superior personalizada
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      if (showBackButton)
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Get.back(),
                        ),
                      if (title.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Text(
                          title,
                          style: theme.textTheme.titleLarge,
                        ),
                      ],
                      const Spacer(),
                      // Botón para cambiar tema
                      IconButton(
                        icon: Icon(themeController.theme.value == ThemeMode.dark
                            ? Icons.light_mode
                            : Icons.dark_mode),
                        onPressed: () => themeController.toggleTheme(),
                      ),
                      // Acciones adicionales
                      if (actions != null) ...actions!,
                    ],
                  ),
                ),

                // Contenido principal
                Expanded(
                  child: Container(
                    color: theme.colorScheme.surface,
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
