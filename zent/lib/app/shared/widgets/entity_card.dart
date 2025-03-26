import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EntityCardData {
  final String title;
  final String description;
  final String badgeText;
  final List<EntityCardCounter>? counters;
  final VoidCallback? onTap;

  EntityCardData({
    required this.title,
    required this.description,
    required this.badgeText,
    this.counters,
    this.onTap,
  });
}

class EntityCardCounter {
  final IconData icon;
  final String count;

  EntityCardCounter({
    required this.icon,
    required this.count,
  });
}

class EntityCard extends StatelessWidget {
  final EntityCardData data;
  final Color? badgeColor;
  final Color? cardColor;

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
      borderRadius: BorderRadius.circular(16),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 280,
          maxWidth: 280,
          minHeight: 120,
          maxHeight: 120,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: ShapeDecoration(
            color: cardColor ?? theme.cardTheme.color,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: theme.dividerColor.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(16),
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

  Widget _buildBadge(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: ShapeDecoration(
          color: badgeColor ?? theme.colorScheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          data.badgeText,
          style: theme.textTheme.labelSmall?.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 8), // Añadido padding a la derecha
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

  Widget _buildCounters(ThemeData theme) {
    return Row(
      children: [
        Row(
          children: data.counters!.map((counter) {
            return Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Icon(counter.icon,
                      size: 16, color: theme.colorScheme.onSurface),
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
