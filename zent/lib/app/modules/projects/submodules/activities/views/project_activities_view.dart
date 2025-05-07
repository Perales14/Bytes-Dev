import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/project_activities_controller.dart';
import '../../../../../../app/data/models/project_model.dart';
import '../../../../../../app/data/services/project_context_service.dart';
import '../../../../../../app/shared/widgets/main_layout.dart';

/// Vista para la sección de actividades de un proyecto
class ProjectActivitiesView extends GetView<ProjectActivitiesController> {
  const ProjectActivitiesView({super.key});

  @override
  Widget build(BuildContext context) {
    final projectContextService = Get.find<ProjectContextService>();

    // Verificamos que exista un proyecto en el contexto
    if (projectContextService.currentProject == null) {
      return _buildErrorState('No se ha seleccionado un proyecto');
    }

    final ProjectModel project = projectContextService.currentProject!;

    // Cargamos los datos cuando se construye la vista
    controller.loadActivities(project);

    return MainLayout(
      pageTitle: 'Actividades: ${project.name}',
      textController: controller.textController,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Listado de actividades
            Expanded(
              child: Stack(
                children: [
                  Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.hasError.value) {
                      return _buildErrorState(controller.errorMessage.value);
                    }

                    final activities = controller.getFilteredActivities();

                    if (activities.isEmpty) {
                      return _buildEmptyState();
                    }

                    return ListView.separated(
                      itemCount: activities.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final activity = activities[index];

                        return ListTile(
                          title: Text(activity.title),
                          subtitle: Text(activity.description),
                          leading: _getPriorityIcon(activity.priority),
                          trailing: activity.dueDate != null
                              ? Text(
                                  _formatDate(activity.dueDate!),
                                  style: TextStyle(
                                    color: _getDueDateColor(activity.dueDate!),
                                  ),
                                )
                              : null,
                          onTap: () => _showActivityDetails(activity),
                        );
                      },
                    );
                  }),

                  // Botón flotante dentro del Stack
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: FloatingActionButton(
                      onPressed: _showAddActivityDialog,
                      tooltip: 'Agregar actividad',
                      child: const Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye el estado de error
  Widget _buildErrorState([String? message]) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Get.theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Error al cargar actividades',
            style: Get.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            message ?? controller.errorMessage.value,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Asegurar que el contexto del proyecto se limpie correctamente
              Get.find<ProjectContextService>().clearCurrentProject();
              // Navegar de vuelta a la lista de proyectos
              Get.offNamed('/projects');
            },
            child: const Text('Volver a Proyectos'),
          ),
        ],
      ),
    );
  }

  /// Construye el estado vacío
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.task_outlined,
            size: 48,
            color: Get.theme.colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No hay actividades para mostrar',
            style: Get.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Añade una nueva actividad para comenzar',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Obtiene el icono según la prioridad de la actividad
  Widget _getPriorityIcon(String priority) {
    IconData iconData;
    Color iconColor;

    switch (priority.toLowerCase()) {
      case 'alta':
        iconData = Icons.priority_high;
        iconColor = Colors.red;
        break;
      case 'media':
        iconData = Icons.remove;
        iconColor = Colors.orange;
        break;
      default:
        iconData = Icons.arrow_downward;
        iconColor = Colors.green;
    }

    return CircleAvatar(
      radius: 16,
      backgroundColor: iconColor.withOpacity(0.2),
      child: Icon(iconData, size: 16, color: iconColor),
    );
  }

  /// Obtiene el color según la fecha de vencimiento
  Color _getDueDateColor(DateTime dueDate) {
    final today = DateTime.now();
    final diff = dueDate.difference(today).inDays;

    if (diff < 0) {
      return Colors.red; // Vencido
    } else if (diff <= 2) {
      return Colors.orange; // Por vencer
    } else {
      return Colors.green; // A tiempo
    }
  }

  /// Formatea una fecha para mostrarla
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Muestra el diálogo para agregar una actividad
  void _showAddActivityDialog() {
    // Aquí se implementaría un diálogo para agregar una nueva actividad
    Get.dialog(
      AlertDialog(
        title: const Text('Agregar Actividad'),
        content: const Text('Funcionalidad por implementar'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  /// Muestra los detalles de una actividad
  void _showActivityDetails(dynamic activity) {
    // Aquí se implementaría un diálogo para mostrar los detalles de la actividad
    Get.dialog(
      AlertDialog(
        title: Text(activity.title),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Descripción: ${activity.description}'),
              if (activity.dueDate != null)
                Text('Fecha límite: ${_formatDate(activity.dueDate!)}'),
              Text('Prioridad: ${activity.priority}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
