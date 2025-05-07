import 'package:flutter/material.dart';

/// Widget para botones de acción rápida en el tablero
/// Muestra un botón con icono y texto, centrado y adaptable
class ActionShortcut extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const ActionShortcut({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
          ),
          child: LayoutBuilder(builder: (context, constraints) {
            final double maxHeight = constraints.maxHeight;
            final double maxWidth = constraints.maxWidth;

            // Proporciones relativas al tamaño del contenedor
            final double iconSize = maxHeight * 0.35;
            final double fontSize = maxWidth * 0.11;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: color, size: iconSize),
                  SizedBox(height: maxHeight * 0.08),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: fontSize.clamp(10.0, 14.0),
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
