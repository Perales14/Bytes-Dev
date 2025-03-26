import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Tarjeta para agregar nuevas entidades con un botón de acción.
///
/// Este widget presenta una tarjeta con un icono central que actúa como
/// botón para agregar nuevos elementos a la aplicación.
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

  /// Si se debe mostrar el texto debajo del icono
  final bool showText;

  /// Radio del borde de la tarjeta
  static const double borderRadius = 16.0;

  /// Dimensiones de la tarjeta
  static const double cardWidth = 280.0;
  static const double cardHeight = 120.0;

  /// Crea una nueva tarjeta para agregar entidades.
  ///
  /// Requiere [labelText] y [onTap]. El [icon], [backgroundColor],
  /// [foregroundColor] y [showText] son opcionales.
  const AddEntityCard({
    super.key,
    required this.labelText,
    this.icon = Icons.add_rounded,
    required this.onTap,
    this.backgroundColor,
    this.foregroundColor,
    this.showText = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = backgroundColor ?? theme.cardTheme.color;
    final textIconColor = foregroundColor ?? theme.colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: cardWidth,
          maxWidth: cardWidth,
          minHeight: cardHeight,
          maxHeight: cardHeight,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: ShapeDecoration(
            color: cardColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: theme.dividerColor.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 64,
                color: textIconColor,
              ),
              if (showText) ...[
                const SizedBox(height: 8),
                Text(
                  labelText,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: textIconColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
