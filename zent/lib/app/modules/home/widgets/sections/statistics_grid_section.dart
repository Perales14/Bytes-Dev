import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../cards/dashboard_stat_card.dart';

/// Sección que muestra estadísticas del dashboard en una cuadrícula 2x2
/// Se adapta al espacio disponible y muestra datos de proyectos
class StatisticsGridSection extends StatelessWidget {
  final HomeController controller;

  const StatisticsGridSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final stats = _createStatsList();

      return LayoutBuilder(builder: (context, constraints) {
        // Cálculo preciso del espacio y proporciones
        final double availableHeight = constraints.maxHeight - 16;
        final double availableWidth = constraints.maxWidth - 16;

        final double itemHeight = (availableHeight / 2) - 6;
        final double itemWidth = (availableWidth / 2) - 6;

        final double aspectRatio = itemWidth / itemHeight;

        return Container(
          padding: const EdgeInsets.all(8),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: aspectRatio,
            ),
            itemCount: stats.length,
            itemBuilder: (context, index) =>
                DashboardStatCard(stat: stats[index]),
          ),
        );
      });
    });
  }

  /// Crea la lista de estadísticas a partir de los datos del controlador
  List<DashboardStat> _createStatsList() {
    return [
      DashboardStat(
        title: 'Total Proyectos',
        value: controller.totalProjects.value.toString(),
        color: Colors.blue,
        icon: Icons.folder,
      ),
      DashboardStat(
        title: 'En Planificación',
        value: controller.planningProjects.value.toString(),
        color: Colors.orange,
        icon: Icons.pending_actions,
      ),
      DashboardStat(
        title: 'En Ejecución',
        value: controller.inProgressProjects.value.toString(),
        color: Colors.green,
        icon: Icons.play_circle,
      ),
      DashboardStat(
        title: 'Atrasados',
        value: controller.overdueProjects.value.toString(),
        color: Colors.red,
        icon: Icons.warning,
      ),
    ];
  }
}
