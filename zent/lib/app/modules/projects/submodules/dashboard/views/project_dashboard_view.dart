import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../data/services/active_project_service.dart';
import '../controllers/project_dashboard_controller.dart';
import '../../../../../../app/data/models/project_model.dart';
import '../../../../../../app/shared/widgets/main_layout.dart';

/// Vista para el dashboard de un proyecto específico
class ProjectDashboardView extends GetView<ProjectDashboardController> {
  const ProjectDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el proyecto del controlador
    return Obx(() {
      // Si estamos cargando o hay error
      if (controller.isLoading.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.hasError.value) {
        return _buildErrorState(controller.errorMessage.value);
      }

      // Si no tenemos proyecto
      if (controller.project == null) {
        return _buildErrorState('No se ha seleccionado un proyecto');
      }

      // Si todo está bien, mostramos el dashboard
      return _buildDashboardContent(context, controller.project!);
    });
  }

  /// Construye el contenido principal del dashboard
  Widget _buildDashboardContent(BuildContext context, ProjectModel project) {
    return MainLayout(
      pageTitle: 'Dashboard: ${project.name}',
      textController:
          TextEditingController(), // Controlador vacío ya que no se usa búsqueda aquí
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Indicadores de estado
              _buildStatusIndicators(project),
              const SizedBox(height: 24),

              // Tarjetas de métricas principales
              _buildMetricsCards(),
              const SizedBox(height: 24),

              // Gráfica de avance (placeholder)
              _buildProgressChart(),
              const SizedBox(height: 24),

              // Información adicional
              _buildAdditionalInfo(project),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye los indicadores de estado del proyecto
  Widget _buildStatusIndicators(ProjectModel project) {
    return Row(
      children: [
        Expanded(
          child: _buildIndicatorCard(
            title: 'Presupuesto',
            value: '\$${project.estimatedBudget?.toStringAsFixed(2) ?? "0.00"}',
            icon: Icons.monetization_on_outlined,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildIndicatorCard(
            title: 'Días restantes',
            value: _calcularDiasRestantes(project),
            icon: Icons.calendar_today,
            color: _getDaysLeftColor(project),
          ),
        ),
      ],
    );
  }

  /// Construye las tarjetas con métricas principales
  Widget _buildMetricsCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Métricas', style: Get.textTheme.titleMedium),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'Actividades',
                value: 'Por implementar',
                icon: Icons.task_alt,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMetricCard(
                title: 'Documentos Pendientes',
                value: 'Por implementar',
                icon: Icons.description,
                color: Colors.amber,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Construye una gráfica de avance (placeholder)
  Widget _buildProgressChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Avance del Proyecto', style: Get.textTheme.titleMedium),
        const SizedBox(height: 16),
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Próximamente',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: 200,
                height: 16,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[300],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 100, // 50% de avance como ejemplo
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Estado: En desarrollo',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Construye información adicional del proyecto
  Widget _buildAdditionalInfo(ProjectModel project) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Información Adicional', style: Get.textTheme.titleMedium),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildInfoRow(
                    'Inicio del proyecto', _formatDate(project.startDate)),
                const Divider(),
                _buildInfoRow('Fecha estimada de finalización',
                    _formatDate(project.estimatedEndDate)),
                const Divider(),
                _buildInfoRow('Cliente', 'Cliente #${project.clientId}'),
                const Divider(),
                _buildInfoRow('Responsable', 'Manager #${project.managerId}'),
                const Divider(),
                _buildInfoRow('Estado', _getProjectState(project)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Construye una fila de información
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }

  /// Construye una tarjeta de indicador
  Widget _buildIndicatorCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(title, style: Get.textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye una tarjeta de métrica
  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Get.textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Muestra el estado de error
  Widget _buildErrorState(String message) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Get.theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: Get.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Usar el nuevo ActiveProjectService para navegar de vuelta a proyectos
                // y asegurar que el sidebar se actualice correctamente
                Get.find<ActiveProjectService>().navigateBackToProjects();
              },
              child: const Text('Volver a Proyectos'),
            ),
          ],
        ),
      ),
    );
  }

  /// Calcula días restantes del proyecto
  String _calcularDiasRestantes(ProjectModel project) {
    if (project.estimatedEndDate == null) {
      return 'No definido';
    }

    final now = DateTime.now();
    final daysLeft = project.estimatedEndDate!.difference(now).inDays;

    return '$daysLeft días';
  }

  /// Obtiene una representación textual del estado del proyecto
  String _getProjectState(ProjectModel project) {
    switch (project.stateId) {
      case 1:
        return 'Planificación';
      case 2:
        return 'En progreso';
      case 3:
        return 'Completado';
      case 4:
        return 'En pausa';
      case 5:
        return 'Cancelado';
      default:
        return 'Desconocido';
    }
  }

  /// Obtiene el color según los días restantes
  Color _getDaysLeftColor(ProjectModel project) {
    if (project.estimatedEndDate == null) {
      return Colors.grey;
    }

    final now = DateTime.now();
    final days = project.estimatedEndDate!.difference(now).inDays;

    if (days < 0) {
      return Colors.red; // Vencido
    } else if (days <= 7) {
      return Colors.orange; // Próximo a vencer
    } else {
      return Colors.blue; // A tiempo
    }
  }

  /// Formatea una fecha para mostrarla
  String _formatDate(DateTime? date) {
    if (date == null) return 'No definido';
    return '${date.day}/${date.month}/${date.year}';
  }
}
