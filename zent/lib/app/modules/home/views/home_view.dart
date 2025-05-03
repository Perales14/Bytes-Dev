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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Reducido el padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bienvenido, ${controller.userName}!',
                style: const TextStyle(
                  fontSize: 20, // Reducido de 24 a 20
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16), // Reducido de 24 a 16
              _buildStatisticsSection(),
              const SizedBox(height: 16), // Reducido de 24 a 16
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
            fontSize: 16, // Reducido de 20 a 16
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8), // Reducido de 16 a 8
        Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Columna izquierda: Cards de estadísticas
                  Expanded(
                    flex: 3,
                    child: Wrap(
                      spacing: 8, // Reducido de 16 a 8
                      runSpacing: 8, // Reducido de 16 a 8
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
                  const SizedBox(width: 16), // Reducido de 24 a 16
                  // Columna derecha: Gráfica circular
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 220, // Reducido de 280 a 220
                      padding: const EdgeInsets.all(12), // Reducido de 16 a 12
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8), // Reducido de 12 a 8
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1, // Reducido de 2 a 1
                            blurRadius: 3, // Reducido de 4 a 3
                            offset: const Offset(0, 1), // Reducido de 0,2 a 0,1
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
              ),
              const SizedBox(height: 12), // Reducido de 20 a 12
              // Comentado la sección antigua de accesos rápidos
              /* ... existing code ... */
            ],
          );
        }),
      ],
    );
  }

  Widget _buildRecentProjectsSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Panel izquierdo: Lista de proyectos recientes
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Proyectos Recientes',
                    style: TextStyle(
                      fontSize: 16, // Reducido de 20 a 16
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 18), // Reducido tamaño del icono
                    onPressed: () => controller.refreshData(),
                    tooltip: 'Refrescar datos',
                    padding: EdgeInsets.zero, // Quitar padding del botón
                    constraints: const BoxConstraints(
                      minWidth: 36, minHeight: 36), // Reducir el tamaño del botón
                  ),
                ],
              ),
              const SizedBox(height: 4), // Reducido de 8 a 4
              Obx(() {
                if (controller.isLoading.value) {
                  return const SizedBox(
                    height: 120, // Reducido de 150 a 120
                    child: Center(
                      child: SizedBox(
                        height: 20, width: 20, // Spinner más pequeño
                        child: CircularProgressIndicator(strokeWidth: 2), // Más delgado
                      ),
                    ),
                  );
                }
                
                if (controller.recentProjects.isEmpty) {
                  return SizedBox(
                    height: 120, // Reducido de 150 a 120
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.folder_off, size: 24, color: Colors.grey), // Reducido de 32 a 24
                          const SizedBox(height: 4), // Reducido de 8 a 4
                          const Text(
                            'No hay proyectos recientes',
                            style: TextStyle(
                              fontSize: 12, // Reducido de 14 a 12
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                
                return Container(
                  height: 120, // Reducido de 150 a 120
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 49, 63, 85),
                    borderRadius: BorderRadius.circular(8), // Reducido de 12 a 8
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1, // Reducido de 2 a 1
                        blurRadius: 3, // Reducido de 4 a 3
                        offset: const Offset(0, 1), // Reducido de 0,2 a 0,1
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    // Aquí permitimos scroll
                    shrinkWrap: true,
                    itemCount: controller.recentProjects.length,
                    itemBuilder: (context, index) {
                      return _CompactProjectCard(
                        project: controller.recentProjects[index],
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
        
        const SizedBox(width: 12), // Reducido de 20 a 12
        
        // Panel derecho: Cuadrícula de acciones rápidas 2x2
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Acciones Rápidas',
                style: TextStyle(
                  fontSize: 16, // Reducido de 20 a 16
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4), // Reducido de 8 a 4
              Container(
                height: 120, // Reducido de 150 a 120
                padding: const EdgeInsets.all(8), // Reducido de 12 a 8
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 45, 50, 78),
                  borderRadius: BorderRadius.circular(8), // Reducido de 12 a 8
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1, // Reducido de 2 a 1
                      blurRadius: 3, // Reducido de 4 a 3
                      offset: const Offset(0, 1), // Reducido de 0,2 a 0,1
                    ),
                  ],
                ),
                child: GridView.count(
                  //physics: const NeverScrollableScrollPhysics(), // Desactivamos scroll
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 4, // Reducido de 8 a 4
                  crossAxisSpacing: 4, // Reducido de 8 a 4
                  children: [
                    _ActionShortcut(
                      icon: Icons.person_add,
                      label: 'Nuevo\nEmpleado',
                      color: Colors.blue,
                      onTap: () {
                        Get.snackbar(
                          'Acción pendiente', 
                          'La función para añadir empleado será implementada próximamente',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                    ),
                    _ActionShortcut(
                      icon: Icons.people,
                      label: 'Nuevo\nCliente',
                      color: Colors.green,
                      onTap: () {
                        Get.snackbar(
                          'Acción pendiente', 
                          'La función para añadir cliente será implementada próximamente',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                    ),
                    _ActionShortcut(
                      icon: Icons.business,
                      label: 'Nuevo\nProveedor',
                      color: Colors.purple,
                      onTap: () {
                        Get.snackbar(
                          'Acción pendiente', 
                          'La función para añadir proveedor será implementada próximamente',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                    ),
                    _ActionShortcut(
                      icon: Icons.assignment,
                      label: 'Nuevo\nProyecto',
                      color: Colors.orange,
                      onTap: () {
                        Get.snackbar(
                          'Acción pendiente', 
                          'La función para añadir proyecto será implementada próximamente',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
      width: 160, // Reducido de 200 a 160
      padding: const EdgeInsets.all(8), // Reducido de 12 a 8
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8), // Reducido de 12 a 8
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
                    fontSize: 12, // Reducido de 14 a 12
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(icon, color: color, size: 16), // Reducido de 20 a 16
            ],
          ),
          const SizedBox(height: 4), // Reducido de 8 a 4
          Text(
            value,
            style: TextStyle(
              fontSize: 20, // Reducido de 24 a 20
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
            fontSize: 14, // Reducido de 16 a 14
            fontWeight: FontWeight.bold,
            color: Colors.black87
          ),
        ),
        const SizedBox(height: 8), // Reducido de 16 a 8
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 1, // Reducido de 2 a 1
                    centerSpaceRadius: 30, // Reducido de 40 a 30
                    sections: [
                      if (planning > 0)
                        PieChartSectionData(
                          color: Colors.orange,
                          value: planning.toDouble(),
                          title: '${(planning / total * 100).round()}%',
                          radius: 40, // Reducido de 50 a 40
                          titleStyle: const TextStyle(
                            fontSize: 12, // Reducido de 14 a 12
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      if (inProgress > 0)
                        PieChartSectionData(
                          color: Colors.green,
                          value: inProgress.toDouble(),
                          title: '${(inProgress / total * 100).round()}%',
                          radius: 40, // Reducido de 50 a 40
                          titleStyle: const TextStyle(
                            fontSize: 12, // Reducido de 14 a 12
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      if (delayed > 0)
                        PieChartSectionData(
                          color: Colors.red,
                          value: delayed.toDouble(),
                          title: '${(delayed / total * 100).round()}%',
                          radius: 40, // Reducido de 50 a 40
                          titleStyle: const TextStyle(
                            fontSize: 12, // Reducido de 14 a 12
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12), // Reducido de 24 a 12
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LegendItem(
                    color: Colors.orange,
                    label: 'Planificación',
                    value: planning,
                  ),
                  const SizedBox(height: 4), // Reducido de 8 a 4
                  _LegendItem(
                    color: Colors.green,
                    label: 'Ejecución',
                    value: inProgress,
                  ),
                  const SizedBox(height: 4), // Reducido de 8 a 4
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
          width: 12, // Reducido de 16 a 12
          height: 12, // Reducido de 16 a 12
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4), // Reducido de 8 a 4
        Text(
          '$label ($value)',
          style: const TextStyle(fontSize: 10), // Texto más pequeño
        ),
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

class _CompactProjectCard extends StatelessWidget {
  final ProjectModel project;

  const _CompactProjectCard({
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Determinar color según estado
    Color statusColor;
    IconData statusIcon;
    
    switch(project.stateId) {
      case 1: // Planificación
        statusColor = Colors.orange;
        statusIcon = Icons.pending_actions;
        break;
      case 2: // Ejecución
        statusColor = Colors.green;
        statusIcon = Icons.play_circle;
        break;
      case 3: // Terminado
        statusColor = Colors.blue;
        statusIcon = Icons.check_circle;
        break;
      default:
        // Verificar si está atrasado
        if (project.estimatedEndDate != null && 
            DateTime.now().isAfter(project.estimatedEndDate!) &&
            project.actualEndDate == null) {
          statusColor = Colors.red;
          statusIcon = Icons.warning;
        } else {
          statusColor = Colors.grey;
          statusIcon = Icons.help;
        }
    }
    
    // Formatear fecha compacta
    final dateFormat = DateFormat('dd/MM/yy');
    final startDate = project.startDate != null 
        ? dateFormat.format(project.startDate!)
        : 'N/D';
    
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), // Reducido de 12,4 a 8,2
      dense: true,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4), // Hacer el ListTile aún más compacto
      leading: CircleAvatar(
        radius: 14, // Reducido de 18 a 14
        backgroundColor: statusColor.withOpacity(0.2),
        child: Icon(statusIcon, size: 14, color: statusColor), // Reducido de 18 a 14
      ),
      title: Text(
        project.name,
        style: theme.textTheme.bodyMedium?.copyWith( // Cambiado de bodyLarge a bodyMedium
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        project.description ?? 'Sin descripción',
        style: theme.textTheme.bodySmall?.copyWith(
          color: Colors.white70,
          fontSize: 10, // Texto más pequeño
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            startDate,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white70,
              fontSize: 10, // Texto más pequeño
            ),
          ),
          if (project.estimatedBudget != null)
            Text(
              '\$${project.estimatedBudget!.toStringAsFixed(0)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white70,
                fontSize: 10, // Texto más pequeño
              ),
            ),
        ],
      ),
    );
  }
}

class _ActionShortcut extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionShortcut({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6), // Reducido de 8 a 6
      child: Container(
        padding: const EdgeInsets.all(4), // Reducido de 8 a 4
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6), // Reducido de 8 a 6
          border: Border.all(color: color.withOpacity(0.3), width: 0.5), // Borde más fino
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20), // Reducido de 24 a 20
            const SizedBox(height: 2), // Reducido de 4 a 2
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 9, // Reducido de 10 a 9
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
