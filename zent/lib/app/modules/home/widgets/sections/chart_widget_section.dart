import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../charts/projects_pie_chart.dart';

/// Sección que muestra un gráfico circular con la distribución de proyectos
class ChartWidgetSection extends StatelessWidget {
  final HomeController controller;

  const ChartWidgetSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return Padding(
        padding: const EdgeInsets.all(16),
        child: ProjectsPieChart(
          total: controller.totalProjects.value,
          planning: controller.planningProjects.value,
          inProgress: controller.inProgressProjects.value,
          delayed: controller.overdueProjects.value,
        ),
      );
    });
  }
}
