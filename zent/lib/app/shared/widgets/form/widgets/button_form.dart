import 'package:flutter/material.dart';

class ButtonForm extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isPrimary;

  const ButtonForm({
    required this.texto,
    required this.onPressed,
    this.icon,
    this.isPrimary = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isPrimary ? theme.colorScheme.primary : theme.colorScheme.surface,
        foregroundColor: isPrimary
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSurface,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: !isPrimary
              ? BorderSide(color: theme.colorScheme.primary)
              : BorderSide.none,
        ),
        elevation: isPrimary ? 10 : 0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            texto,
            style: theme.textTheme.displayLarge?.copyWith(
              color: isPrimary
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.primary,
              fontSize: 24,
              fontWeight: FontWeight.w600,
              letterSpacing: 3.60,
            ),
          ),
          if (icon != null) const SizedBox(width: 8),
          if (icon != null)
            Icon(
              icon,
              color: isPrimary
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.primary,
            ),
        ],
      ),
    );
  }
}
