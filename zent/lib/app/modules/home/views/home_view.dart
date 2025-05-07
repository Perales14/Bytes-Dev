import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/main_layout.dart';
import '../controllers/home_controller.dart';
import '../widgets/sections/chart_widget_section.dart';
import '../widgets/sections/quick_actions_section.dart';
import '../widgets/sections/recent_projects_section.dart';
import '../widgets/sections/statistics_grid_section.dart';

/// Vista principal del dashboard
/// Implementa un diseño responsivo con adaptación a diferentes tamaños de pantalla
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Determina si estamos en pantalla estrecha para cambiar el layout
    final bool isNarrowScreen = MediaQuery.of(context).size.width < 600;
    final double spacing = 16.0;

    return MainLayout(
      pageTitle: 'Inicio',
      textController: controller.textController,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeBanner(),

            // Grid responsivo principal
            Expanded(
              child: isNarrowScreen
                  ? _buildSingleColumnLayout(spacing)
                  : _buildTwoColumnsLayout(spacing),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye el banner de bienvenida con el nombre del usuario
  Widget _buildWelcomeBanner() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() => Text(
                'Bienvenido, ${controller.userName}!',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )),
          IconButton(
            icon: const Icon(
              Icons.refresh,
              size: 18,
              color: Color.fromARGB(255, 49, 63, 85),
            ),
            onPressed: () => controller.refreshData(),
            tooltip: 'Refrescar datos',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
          ),
        ],
      ),
    );
  }

  /// Layout para pantallas estrechas - 1 columna con scroll
  Widget _buildSingleColumnLayout(double spacing) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Cambiamos el orden en la vista de columna única
          const QuickActionsSection(),
          SizedBox(height: spacing),
          _buildChartSectionWithCard(),
          SizedBox(height: spacing),
          StatisticsGridSection(controller: controller),
          SizedBox(height: spacing),
          SizedBox(
            height: 300, // Altura fija para la sección de proyectos
            child: _buildRecentProjectsWithCard(),
          ),
        ],
      ),
    );
  }

  /// Layout para pantallas normales - Grid 2x2
  Widget _buildTwoColumnsLayout(double spacing) {
    return Column(
      children: [
        // Primera fila - Intercambiamos las posiciones
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Cuadrante superior izquierdo: ACCIONES RÁPIDAS (antes era la gráfica)
              const Expanded(child: QuickActionsSection()),
              SizedBox(width: spacing),
              // Cuadrante superior derecho: GRÁFICA (antes eran las acciones rápidas)
              Expanded(child: _buildChartSectionWithCard()),
            ],
          ),
        ),
        SizedBox(height: spacing),
        // Segunda fila (se mantiene igual)
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Cuadrante inferior izquierdo: Proyectos recientes
              Expanded(child: _buildRecentProjectsWithCard()),
              SizedBox(width: spacing),
              // Cuadrante inferior derecho: Estadísticas
              Expanded(child: StatisticsGridSection(controller: controller)),
            ],
          ),
        ),
      ],
    );
  }

  /// Widget de gráfica circular con tarjeta contenedora
  Widget _buildChartSectionWithCard() {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ChartWidgetSection(controller: controller),
    );
  }

  /// Widget de proyectos recientes
  Widget _buildRecentProjectsWithCard() {
    return RecentProjectsSection(controller: controller);
  }
}
