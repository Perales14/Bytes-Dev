import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/project_activities_controller.dart';

/// Widget que representa el encabezado de la vista de actividades
/// Contiene botón para agregar actividades y filtros de estado
class ActivitiesHeader extends GetWidget<ProjectActivitiesController> {
  const ActivitiesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        children: [
          // Botón para añadir nueva actividad y filtros
          Row(
            children: [
              // Botón de nueva actividad
              Expanded(
                flex: 2,
                child: _buildAddButton(),
              ),
              const SizedBox(width: 16),

              // Filtros de estados
              Expanded(
                flex: 3,
                child: _buildFiltersSection(),
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
  Widget _buildAddButton() {
    return ElevatedButton.icon(
      onPressed: () => controller.onAddActivityPressed(),
      style: ElevatedButton.styleFrom(
        backgroundColor: Get.theme.colorScheme.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: const Icon(Icons.add_circle_outline, size: 20),
      label: const Text(
        'NUEVA ACTIVIDAD',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  /// Construye la sección de filtros
  Widget _buildFiltersSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Etiqueta de filtros
          Row(
            children: [
              Icon(
                Icons.filter_list,
                size: 18,
                color: Get.theme.colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              Text(
                'Filtrar por estado:',
                style: Get.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Get.theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Dropdown con checkboxes para filtrar estados
          Obx(() => _buildStateFilter()),
        ],
      ),
    );
  }

  /// Construye el filtro de estados usando un dropdown con checkboxes
  Widget _buildStateFilter() {
    return InkWell(
      onTap: () => controller.toggleStateFilterDropdown(),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                controller.selectedStateFiltersText,
                style: Get.textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              controller.isStateFilterDropdownOpen.value
                  ? Icons.arrow_drop_up
                  : Icons.arrow_drop_down,
              color: Get.theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
