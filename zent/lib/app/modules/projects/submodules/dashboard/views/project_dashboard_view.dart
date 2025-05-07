import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/project_dashboard_controller.dart';
import '../../../../../../app/data/models/project_model.dart';
import '../../../../../../app/data/services/project_context_service.dart';
import '../../../../../../app/shared/widgets/main_layout.dart';

/// Vista para el dashboard de un proyecto específico
class ProjectDashboardView extends GetView<ProjectDashboardController> {
  const ProjectDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final projectContextService = Get.find<ProjectContextService>();

    // Verificamos que exista un proyecto en el contexto
    if (projectContextService.currentProject == null) {
      return _buildErrorState('No se ha seleccionado un proyecto');
    }

    final ProjectModel project = projectContextService.currentProject!;

    // Cargamos los datos cuando se construye la vista
    controller.loadDashboard(project.id);

    return MainLayout(
      pageTitle: 'Dashboard: ${project.name}',
      textController:
          TextEditingController(), // Controlador vacío ya que no se usa búsqueda aquí
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.hasError.value) {
            return _buildErrorState(controller.errorMessage.value);
          }

          return _buildDashboardContent(context, project);
        }),
      ),
    );
  }

  /// Construye el contenido principal del dashboard
  Widget _buildDashboardContent(BuildContext context, ProjectModel project) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Indicadores de estado
          _buildStatusIndicators(),
          const SizedBox(height: 24),

          // Tarjetas de métricas principales
          _buildMetricsCards(),
          const SizedBox(height: 24),

          // Gráfica de avance (placeholder)
          _buildProgressChart(),
          const SizedBox(height: 24),

          // Información adicional
          _buildAdditionalInfo(),
        ],
      ),
    );
  }

  /// Construye los indicadores de estado del proyecto
  Widget _buildStatusIndicators() {
    return Row(
      children: [
        Expanded(
          child: _buildIndicatorCard(
            title: 'Presupuesto',
            value: '\$${controller.budget.value.toStringAsFixed(2)}',
            icon: Icons.monetization_on_outlined,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildIndicatorCard(
            title: 'Días restantes',
            value: '${controller.daysLeft.value} días',
            icon: Icons.calendar_today,
            color: _getDaysLeftColor(),
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
                value:
                    '${controller.completedActivities.value}/${controller.totalActivities.value}',
                icon: Icons.task_alt,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMetricCard(
                title: 'Documentos Pendientes',
                value: '${controller.pendingDocuments.value}',
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
              Text(
                '${controller.completion.value.toStringAsFixed(1)}%',
                style: const TextStyle(
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
                      width: 200 * (controller.completion.value / 100),
                      color: _getCompletionColor(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Estado: ${controller.getProjectHealthStatus()}',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: _getHealthStatusColor(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Construye información adicional del proyecto
  Widget _buildAdditionalInfo() {
    // Obtenemos el proyecto del contexto para poder pasarlo a los métodos
    final ProjectModel project =
        Get.find<ProjectContextService>().currentProject!;

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
    return Center(
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
            onPressed: () => Get.offNamed('/projects'),
            child: const Text('Volver a Proyectos'),
          ),
        ],
      ),
    );
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

  /// Obtiene el color según el estado del proyecto
  Color _getStateColor(ProjectModel project) {
    switch (project.stateId) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.purple;
      case 4:
        return Colors.orange;
      case 5:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Obtiene el color según los días restantes
  Color _getDaysLeftColor() {
    final days = controller.daysLeft.value;

    if (days < 0) {
      return Colors.red; // Vencido
    } else if (days <= 7) {
      return Colors.orange; // Próximo a vencer
    } else {
      return Colors.blue; // A tiempo
    }
  }

  /// Obtiene el color según el porcentaje de avance
  Color _getCompletionColor() {
    final completion = controller.completion.value;

    if (completion < 25) {
      return Colors.red;
    } else if (completion < 50) {
      return Colors.orange;
    } else if (completion < 75) {
      return Colors.blue;
    } else {
      return Colors.green;
    }
  }

  /// Obtiene el color según el estado de salud del proyecto
  Color _getHealthStatusColor() {
    final status = controller.getProjectHealthStatus();

    if (status == 'En riesgo') {
      return Colors.red;
    } else if (status == 'Atención requerida') {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  /// Formatea una fecha para mostrarla
  String _formatDate(DateTime? date) {
    if (date == null) return 'No definido';
    return '${date.day}/${date.month}/${date.year}';
  }
}
