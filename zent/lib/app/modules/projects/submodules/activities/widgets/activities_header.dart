import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/project_activities_controller.dart';

/// Widget que representa el encabezado de la vista de actividades
/// Contiene botón para agregar actividades y filtros de estado
class ActivitiesHeader extends GetWidget<ProjectActivitiesController> {
  const ActivitiesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        children: [
          // Botón para añadir nueva actividad y filtros
          Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // Espacio máximo entre elementos
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Botón de nueva actividad con tamaño fijo
              SizedBox(
                width: 200, // Ancho fijo
                child: _buildAddButton(theme),
              ),

              // Filtros de estados con tamaño fijo
              SizedBox(
                width: 200, // Ancho fijo
                child: _buildFiltersSection(theme),
              ),
            ],
          ),

          // Separador
          const SizedBox(height: 16),
          const Divider(height: 1),
        ],
      ),
    );
  }

  /// Construye el botón para añadir nueva actividad
  Widget _buildAddButton(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return ElevatedButton.icon(
      onPressed: () => controller.onAddActivityPressed(),
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        fixedSize:
            const Size.fromHeight(48), // Altura fija para igualar al filtro
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
      ),
      icon: Icon(
        Icons.add_circle_outline,
        size: 20,
        color: colorScheme.onSurface,
      ),
      label: const Text(
        'NUEVA ACTIVIDAD',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
          fontSize: 13,
        ),
      ),
    );
  }

  /// Construye la sección de filtros
  Widget _buildFiltersSection(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: () => controller.toggleStateFilterDropdown(),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 48, // Altura fija
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerColor.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icono de filtro
            Icon(
              Icons.filter_list,
              size: 20,
              color: colorScheme.secondary,
            ),
            const SizedBox(width: 8),

            // Texto de filtro seleccionado
            Expanded(
              child: Text(
                controller.selectedStateFiltersText,
                style: theme.textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Icono de dropdown
            Obx(() => Icon(
                  controller.isStateFilterDropdownOpen.value
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down,
                  color: colorScheme.primary,
                  size: 20,
                )),
          ],
        ),
      ),
    );
  }
}
