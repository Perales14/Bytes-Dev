import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/main_layout.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      pageTitle: 'Inicio',
      textController: controller.textController,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bienvenido, ${controller.userName}!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _DashboardCard(
                      title: 'Total Proyectos',
                      value: controller.totalProjects.value.toString(),
                      color: Colors.blue,
                      icon: Icons.folder,
                    ),
                    _DashboardCard(
                      title: 'En Planificación',
                      value: controller.planningProjects.value.toString(),
                      color: Colors.orange,
                      icon: Icons.pending_actions,
                    ),
                    _DashboardCard(
                      title: 'En Ejecución',
                      value: controller.inProgressProjects.value.toString(),
                      color: Colors.green,
                      icon: Icons.play_circle,
                    ),
                    _DashboardCard(
                      title: 'Proyectos Atrasados',
                      value: controller.overdueProjects.value.toString(),
                      color: Colors.red,
                      icon: Icons.warning,
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _DashboardCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(icon, color: color),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
