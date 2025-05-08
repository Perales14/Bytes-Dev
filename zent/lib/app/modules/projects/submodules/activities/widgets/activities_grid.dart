import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../data/models/activity_model.dart';
import '../controllers/project_activities_controller.dart';
import 'activity_card.dart';

/// Widget que implementa un tablero Kanban para actividades
class ActivitiesGrid extends GetWidget<ProjectActivitiesController> {
  const ActivitiesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      // Mostrar mensaje cuando no hay actividades
      if (controller.activities.isEmpty) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 100.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_note,
                        size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text(
                      'No hay actividades',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Agrega una nueva actividad usando el botón "Nueva Actividad"',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => controller.onAddActivityPressed(),
                      icon: const Icon(Icons.add),
                      label: const Text('Nueva Actividad'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }

      // Para que el RefreshIndicator funcione con scroll horizontal
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            // Altura fija para el tablero
            height: MediaQuery.of(context).size.height * 0.75,
            // Contenedor para el scroll horizontal con tamaño forzado
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Espacio al inicio para estética
                  const SizedBox(width: 8),

                  // Columnas para cada estado usando IDs unificados
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
                      title: 'Finalizado',
                      activities: controller.getActivitiesByState(3),
                      stateId: 3,
                      color: Colors.green,
                    ),
                  if (controller.showStateId(4))
                    _buildColumn(
                      context: context,
                      title: 'Cancelado',
                      activities: controller.getActivitiesByState(4),
                      stateId: 4,
                      color: Colors.orange,
                    ),
                  if (controller.showStateId(5))
                    _buildColumn(
                      context: context,
                      title: 'Archivado',
                      activities: controller.getActivitiesByState(5),
                      stateId: 5,
                      color: Colors.purple,
                    ),

                  // Columna invisible extra para forzar scroll
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    color: Colors.transparent,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  /// Construye una columna para el tablero Kanban
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
            // Título y contador
            _buildColumnHeader(title, activities.length, color),

            // Lista de actividades con soporte para drag & drop
            Expanded(
              child: DragTarget<ActivityModel>(
                builder: (context, candidateData, rejectedData) {
                  return Container(
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
                onWillAcceptWithDetails: (details) =>
                    details.data.stateId != stateId,
                onAcceptWithDetails: (details) {
                  controller.updateActivityState(details.data, stateId);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye el encabezado de una columna
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
          // Título con indicador de color
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

  /// Construye la lista de actividades
  Widget _buildActivityList(List<ActivityModel> activities) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      physics: const BouncingScrollPhysics(),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        return _buildDraggableActivity(activities[index]);
      },
    );
  }

  /// Construye una actividad arrastrable
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

  /// Construye un indicador para columnas vacías
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
}
