import 'package:flutter/material.dart';
import '../models/project_card_data.dart';

/// Widget que representa una tarjeta de proyecto con altura fija.
class ProjectCard extends StatelessWidget {
  static const double borderRadius = 16.0;
  static const double contentPadding = 16.0;
  static const double statusRadius = 8.0;

  /// Datos del proyecto a mostrar
  final ProjectCardData data;

  /// Color de fondo de la tarjeta (opcional)
  final Color? backgroundColor;

  const ProjectCard({
    super.key,
    required this.data,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin:
          EdgeInsets.zero, // Eliminamos margen para controlar la altura exacta
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(
          color: theme.dividerColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      color: backgroundColor ?? theme.cardTheme.color,
      elevation: 4,
      child: InkWell(
        onTap: data.onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(contentPadding),
          child: Column(
            mainAxisSize:
                MainAxisSize.max, // Fuerza a llenar el espacio disponible
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Título y estado (altura fija)
              SizedBox(
                height: 24,
                child: _buildHeader(context, theme),
              ),

              const SizedBox(height: 8),

              // Descripción breve (altura fija)
              SizedBox(
                height: 20,
                child: Text(
                  data.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(height: 8),
              const Divider(height: 1),
              const SizedBox(height: 8),

              // Contenido principal con altura fija
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Layout diferente según ancho disponible
                    final isNarrow = constraints.maxWidth < 300;

                    if (isNarrow) {
                      return _buildCompactLayout(theme);
                    } else {
                      return _buildTwoColumnLayout(theme);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Construye el encabezado con título y estado
  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            data.name,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: data.statusColor ?? theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(statusRadius),
          ),
          child: Text(
            data.status,
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // Layout compacto para espacios reducidos
  Widget _buildCompactLayout(ThemeData theme) {
    return ListView(
      padding: EdgeInsets.zero, // Sin padding para aprovechar espacio
      children: [
        _buildInfoRow(theme, Icons.business, 'Cliente:', data.clientName),
        const SizedBox(height: 8),
        _buildInfoRow(theme, Icons.person, 'Responsable:', data.managerName),
        const SizedBox(height: 8),
        if (data.metrics != null && data.metrics!.isNotEmpty)
          ...data.metrics!.take(2).map((metric) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: _buildMetricRow(theme, metric),
              )),
      ],
    );
  }

  // Layout en dos columnas para espacios más amplios
  Widget _buildTwoColumnLayout(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Columna izquierda
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(theme, Icons.business, 'Cliente:', data.clientName),
              const SizedBox(height: 8),
              _buildInfoRow(
                  theme, Icons.person, 'Responsable:', data.managerName),
            ],
          ),
        ),

        // Separador
        Container(
          height: double.infinity,
          width: 1,
          color: theme.dividerColor.withOpacity(0.3),
          margin: const EdgeInsets.symmetric(horizontal: 8),
        ),

        // Columna derecha
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (data.metrics != null && data.metrics!.isNotEmpty)
                ...data.metrics!.take(3).map((metric) {
                  final isLast = data.metrics!.indexOf(metric) ==
                          data.metrics!.length - 1 ||
                      data.metrics!.indexOf(metric) == 2;
                  return Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 8.0),
                    child: _buildMetricRow(theme, metric),
                  );
                }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
      ThemeData theme, IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 14, color: theme.colorScheme.primary),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(metric.icon, size: 14, color: theme.colorScheme.secondary),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                metric.label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              Text(
                metric.value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
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
}
