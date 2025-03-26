import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Modelo para los datos de una tarjeta de entidad.
///
/// Contiene toda la información necesaria para mostrar una entidad
/// en forma de tarjeta, incluyendo título, descripción y contadores.
class EntityCardData {
  /// Título principal de la entidad
  final String title;

  /// Descripción o subtítulo de la entidad
  final String description;

  /// Texto para la etiqueta superior (badge)
  final String badgeText;

  /// Lista opcional de contadores a mostrar
  final List<EntityCardCounter>? counters;

  /// Acción a ejecutar cuando se pulsa la tarjeta
  final VoidCallback? onTap;

  /// Crea un modelo de datos para una tarjeta de entidad.
  ///
  /// Requiere [title], [description] y [badgeText].
  /// Los [counters] y [onTap] son opcionales.
  EntityCardData({
    required this.title,
    required this.description,
    required this.badgeText,
    this.counters,
    this.onTap,
  });
}

/// Modelo para los contadores mostrados en la tarjeta.
///
/// Representa un contador con un icono y un valor numérico o textual.
class EntityCardCounter {
  /// Icono asociado al contador
  final IconData icon;

  /// Valor del contador (como texto)
  final String count;

  /// Crea un modelo de contador para tarjetas de entidad.
  ///
  /// Requiere un [icon] y un valor [count].
  EntityCardCounter({
    required this.icon,
    required this.count,
  });
}

/// Widget que muestra una tarjeta para representar una entidad.
///
/// Presenta la información en un formato visualmente atractivo,
/// con área para título, descripción, etiqueta superior y contadores.
class EntityCard extends StatelessWidget {
  /// Constantes para dimensiones y estilos
  static const double borderRadius = 16.0;
  static const double cardWidth = 280.0;
  static const double cardHeight = 120.0;
  static const double contentPadding = 16.0;
  static const double badgeRadius = 8.0;

  /// Datos de la entidad a mostrar
  final EntityCardData data;

  /// Color personalizado para la etiqueta superior
  final Color? badgeColor;

  /// Color personalizado para el fondo de la tarjeta
  final Color? cardColor;

  /// Crea una tarjeta de entidad con la información proporcionada.
  ///
  /// Requiere [data] con la información de la entidad.
  /// Los colores [badgeColor] y [cardColor] son opcionales.
  const EntityCard({
    super.key,
    required this.data,
    this.badgeColor,
    this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: data.onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: cardWidth,
          maxWidth: cardWidth,
          minHeight: cardHeight,
          maxHeight: cardHeight,
        ),
        child: Container(
          padding: const EdgeInsets.all(contentPadding),
          decoration: ShapeDecoration(
            color: cardColor ?? theme.cardTheme.color,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: theme.dividerColor.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          // Usando Stack para posicionar los elementos con más precisión
          child: Stack(
            children: [
              // Contenido principal en la parte superior
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildBadge(theme),
                  const SizedBox(height: 12),
                  _buildContent(theme),
                ],
              ),

              // Contadores en la parte inferior derecha (condicional)
              if (data.counters != null && data.counters!.isNotEmpty)
                Positioned(
                  right: 10,
                  bottom: 0,
                  child: _buildCounters(theme),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye la etiqueta superior (badge) de la tarjeta
  Widget _buildBadge(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: ShapeDecoration(
          color: badgeColor ?? theme.colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(badgeRadius),
          ),
        ),
        child: Text(
          data.badgeText,
          style: theme.textTheme.labelSmall?.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  /// Construye el contenido principal (título y descripción)
  Widget _buildContent(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.title,
            style: theme.textTheme.headlineMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            data.description,
            style: theme.textTheme.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Construye los contadores en la parte inferior de la tarjeta
  Widget _buildCounters(ThemeData theme) {
    return Row(
      children: [
        Row(
          children: data.counters!.map((counter) {
            return Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Icon(
                    counter.icon,
                    size: 16,
                    color: theme.colorScheme.onSurface,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    counter.count,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
