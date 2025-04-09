import 'package:flutter/material.dart';
import 'project_card.dart';

/// Widget que representa una tarjeta para agregar nuevos proyectos.
/// Mantiene las mismas dimensiones que ProjectCard para consistencia visual.
class AddProjectCard extends StatelessWidget {
  /// Acción a ejecutar cuando se pulsa la tarjeta
  final VoidCallback onTap;

  /// Color de fondo de la tarjeta (opcional)
  final Color? backgroundColor;

  /// Color del icono y texto (opcional)
  final Color? foregroundColor;

  const AddProjectCard({
    super.key,
    required this.onTap,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = backgroundColor ?? theme.cardTheme.color;
    final iconColor = foregroundColor ?? theme.colorScheme.onSurface;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.clamp(
          ProjectCard.cardMinWidth,
          ProjectCard.cardMaxWidth,
        );

        return Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ProjectCard.borderRadius),
            side: BorderSide(
              color: theme.dividerColor.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          color: cardColor,
          child: SizedBox(
            width: width,
            height: ProjectCard.cardHeight,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(ProjectCard.borderRadius),
              child: Padding(
                padding: const EdgeInsets.all(ProjectCard.contentPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_rounded,
                      size: 64,
                      color: iconColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nuevo Proyecto',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: iconColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
