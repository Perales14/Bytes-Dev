import 'package:flutter/material.dart';
import '../../models/project_card_data.dart';

class ProjectCard extends StatelessWidget {
  static const double borderRadius = 16.0;
  static const double cardMinWidth = 280.0;
  static const double cardMaxWidth = 420.0;
  static const double cardHeight = 285.0;
  static const double contentPadding = 30.0;
  static const double statusRadius = 8.0;

  final ProjectCardData data;
  final Color? backgroundColor;

  const ProjectCard({
    super.key,
    required this.data,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calcular el ancho adaptativo
        final width = constraints.maxWidth.clamp(cardMinWidth, cardMaxWidth);

        return Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(
              color: theme.dividerColor.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          color: backgroundColor ?? theme.cardTheme.color,
          child: SizedBox(
            width: width,
            height: cardHeight,
            child: InkWell(
              onTap: data.onTap,
              borderRadius: BorderRadius.circular(borderRadius),
              child: Padding(
                padding: const EdgeInsets.all(contentPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            data.name,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                data.statusColor ?? theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(statusRadius),
                          ),
                          child: Text(
                            data.status,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    Text(
                      data.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 24),

                    // Información del proyecto
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Columna izquierda
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 12),
                                  _buildInfoRow(
                                    theme,
                                    Icons.business,
                                    'Cliente:',
                                    data.clientName,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildInfoRow(
                                    theme,
                                    Icons.person,
                                    'Responsable:',
                                    data.managerName,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Separador vertical
                          Container(
                            height: double.infinity,
                            width: 1,
                            color: theme.dividerColor.withOpacity(0.2),
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          // Columna derecha (métricas)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 12),
                                  if (data.metrics != null)
                                    ...data.metrics!.map((metric) => Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 12),
                                          child: _buildMetricRow(theme, metric),
                                        )),
                                ],
                              ),
                            ),
                          ),
                        ],
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

  Widget _buildInfoRow(
      ThemeData theme, IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18, // Incrementado de 16 a 18
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 10), // Incrementado de 8 a 10
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                  fontWeight: FontWeight
                      .w500, // Medio en negrita para mejor legibilidad
                ),
              ),
              const SizedBox(height: 3), // Incrementado ligeramente
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 14, // Especificamos tamaño para consistencia
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricRow(ThemeData theme, ProjectMetric metric) {
    return Tooltip(
      message: metric.tooltip ?? '',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            metric.icon,
            size: 18, // Incrementado de 16 a 18
            color: theme.colorScheme.secondary,
          ),
          const SizedBox(width: 10), // Incrementado de 8 a 10
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  metric.label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    fontWeight: FontWeight
                        .w500, // Medio en negrita para mejor legibilidad
                  ),
                ),
                const SizedBox(height: 3), // Incrementado ligeramente
                Text(
                  metric.value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14, // Especificamos tamaño para consistencia
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
