import 'package:flutter/material.dart';

/// Modelo de datos para las estadísticas del dashboard
class DashboardStat {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const DashboardStat(
      {required this.title,
      required this.value,
      required this.color,
      required this.icon});
}

/// Widget para mostrar tarjetas de estadísticas en el dashboard
/// Adaptable y con diseño consistente
class DashboardStatCard extends StatelessWidget {
  final DashboardStat stat;

  const DashboardStatCard({super.key, required this.stat});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: stat.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: stat.color.withOpacity(0.3), width: 1),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        final double maxHeight = constraints.maxHeight;
        final double maxWidth = constraints.maxWidth;

        // Proporciones relativas al tamaño del contenedor
        final double titleFontSize = maxWidth * 0.085;
        final double valueFontSize = maxWidth * 0.19;
        final double iconSize = maxHeight * 0.22;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    stat.title,
                    style: TextStyle(
                      fontSize: titleFontSize.clamp(10.0, 13.0),
                      color: stat.color,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(stat.icon, color: stat.color, size: iconSize),
              ],
            ),
            const Spacer(),
            Text(
              stat.value,
              style: TextStyle(
                fontSize: valueFontSize.clamp(18.0, 28.0),
                color: stat.color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      }),
    );
  }
}
