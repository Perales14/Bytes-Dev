import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/project_model.dart';
import '../controllers/projects_controller.dart';
import '../models/project_card_data.dart';
import 'cards/add_project_card.dart';
import 'project_card.dart';

class ProjectsCardsGrid extends StatelessWidget {
  static const double gridSpacing = 16.0;
  static const double gridPadding = 16.0;

  // Definimos una altura fija para todas las cards
  static const double fixedCardHeight = 250.0;

  final List<ProjectModel> projects;
  final VoidCallback onAddProject;
  final Function(int) onEditProject;

  const ProjectsCardsGrid({
    super.key,
    required this.projects,
    required this.onAddProject,
    required this.onEditProject,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectsController>(builder: (controller) {
      // Obtenemos el ancho de pantalla para ajustar número de columnas
      final screenWidth = MediaQuery.of(context).size.width;

      // Calculamos número de columnas basado en ancho de pantalla
      int crossAxisCount;
      if (screenWidth < 600) {
        crossAxisCount = 1; // Móvil
      } else if (screenWidth < 1100) {
        crossAxisCount = 2; // Tablet
      } else {
        crossAxisCount = 3; // Desktop
      }

      return Padding(
        padding: const EdgeInsets.all(gridPadding),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: gridSpacing,
            mainAxisSpacing: gridSpacing,
            // Usamos mainAxisExtent en lugar de childAspectRatio para forzar altura fija
            mainAxisExtent: fixedCardHeight,
          ),
          itemCount: projects.length + 1, // +1 para la card de añadir
          itemBuilder: (context, index) {
            if (index == 0) {
              // Card para añadir nuevo proyecto
              return SizedBox(
                height: fixedCardHeight, // Altura fija
                child: AddProjectCard(
                  onTap: onAddProject,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  foregroundColor: Theme.of(context).colorScheme.primary,
                ),
              );
            }

            final project = projects[index - 1];

            // Métricas para mostrar (limitadas a 3 para evitar overflow)
            final metrics = [
              ProjectMetric(
                icon: Icons.timeline,
                label: 'Progreso',
                value: _getCompletionPercentage(project),
                tooltip: 'Porcentaje de avance',
              ),
              if (project.estimatedBudget != null)
                ProjectMetric(
                  icon: Icons.monetization_on_outlined,
                  label: 'Presupuesto',
                  value: '\$${_formatCurrency(project.estimatedBudget!)}',
                  tooltip: 'Presupuesto estimado',
                ),
              if (project.estimatedEndDate != null)
                ProjectMetric(
                  icon: Icons.event,
                  label: 'Fecha límite',
                  value: _formatDate(project.estimatedEndDate!),
                  tooltip: 'Fecha estimada de finalización',
                ),
            ];

            final clientName = controller.getClientName(project.clientId);
            final managerName = controller.getManagerName(project.managerId);

            // Envolvemos en un SizedBox con altura fija
            return SizedBox(
              height: fixedCardHeight, // Altura fija
              child: ProjectCard(
                data: ProjectCardData(
                  name: project.name,
                  description: project.description ?? 'Sin descripción',
                  status: _getProjectStatus(project),
                  statusColor: _getStatusColor(context, project),
                  clientName: clientName,
                  managerName: managerName,
                  metrics:
                      metrics.take(3).toList(), // Limitamos a máximo 3 métricas
                  onTap: () => onEditProject(project.id),
                ),
                backgroundColor: Theme.of(context).cardTheme.color,
              ),
            );
          },
        ),
      );
    });
  }

  String _getProjectStatus(ProjectModel project) {
    if (project.actualEndDate != null) return 'Completado';
    if (project.startDate == null) return 'No iniciado';
    if (_isOverdue(project)) return 'Atrasado';
    return 'En progreso';
  }

  Color _getStatusColor(BuildContext context, ProjectModel project) {
    final theme = Theme.of(context);

    if (project.actualEndDate != null) {
      return Colors.green;
    }
    if (project.startDate == null) {
      return theme.colorScheme.primary;
    }
    if (_isOverdue(project)) {
      return theme.colorScheme.error;
    }
    return Colors.orange;
  }

  bool _isOverdue(ProjectModel project) {
    if (project.estimatedEndDate == null || project.actualEndDate != null) {
      return false;
    }
    return DateTime.now().isAfter(project.estimatedEndDate!);
  }

  String _getCompletionPercentage(ProjectModel project) {
    if (project.actualEndDate != null) {
      return '100%';
    }
    if (project.startDate == null || project.estimatedEndDate == null) {
      return '0%';
    }

    final total =
        project.estimatedEndDate!.difference(project.startDate!).inDays;
    if (total <= 0) return '0%';

    final elapsed = DateTime.now().difference(project.startDate!).inDays;
    final percentage = (elapsed / total * 100).clamp(0.0, 99.0).round();
    return '$percentage%';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatCurrency(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    } else {
      return value.toStringAsFixed(0);
    }
  }
}
