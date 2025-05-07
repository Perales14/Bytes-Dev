import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/project_model.dart';

/// Modelo que representa el estado de un proyecto con sus atributos visuales
class ProjectStatus {
  final Color color;
  final IconData icon;
  final String text;

  const ProjectStatus({
    required this.color,
    required this.icon,
    required this.text,
  });
}

/// Widget para mostrar información resumida de un proyecto
/// en formato compacto para listas
class CompactProjectCard extends StatelessWidget {
  final ProjectModel project;

  const CompactProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ProjectStatus status = _getProjectStatus(project);
    final String startDate = _formatStartDate(project);

    return LayoutBuilder(builder: (context, constraints) {
      // Cálculo de tamaños adaptables al ancho disponible
      final double maxWidth = constraints.maxWidth;
      final double iconSize = (maxWidth * 0.038).clamp(14.0, 20.0);
      final double titleFontSize = (maxWidth * 0.033).clamp(12.0, 15.0);
      final double subtitleFontSize = (maxWidth * 0.025).clamp(10.0, 12.0);

      // Calculamos el padding horizontal proporcional al ancho disponible
      final double horizontalPadding = (maxWidth * 0.05).clamp(12.0, 20.0);

      return ListTile(
        contentPadding:
            EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 2),
        dense: true,
        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
        leading: CircleAvatar(
          radius: iconSize / 2 + 7,
          backgroundColor: status.color.withOpacity(0.2),
          child: Icon(status.icon, size: iconSize, color: status.color),
        ),
        title: Text(
          project.name,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: titleFontSize,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center, // Centrado horizontal
        ),
        subtitle: Text(
          project.description ?? 'Sin descripción',
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: subtitleFontSize,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center, // Centrado horizontal
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              startDate,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: subtitleFontSize,
              ),
            ),
            if (project.estimatedBudget != null)
              Text(
                '\$${project.estimatedBudget!.toStringAsFixed(0)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: subtitleFontSize,
                ),
              ),
          ],
        ),
      );
    });
  }

  /// Determina el estado del proyecto basado en sus propiedades
  ProjectStatus _getProjectStatus(ProjectModel project) {
    if (project.actualEndDate != null) {
      return const ProjectStatus(
        color: Colors.blue,
        icon: Icons.check_circle,
        text: 'Terminado',
      );
    } else if (project.estimatedEndDate != null &&
        DateTime.now().isAfter(project.estimatedEndDate!)) {
      return const ProjectStatus(
        color: Colors.red,
        icon: Icons.warning,
        text: 'Atrasado',
      );
    } else if (project.stateId == 2 || project.startDate != null) {
      return const ProjectStatus(
        color: Colors.green,
        icon: Icons.play_circle,
        text: 'En Ejecución',
      );
    } else {
      return const ProjectStatus(
        color: Colors.orange,
        icon: Icons.pending_actions,
        text: 'Planificación',
      );
    }
  }

  /// Formatea la fecha de inicio del proyecto para mostrarla
  String _formatStartDate(ProjectModel project) {
    final dateFormat = DateFormat('dd/MM/yy');
    return project.startDate != null
        ? dateFormat.format(project.startDate!)
        : 'N/D';
  }
}
