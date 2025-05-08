import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../data/models/activity_model.dart';
import '../controllers/project_activities_controller.dart';
import 'activity_card.dart';

/// Widget que implementa un tablero Kanban para mostrar actividades agrupadas por estados
class ActivitiesGrid extends GetWidget<ProjectActivitiesController> {
  const ActivitiesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.filteredActivities.isEmpty) {
        return _buildEmptyState();
      }

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          // Usar SizedBox con altura específica en lugar de IntrinsicHeight
          height: MediaQuery.of(context).size.height * 0.75,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Columnas para cada estado filtrado
              if (controller.showStateId(1))
                _buildColumn(
                  context: context,
                  title: 'Sin comenzar',
                  activities: controller.getActivitiesByState(1),
                  stateId: 1,
                  color: Colors.grey,
                ),
              if (controller.showStateId(2))
                _buildColumn(
                  context: context,
                  title: 'En progreso',
                  activities: controller.getActivitiesByState(2),
                  stateId: 2,
                  color: Colors.blue,
                ),
              if (controller.showStateId(3))
                _buildColumn(
                  context: context,
                  title: 'Finalizadas',
                  activities: controller.getActivitiesByState(3),
                  stateId: 3,
                  color: Colors.green,
                ),
              if (controller.showStateId(4))
                _buildColumn(
                  context: context,
                  title: 'Canceladas',
                  activities: controller.getActivitiesByState(4),
                  stateId: 4,
                  color: Colors.orange,
                ),
              if (controller.showStateId(5))
                _buildColumn(
                  context: context,
                  title: 'Archivadas',
                  activities: controller.getActivitiesByState(5),
                  stateId: 5,
                  color: Colors.purple,
                ),
            ],
          ),
        ),
      );
    });
  }

  /// Construye una columna para un estado específico en el tablero Kanban
  Widget _buildColumn({
    required BuildContext context,
    required String title,
    required List<ActivityModel> activities,
    required int stateId,
    required Color color,
  }) {
    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título de la columna
            _buildColumnHeader(title, activities.length, color),

            // Lista de actividades para arrastrar y soltar
            Expanded(
              child: DragTarget<ActivityModel>(
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      color: candidateData.isNotEmpty
                          ? color.withOpacity(0.1)
                          : null,
                    ),
                    child: activities.isEmpty
                        ? _buildEmptyColumnIndicator(context)
                        : _buildActivityList(activities),
                  );
                },
                onWillAccept: (activity) => 
                    activity != null && activity.stateId != stateId,
                onAccept: (activity) {
                  controller.updateActivityState(activity, stateId);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye el encabezado de una columna del tablero
  Widget _buildColumnHeader(String title, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Título con punto de color
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: Get.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // Contador de actividades
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: Get.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construye la lista de actividades dentro de una columna
  Widget _buildActivityList(List<ActivityModel> activities) {
    // Usar un SingleChildScrollView con Column en lugar de ListView.builder
    // para evitar conflictos de scroll anidados
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: activities.map((activity) => _buildDraggableActivity(activity)).toList(),
      ),
    );
  }

  /// Construye una actividad arrastrable para el tablero Kanban
  Widget _buildDraggableActivity(ActivityModel activity) {
    return Draggable<ActivityModel>(
      data: activity,
      feedback: SizedBox(
        width: 280,
        child: Opacity(
          opacity: 0.8,
          child: ActivityCard(
            activity: activity,
            managerName: controller.getManagerName(activity.managerId),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: ActivityCard(
          activity: activity,
          managerName: controller.getManagerName(activity.managerId),
        ),
      ),
      child: ActivityCard(
        activity: activity,
        managerName: controller.getManagerName(activity.managerId),
        onTap: () => controller.onActivityTap(activity),
      ),
    );
  }

  /// Construye un indicador cuando una columna está vacía
  Widget _buildEmptyColumnIndicator(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.drag_indicator,
              size: 32,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 8),
            Text(
              'Arrastra actividades aquí',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye el estado vacío cuando no hay actividades
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No hay actividades',
            style: Get.textTheme.titleLarge?.copyWith(
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega una nueva actividad o ajusta los filtros',
            style: Get.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Clase de utilidad para mostrar un overlay de carga durante operaciones
class LoadingOverlay {
  final OverlayEntry _overlayEntry;

  LoadingOverlay._(this._overlayEntry);

  /// Muestra un overlay de carga con el mensaje especificado
  static LoadingOverlay show(String message) {
    final overlay = OverlayEntry(
      builder: (context) => Material(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(message),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(Get.overlayContext!).insert(overlay);
    return LoadingOverlay._(overlay);
  }

  /// Oculta el overlay de carga
  void hide() {
    _overlayEntry.remove();
  }
}
