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
    // Determinar si estamos en pantalla estrecha (para cambiar a 1 columna)
    final isNarrowScreen = MediaQuery.of(context).size.width < 600;
    final spacing = 12.0; // Espaciado estándar entre widgets

    return MainLayout(
      pageTitle: 'Inicio',
      textController: controller.textController,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Saludo inicial
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text(
                'Bienvenido, ${controller.userName}!',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
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

  // Layout para pantallas estrechas - 1 columna con scroll
  Widget _buildSingleColumnLayout(double spacing) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildChartWidget(),
          SizedBox(height: spacing),
          _buildQuickActionsGrid(),
          SizedBox(height: spacing),
          _buildStatisticsGrid(),
          SizedBox(height: spacing),
          _buildRecentProjectsPanel(),
        ],
      ),
    );
  }

  // Layout para pantallas normales - Grid 2x2
  Widget _buildTwoColumnsLayout(double spacing) {
    return Column(
      children: [
        // Primera fila
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Cuadrante superior derecho: Acciones rápidas
              Expanded(child: _buildQuickActionsGrid()),
              // Cuadrante superior izquierdo: Gráfica
              Expanded(child: _buildChartWidget()),
              SizedBox(width: spacing),
              ///
              // Cuadrante superior derecho: Acciones rápidas
              //Expanded(child: _buildQuickActionsGrid()),
              ///
            ],
          ),
        ),
        SizedBox(height: spacing),
        // Segunda fila
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Cuadrante inferior izquierdo: Proyectos recientes
              Expanded(child: _buildRecentProjectsPanel()),
              SizedBox(width: spacing),
              // Cuadrante inferior derecho: Estadísticas
              Expanded(child: _buildStatisticsGrid()),
            ],
          ),
        ),
      ],
    );
  }

  // Cuadrante 1: Grid de tarjetas de estadísticas (3 columnas max)
  Widget _buildStatisticsGrid() {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final List<DashboardStat> stats = [
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

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 150, // Máximo 3 columnas (basado en tamaño)
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.5,
          ),
          itemCount: stats.length,
          itemBuilder: (context, index) => _DashboardCard(stat: stats[index]),
        );
      }),
    );
  }

  // Cuadrante 2: Widget de gráfica circular
  Widget _buildChartWidget() {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return Padding(
          padding: const EdgeInsets.all(12),
          child: _ProjectsPieChart(
            total: controller.totalProjects.value,
            planning: controller.planningProjects.value,
            inProgress: controller.inProgressProjects.value,
            delayed: controller.overdueProjects.value,
          ),
        );
      }),
    );
  }

  // Cuadrante 3: Panel de proyectos recientes
  Widget _buildRecentProjectsPanel() {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Barra superior con título y botón de refrescar
          Container(
            color: const Color.fromARGB(255, 49, 63, 85),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Proyectos Recientes',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, size: 16, color: Colors.white),
                  onPressed: () => controller.refreshData(),
                  tooltip: 'Refrescar datos',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 30, minHeight: 30),
                ),
              ],
            ),
          ),
          
          // Contenido principal - lista de proyectos
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: SizedBox(
                    height: 20, width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }
              
              if (controller.recentProjects.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.folder_off, size: 24, color: Colors.grey),
                      SizedBox(height: 4),
                      Text(
                        'No hay proyectos recientes',
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }
              
              // Mostrar lista de proyectos más recientes (limitados a 5)
              final projects = controller.recentProjects.take(5).toList();
              return ListView.separated(
                itemCount: projects.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) => _CompactProjectCard(
                  project: projects[index],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // Cuadrante 4: Grid de acciones rápidas (2 columnas max)
  Widget _buildQuickActionsGrid() {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: GridView.count(
          shrinkWrap: true,
          //physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4, // Siempre 2 columnas
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: [
            _ActionShortcut(
              icon: Icons.person_add,
              label: 'Nuevo Empleado',
              color: Colors.blue,
              onTap: () => Get.snackbar(
                'Acción pendiente', 
                'Función para añadir empleado en desarrollo',
                snackPosition: SnackPosition.BOTTOM,
              ),
            ),
            _ActionShortcut(
              icon: Icons.people,
              label: 'Nuevo Cliente',
              color: Colors.green,
              onTap: () => Get.snackbar(
                'Acción pendiente', 
                'Función para añadir cliente en desarrollo',
                snackPosition: SnackPosition.BOTTOM,
              ),
            ),
            _ActionShortcut(
              icon: Icons.business,
              label: 'Nuevo Proveedor',
              color: Colors.purple,
              onTap: () => Get.snackbar(
                'Acción pendiente', 
                'Función para añadir proveedor en desarrollo',
                snackPosition: SnackPosition.BOTTOM,
              ),
            ),
            _ActionShortcut(
              icon: Icons.assignment,
              label: 'Nuevo Proyecto',
              color: Colors.orange,
              onTap: () => Get.snackbar(
                'Acción pendiente', 
                'Función para añadir proyecto en desarrollo',
                snackPosition: SnackPosition.BOTTOM,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Clase para encapsular los datos de estadísticas
class DashboardStat {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  DashboardStat({
    required this.title, 
    required this.value, 
    required this.color, 
    required this.icon
  });
}

// Widget de tarjeta para estadísticas
class _DashboardCard extends StatelessWidget {
  final DashboardStat stat;

  const _DashboardCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: stat.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: stat.color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  stat.title,
                  style: TextStyle(
                    fontSize: 12,
                    color: stat.color,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(stat.icon, color: stat.color, size: 16),
            ],
          ),
          const Spacer(),
          Text(
            stat.value,
            style: TextStyle(
              fontSize: 20,
              color: stat.color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// Widget de gráfica circular
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
    // Solo mostrar la gráfica si hay datos
    if (total == 0) {
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

    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sectionsSpace: 1,
              centerSpaceRadius: 30,
              sections: _generateSections(),
              pieTouchData: PieTouchData(enabled: false),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (planning > 0) 
              _LegendItem(color: Colors.orange, label: 'Planificación', value: planning),
            if (inProgress > 0) 
              _LegendItem(color: Colors.green, label: 'Ejecución', value: inProgress),
            if (delayed > 0) 
              _LegendItem(color: Colors.red, label: 'Atrasados', value: delayed),
          ],
        ),
      ],
    );
  }

  List<PieChartSectionData> _generateSections() {
    final List<PieChartSectionData> sections = [];
    
    if (planning > 0) {
      sections.add(PieChartSectionData(
        color: Colors.orange,
        value: planning.toDouble(),
        title: '${(planning / total * 100).round()}%',
        radius: 40,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));
    }
    
    if (inProgress > 0) {
      sections.add(PieChartSectionData(
        color: Colors.green,
        value: inProgress.toDouble(),
        title: '${(inProgress / total * 100).round()}%',
        radius: 40,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));
    }
    
    if (delayed > 0) {
      sections.add(PieChartSectionData(
        color: Colors.red,
        value: delayed.toDouble(),
        title: '${(delayed / total * 100).round()}%',
        radius: 40,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));
    }
    
    return sections;
  }
}

// Widget para elementos de leyenda
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
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$label ($value)',
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}

// Widget para proyectos en lista compacta
class _CompactProjectCard extends StatelessWidget {
  final ProjectModel project;

  const _CompactProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Determinar color según estado
    final ProjectStatus status = _getProjectStatus(project);
    
    // Formatear fecha compacta
    final dateFormat = DateFormat('dd/MM/yy');
    final startDate = project.startDate != null 
        ? dateFormat.format(project.startDate!)
        : 'N/D';
    
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      dense: true,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      leading: CircleAvatar(
        radius: 14,
        backgroundColor: status.color.withOpacity(0.2),
        child: Icon(status.icon, size: 14, color: status.color),
      ),
      title: Text(
        project.name,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        project.description ?? 'Sin descripción',
        style: theme.textTheme.bodySmall?.copyWith(
          fontSize: 10,
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
              fontSize: 10,
            ),
          ),
          if (project.estimatedBudget != null)
            Text(
              '\$${project.estimatedBudget!.toStringAsFixed(0)}',
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 10,
              ),
            ),
        ],
      ),
    );
  }

  // Método para determinar estado del proyecto
  ProjectStatus _getProjectStatus(ProjectModel project) {
    if (project.actualEndDate != null) {
      return ProjectStatus(
        color: Colors.blue,
        icon: Icons.check_circle,
        text: 'Terminado',
      );
    } else if (project.estimatedEndDate != null && 
              DateTime.now().isAfter(project.estimatedEndDate!)) {
      return ProjectStatus(
        color: Colors.red,
        icon: Icons.warning,
        text: 'Atrasado',
      );
    } else if (project.stateId == 2 || project.startDate != null) {
      return ProjectStatus(
        color: Colors.green,
        icon: Icons.play_circle,
        text: 'En Ejecución',
      );
    } else {
      return ProjectStatus(
        color: Colors.orange,
        icon: Icons.pending_actions,
        text: 'Planificación',
      );
    }
  }
}

// Clase para manejar estado del proyecto
class ProjectStatus {
  final Color color;
  final IconData icon;
  final String text;
  
  ProjectStatus({
    required this.color,
    required this.icon,
    required this.text,
  });
}

// Widget para acciones rápidas
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color.withOpacity(0.3), width: 0.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
