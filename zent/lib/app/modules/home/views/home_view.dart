import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../../shared/widgets/main_layout.dart';
import '../../../data/models/project_model.dart';
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
              _buildStatisticsSection(),
              const SizedBox(height: 24),
              _buildRecentProjectsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Estadísticas Generales',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Columna izquierda: Cards de estadísticas
              Expanded(
                flex: 3,
                child: Wrap(
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
                      title: 'Atrasados',
                      value: controller.overdueProjects.value.toString(),
                      color: Colors.red,
                      icon: Icons.warning,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              // Columna derecha: Gráfica circular
              Expanded(
                flex: 2,
                child: Container(
                  height: 280,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _ProjectsPieChart(
                    total: controller.totalProjects.value,
                    planning: controller.planningProjects.value,
                    inProgress: controller.inProgressProjects.value,
                    delayed: controller.overdueProjects.value,
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildRecentProjectsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Proyectos Recientes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => controller.refreshData(),
              tooltip: 'Refrescar datos',
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: CircularProgressIndicator(),
              ),
            );
          }
          
          if (controller.recentProjects.isEmpty) {
            return Center(
              child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.folder_off, size: 48, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text(
                      'No hay proyectos recientes',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                    TextButton(
                      onPressed: () => controller.refreshData(), 
                      child: const Text('Intentar nuevamente'),
                    ),
                  ],
                ),
              ),
            );
          }
          
          return Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 49, 63, 85),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.recentProjects.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return _RecentProjectCard(
                  project: controller.recentProjects[index],
                );
              },
            ),
          );
        }),
      ],
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
      width: 200, // Reducido de 250 a 200
      padding: const EdgeInsets.all(12), // Reducido de 16 a 12
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14, // Reducido de 16 a 14
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(icon, color: color, size: 20), // Reducido el tamaño del icono
            ],
          ),
          const SizedBox(height: 8), // Reducido de 12 a 8
          Text(
            value,
            style: TextStyle(
              fontSize: 24, // Reducido de 32 a 24
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectsPieChart extends StatelessWidget {
  final int total;
  final int planning;
  final int inProgress;
  final int delayed;

  const _ProjectsPieChart({
    required this.total,
    required this.planning,
    required this.inProgress,
    required this.delayed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Distribución de Proyectos',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: [
                      if (planning > 0)
                        PieChartSectionData(
                          color: Colors.orange,
                          value: planning.toDouble(),
                          title: '${(planning / total * 100).round()}%',
                          radius: 50,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      if (inProgress > 0)
                        PieChartSectionData(
                          color: Colors.green,
                          value: inProgress.toDouble(),
                          title: '${(inProgress / total * 100).round()}%',
                          radius: 50,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      if (delayed > 0)
                        PieChartSectionData(
                          color: Colors.red,
                          value: delayed.toDouble(),
                          title: '${(delayed / total * 100).round()}%',
                          radius: 50,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LegendItem(
                    color: Colors.orange,
                    label: 'En Planificación',
                    value: planning,
                  ),
                  const SizedBox(height: 8),
                  _LegendItem(
                    color: Colors.green,
                    label: 'En Ejecución',
                    value: inProgress,
                  ),
                  const SizedBox(height: 8),
                  _LegendItem(
                    color: Colors.red,
                    label: 'Atrasados',
                    value: delayed,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final int value;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text('$label ($value)'),
      ],
    );
  }
}

class _RecentProjectCard extends StatelessWidget {
  final ProjectModel project;

  const _RecentProjectCard({
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Determinar color según estado
    Color statusColor;
    String statusText;
    IconData statusIcon;
    
    switch(project.stateId) {
      case 1: // Planificación
        statusColor = Colors.orange;
        statusText = 'En Planificación';
        statusIcon = Icons.pending_actions;
        break;
      case 2: // Ejecución
        statusColor = Colors.green;
        statusText = 'En Ejecución';
        statusIcon = Icons.play_circle;
        break;
      case 3: // Terminado
        statusColor = Colors.blue;
        statusText = 'Terminado';
        statusIcon = Icons.check_circle;
        break;
      default:
        // Verificar si está atrasado
        if (project.estimatedEndDate != null && 
            DateTime.now().isAfter(project.estimatedEndDate!) &&
            project.actualEndDate == null) {
          statusColor = Colors.red;
          statusText = 'Atrasado';
          statusIcon = Icons.warning;
        } else {
          statusColor = Colors.grey;
          statusText = 'Desconocido';
          statusIcon = Icons.help;
        }
    }
    
    // Formatear fecha
    final dateFormat = DateFormat('dd/MM/yyyy');
    final startDate = project.startDate != null 
        ? dateFormat.format(project.startDate!)
        : 'No definida';
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    project.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 16, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              project.description ?? 'Sin descripción',
              style: theme.textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      'Inicio: $startDate',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                if (project.estimatedBudget != null)
                  Row(
                    children: [
                      const Icon(Icons.attach_money, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        'Presupuesto: \$${project.estimatedBudget?.toStringAsFixed(2)}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
