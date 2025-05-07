import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'legend_item.dart';

/// Widget que muestra la distribución de proyectos en un gráfico circular
/// Totalmente responsivo para adaptarse a cualquier tamaño de contenedor
class ProjectsPieChart extends StatelessWidget {
  final int total;
  final int planning;
  final int inProgress;
  final int delayed;

  const ProjectsPieChart({
    super.key,
    required this.total,
    required this.planning,
    required this.inProgress,
    required this.delayed,
  });

  @override
  Widget build(BuildContext context) {
    if (total == 0) {
      return _buildEmptyState();
    }

    return LayoutBuilder(builder: (context, constraints) {
      // Calculamos dimensiones proporcionales al contenedor
      final double maxHeight = constraints.maxHeight;
      final double maxWidth = constraints.maxWidth;

      // Detección de proporciones para elegir el layout adecuado
      final bool isWideScreen = maxWidth > maxHeight * 1.5;
      final bool isLowHeight = maxHeight < 200;
      final bool isMaximized = maxWidth > 600 && maxHeight > 300;

      // Elegimos layout según dimensiones
      if (isLowHeight && isWideScreen) {
        return _buildHorizontalLayout(maxWidth, maxHeight);
      } else if (isMaximized) {
        return _buildMaximizedLayout(maxWidth, maxHeight);
      } else {
        return _buildVerticalLayout(maxWidth, maxHeight);
      }
    });
  }

  /// Layout vertical (gráfica arriba, leyenda abajo) para casos normales
  Widget _buildVerticalLayout(double width, double height) {
    final centerRadius = (height * 0.24).clamp(20.0, 60.0);
    final sectionRadius = (height * 0.16).clamp(30.0, 70.0);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 4,
          child: Center(
            child: PieChart(
              PieChartData(
                sectionsSpace: 1.5,
                centerSpaceRadius: centerRadius,
                sections: _generateSections(sectionRadius),
                pieTouchData: PieTouchData(enabled: false),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: height * 0.03),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildLegendItems(10, false),
          ),
        ),
      ],
    );
  }

  /// Layout horizontal (gráfica a la izquierda, leyenda a la derecha) para poca altura
  Widget _buildHorizontalLayout(double width, double height) {
    final centerRadius = (height * 0.22).clamp(15.0, 40.0);
    final sectionRadius = (height * 0.28).clamp(25.0, 50.0);
    final double legendFontSize = (width * 0.015).clamp(9.0, 11.0);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Center(
            child: PieChart(
              PieChartData(
                sectionsSpace: 1.5,
                centerSpaceRadius: centerRadius,
                sections: _generateSections(sectionRadius),
                pieTouchData: PieTouchData(enabled: false),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _buildLegendItems(legendFontSize, false),
          ),
        ),
      ],
    );
  }

  /// Layout optimizado para pantallas maximizadas (vista ampliada)
  Widget _buildMaximizedLayout(double width, double height) {
    final centerRadius = (height * 0.25).clamp(60.0, 120.0);
    final sectionRadius = (height * 0.20).clamp(40.0, 100.0);
    final double legendFontSize = (width * 0.018).clamp(11.0, 14.0);

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Center(
            child: SizedBox(
              width: height * 0.85,
              height: height * 0.85,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: centerRadius,
                  sections: _generateSections(sectionRadius),
                  pieTouchData: PieTouchData(enabled: false),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildLegendItems(legendFontSize, true)
                .map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: item,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  /// Genera los items de leyenda según los datos disponibles
  List<Widget> _buildLegendItems(double fontSize, bool isVertical) {
    final List<Widget> items = [];

    if (planning > 0) {
      items.add(LegendItem(
        color: Colors.orange,
        label: 'Planificación',
        value: planning,
        fontSize: fontSize,
        isVertical: isVertical,
      ));
    }

    if (inProgress > 0) {
      items.add(LegendItem(
        color: Colors.green,
        label: 'Ejecución',
        value: inProgress,
        fontSize: fontSize,
        isVertical: isVertical,
      ));
    }

    if (delayed > 0) {
      items.add(LegendItem(
        color: Colors.red,
        label: 'Atrasados',
        value: delayed,
        fontSize: fontSize,
        isVertical: isVertical,
      ));
    }

    return items;
  }

  /// Estado cuando no hay proyectos para mostrar
  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'No hay proyectos para mostrar',
        style: TextStyle(
          fontSize: 14,
          fontStyle: FontStyle.italic,
          color: Colors.grey,
        ),
      ),
    );
  }

  /// Genera las secciones del gráfico circular en función de los datos de proyectos
  List<PieChartSectionData> _generateSections(double radius) {
    final List<PieChartSectionData> sections = [];

    if (planning > 0) {
      sections.add(_createSection(
        value: planning.toDouble(),
        total: total,
        color: Colors.orange,
        radius: radius,
      ));
    }

    if (inProgress > 0) {
      sections.add(_createSection(
        value: inProgress.toDouble(),
        total: total,
        color: Colors.green,
        radius: radius,
      ));
    }

    if (delayed > 0) {
      sections.add(_createSection(
        value: delayed.toDouble(),
        total: total,
        color: Colors.red,
        radius: radius,
      ));
    }

    return sections;
  }

  /// Crea una sección individual del gráfico circular
  PieChartSectionData _createSection({
    required double value,
    required int total,
    required Color color,
    required double radius,
  }) {
    final percentage = (value / total * 100).round();
    final double fontSize = (radius * 0.25).clamp(10.0, 16.0);

    return PieChartSectionData(
      color: color,
      value: value,
      title: '$percentage%',
      radius: radius,
      titleStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titlePositionPercentageOffset: 0.55,
    );
  }
}
