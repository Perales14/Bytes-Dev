import 'package:flutter/material.dart';

/// Widget para mostrar un ítem de leyenda para gráficas
/// Incluye un punto de color, etiqueta y valor numérico
/// Soporta disposición horizontal o vertical
class LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final int value;
  final double fontSize;
  final bool isVertical;

  const LegendItem({
    super.key,
    required this.color,
    required this.label,
    required this.value,
    this.fontSize = 10,
    this.isVertical = false,
  });

  @override
  Widget build(BuildContext context) {
    // Calculamos el tamaño del círculo de color proporcionalmente al tamaño del texto
    final double circleSize = fontSize;

    // Layout vertical u horizontal según el parámetro
    if (isVertical) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: circleSize * 0.6),
          Text(
            '$label ($value)',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    } else {
      // Layout horizontal (por defecto)
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: circleSize * 0.4),
          Text(
            '$label ($value)',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }
  }
}
