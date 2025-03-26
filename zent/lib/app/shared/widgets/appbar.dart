import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/app/shared/controllers/theme_controller.dart';

/// Barra superior personalizada para la aplicación.
///
/// Proporciona funcionalidades como cambio de tema, búsqueda,
/// y muestra el título de la página actual.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Título de la página a mostrar en el centro de la barra
  final String pageTitle;

  /// Callback para el botón de menú que controla la barra lateral
  final VoidCallback? onMenuPressed;

  /// Controlador para el campo de búsqueda
  final TextEditingController searchController; // Antes: buscarappbar

  /// Crea una nueva barra superior personalizada.
  ///
  /// Requiere [searchController] y [pageTitle]. El parámetro
  /// [onMenuPressed] es opcional para controlar la acción del botón de menú.
  const CustomAppBar({
    super.key,
    required this.searchController, // Antes: buscarappbar
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
          _buildLeftSection(themeController, theme),
          _buildTitleSection(theme),
          _buildRightSection(theme, isDark),
        ],
      ),
    );
  }

  /// Construye la sección izquierda de la barra con botones de menú y tema
  Widget _buildLeftSection(ThemeController themeController, ThemeData theme) {
    return Row(
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
    );
  }

  /// Construye la sección central con el título de la página
  Widget _buildTitleSection(ThemeData theme) {
    return Expanded(
      child: Center(
        child: Text(
          pageTitle,
          style: theme.textTheme.displayLarge?.copyWith(
            letterSpacing: 1.2,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  /// Construye la sección derecha con barra de búsqueda y botones
  Widget _buildRightSection(ThemeData theme, bool isDark) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _buildSearchBar(theme, isDark),
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
    );
  }

  /// Construye la barra de búsqueda
  Widget _buildSearchBar(ThemeData theme, bool isDark) {
    return Container(
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
              controller: searchController, // Antes: buscarappbar
              decoration: InputDecoration(
                hintText: 'Buscar',
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                filled: true,
                fillColor: Colors.transparent,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(68);
}
