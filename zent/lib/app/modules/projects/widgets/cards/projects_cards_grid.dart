import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/project_model.dart';
import '../../../../data/services/client_service.dart';
import '../../../../data/services/user_service.dart';
import '../../models/project_card_data.dart';
import 'add_project_card.dart';
import 'project_card.dart';

class ProjectsCardsGrid extends StatelessWidget {
  static const double spacing = 28.0;
  static const double padding = 28.0;

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
    final clientService = Get.find<ClientService>();
    final userService = Get.find<UserService>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth - (padding * 2);
        final maxCardsPerRow =
            (availableWidth + spacing) ~/ (ProjectCard.cardMaxWidth + spacing);
        final minCardsPerRow =
            (availableWidth + spacing) ~/ (ProjectCard.cardMinWidth + spacing);

        // Elegimos el número óptimo de tarjetas por fila
        final itemsPerRow = maxCardsPerRow > 0
            ? maxCardsPerRow
            : (minCardsPerRow > 0 ? minCardsPerRow : 1);

        return GridView.builder(
          padding: const EdgeInsets.all(padding),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: itemsPerRow,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            mainAxisExtent: ProjectCard
                .cardHeight, // Usar mainAxisExtent en lugar de childAspectRatio
          ),
          itemCount: projects.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return AddProjectCard(onTap: onAddProject);
            }

            final project = projects[index - 1];
            String clientName = 'Cliente #${project.clientId}';
            String managerName = 'Gestor #${project.managerId}';

            clientService.getClientById(project.clientId).then((client) {
              if (client != null) clientName = client.fullName;
            });

            userService.getUserById(project.managerId).then((user) {
              if (user != null) managerName = user.fullName;
            });

            return ProjectCard(
              data: ProjectCardData(
                name: project.name,
                description: project.description ?? 'Sin descripción',
                status: _getProjectStatus(project),
                statusColor: _getStatusColor(context, project),
                clientName: clientName,
                managerName: managerName,
                metrics: [
                  ProjectMetric(
                    icon: Icons.task_alt_outlined,
                    label: 'Progreso',
                    value: _getCompletionPercentage(project),
                    tooltip: 'Porcentaje de avance',
                  ),
                  if (project.estimatedBudget != null)
                    ProjectMetric(
                      icon: Icons.monetization_on_outlined,
                      label: 'Presupuesto',
                      value: '\$${project.estimatedBudget?.toStringAsFixed(2)}',
                      tooltip: 'Presupuesto estimado',
                    ),
                ],
                onTap: () => onEditProject(project.id),
              ),
            );
          },
        );
      },
    );
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
}
