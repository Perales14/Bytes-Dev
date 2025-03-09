import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EntityCardWidget<T> extends GetView {
  /// The entity data to display
  final T entity;

  /// Function to extract badge text from entity
  final String Function(T entity) badgeTextBuilder;

  /// Function to extract title text from entity
  final String Function(T entity) titleBuilder;

  /// Function to extract description text from entity
  final String Function(T entity) descriptionBuilder;

  /// Left counter label and value
  final String leftCounterLabel;
  final int leftCounterValue;

  /// Right counter label and value
  final String rightCounterLabel;
  final int rightCounterValue;

  /// Optional tap handler
  final Function()? onTap;

  /// Optional custom badge color (uses theme.primaryColor by default)
  final Color? badgeColor;

  /// Card width (null for auto)
  final double? width;

  const EntityCardWidget({
    super.key,
    required this.entity,
    required this.badgeTextBuilder,
    required this.titleBuilder,
    required this.descriptionBuilder,
    this.leftCounterLabel = '',
    this.leftCounterValue = 0,
    this.rightCounterLabel = '',
    this.rightCounterValue = 0,
    this.onTap,
    this.badgeColor,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: width ?? 278.67,
      constraints: const BoxConstraints(minHeight: 140),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: theme.dividerColor.withOpacity(0.2),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        color: theme.cardColor,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge
                _buildBadge(theme),

                const SizedBox(height: 8),

                // Title and description
                _buildTitleAndDescription(theme),

                const SizedBox(height: 8),

                // Stats counters
                _buildCounters(theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: ShapeDecoration(
        color: badgeColor ?? theme.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        badgeTextBuilder(entity),
        style: TextStyle(
          color: theme.colorScheme.onPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontFamily: 'Montserrat',
        ),
      ),
    );
  }

  Widget _buildTitleAndDescription(ThemeData theme) {
    return SizedBox(
      width: 230.67,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleBuilder(entity),
            style: TextStyle(
              color: theme.textTheme.titleMedium?.color,
              fontSize: 16,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              height: 1.25,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 4),
          Text(
            descriptionBuilder(entity),
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
              fontSize: 12,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w400,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildCounters(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 18,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildCounter(
              theme, Icons.folder_outlined, leftCounterValue.toString()),
          const SizedBox(width: 16),
          _buildCounter(
              theme, Icons.task_alt_outlined, rightCounterValue.toString()),
        ],
      ),
    );
  }

  Widget _buildCounter(ThemeData theme, IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: theme.iconTheme.color),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            color: theme.textTheme.bodyMedium?.color,
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
