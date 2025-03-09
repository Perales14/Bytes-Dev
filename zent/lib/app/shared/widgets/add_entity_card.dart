import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddEntityCard extends StatelessWidget {
  /// Texto que se mostrará en la tarjeta
  final String labelText;

  /// Icono para mostrar (por defecto es un icono de agregar)
  final IconData icon;

  /// Acción a ejecutar al hacer tap
  final VoidCallback onTap;

  /// Color del fondo de la tarjeta (opcional)
  final Color? backgroundColor;

  /// Color del texto e icono (opcional)
  final Color? foregroundColor;

  const AddEntityCard({
    super.key,
    required this.labelText,
    this.icon = Icons.add_circle_outline,
    required this.onTap,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = backgroundColor ?? theme.cardTheme.color;
    final textIconColor = foregroundColor ?? theme.colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 240, // Ancho fijo en lugar de infinito
        height: 124,
        padding: const EdgeInsets.all(24),
        decoration: ShapeDecoration(
          color: cardColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: theme.dividerColor.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: textIconColor,
            ),
            const SizedBox(height: 8),
            Text(
              labelText,
              style: theme.textTheme.titleMedium?.copyWith(
                color: textIconColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
