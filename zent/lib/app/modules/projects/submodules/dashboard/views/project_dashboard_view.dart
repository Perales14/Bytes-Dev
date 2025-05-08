import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../data/services/active_project_service.dart';
import '../controllers/project_dashboard_controller.dart';
import '../../../../../../app/data/models/project_model.dart';
import '../../../../../../app/shared/widgets/main_layout.dart';
import '../../../widgets/add_project_dialog.dart';

/// Vista para el dashboard de un proyecto específico
class ProjectDashboardView extends GetView<ProjectDashboardController> {
  const ProjectDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.hasError.value) {
        return _buildErrorState(controller.errorMessage.value);
      }

      if (controller.project == null) {
        return _buildErrorState('No se ha seleccionado un proyecto');
      }

      return _buildDashboardContent(context, controller.project!);
    });
  }

  /// Construye el contenido principal del dashboard
  Widget _buildDashboardContent(BuildContext context, ProjectModel project) {
    final theme = Theme.of(context);

    return MainLayout(
      pageTitle: 'Dashboard',
      textController: TextEditingController(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProjectHeader(context, project),
              const SizedBox(height: 24),
              _buildStatusIndicators(project),
              const SizedBox(height: 24),
              _buildProjectDetails(project, theme),
              const SizedBox(height: 24),
              _buildAddressSection(project, theme),
              const SizedBox(height: 24),
              _buildActionButtons(context, project),
            ],
          ),
        ),
      ),
    );
  }

  /// Cabecera con información y barra de progreso
  Widget _buildProjectHeader(BuildContext context, ProjectModel project) {
    final progressPercentage = _calcularPorcentajeActividades(project);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Get.theme.primaryColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (project.description != null && project.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  project.description!,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Progreso del Proyecto',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 6),
                      LinearProgressIndicator(
                        value: progressPercentage / 100,
                        minHeight: 8,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                            _getProgressColor(progressPercentage)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${progressPercentage.toStringAsFixed(1)}%',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            _getProgressStatus(progressPercentage, project),
                            style: TextStyle(
                              color: _getProgressStatusColor(
                                  progressPercentage, project),
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Chip(
                  backgroundColor:
                      _getStateColor(project.stateId).withOpacity(0.2),
                  label: Text(
                    _getProjectState(project),
                    style: TextStyle(
                      color: _getStateColor(project.stateId),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  avatar: Icon(
                    _getStateIcon(project.stateId),
                    size: 16,
                    color: _getStateColor(project.stateId),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Indicadores de estado (presupuesto, días, etc.)
  Widget _buildStatusIndicators(ProjectModel project) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Métricas Principales',
          style:
              Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildIndicatorCard(
                title: 'Presupuesto',
                value:
                    '\$${project.estimatedBudget?.toStringAsFixed(2) ?? "0.00"}',
                icon: Icons.monetization_on_outlined,
                color: Colors.green[700]!,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildIndicatorCard(
                title: 'Duración Estimada',
                value: _calcularDuracionProyecto(project),
                icon: Icons.date_range,
                color: Colors.blue[700]!,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildIndicatorCard(
                title: 'Días Restantes',
                value: _calcularDiasRestantes(project),
                icon: Icons.timer,
                color: _getDaysLeftColor(project),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildIndicatorCard(
                title: 'Comisión Estimada',
                value: _calcularComision(project),
                icon: Icons.attach_money,
                color: Colors.amber[700]!,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Detalles del proyecto (fechas, equipo, etc.)
  Widget _buildProjectDetails(ProjectModel project, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Información del Proyecto',
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildInfoRow(
                  'Fecha de Inicio',
                  _formatDate(project.startDate),
                  icon: Icons.calendar_today,
                ),
                const Divider(height: 24),
                _buildInfoRow(
                  'Fecha Estimada de Finalización',
                  _formatDate(project.estimatedEndDate),
                  icon: Icons.event,
                ),
                if (project.actualEndDate != null) ...[
                  const Divider(height: 24),
                  _buildInfoRow(
                    'Fecha Real de Finalización',
                    _formatDate(project.actualEndDate),
                    icon: Icons.check_circle,
                    valueColor: Colors.green,
                  ),
                ],
                if (project.deliveryDate != null) ...[
                  const Divider(height: 24),
                  _buildInfoRow(
                    'Fecha de Entrega',
                    _formatDate(project.deliveryDate),
                    icon: Icons.delivery_dining,
                  ),
                ],
                const Divider(height: 24),
                _buildInfoRow(
                  'Cliente',
                  _getClientName(),
                  icon: Icons.person,
                ),
                const Divider(height: 24),
                _buildInfoRow(
                  'Responsable',
                  _getManagerName(),
                  icon: Icons.person_pin_circle,
                ),
                if (controller.provider.value != null) ...[
                  const Divider(height: 24),
                  _buildInfoRow(
                    'Proveedor',
                    controller.provider.value!.companyName,
                    icon: Icons.business,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Obtiene el nombre del cliente
  String _getClientName() {
    if (controller.client.value != null) {
      return controller.client.value!.fullName;
    }
    return 'Cliente ID: ${controller.project!.clientId}';
  }

  /// Obtiene el nombre del responsable
  String _getManagerName() {
    if (controller.manager.value != null) {
      return controller.manager.value!.fullName;
    }
    return 'Responsable ID: ${controller.project!.managerId}';
  }

  /// Sección de dirección
  Widget _buildAddressSection(ProjectModel project, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dirección',
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          margin: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: controller.address.value != null
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Get.theme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.location_on,
                              color: Get.theme.primaryColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Dirección del Proyecto',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.home_work_outlined,
                              color: theme.colorScheme.secondary,
                              size: 22,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                controller.address.value!.fullAddress,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_off,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Este proyecto no tiene una dirección asociada',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  /// Botones de acción (editar, eliminar)
  Widget _buildActionButtons(BuildContext context, ProjectModel project) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: () => _showEditProjectDialog(context, project),
            icon: const Icon(Icons.edit, color: Colors.white),
            label: const Text('Editar Proyecto'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Get.theme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(width: 16),
          OutlinedButton.icon(
            onPressed: () => _showDeleteConfirmation(context, project),
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            label: const Text('Eliminar Proyecto'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  /// Construye una fila de información
  Widget _buildInfoRow(
    String label,
    String value, {
    IconData? icon,
    Color? valueColor,
  }) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: Get.theme.primaryColor.withOpacity(0.7)),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  /// Construye una tarjeta indicador
  Widget _buildIndicatorCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color.withOpacity(0.9),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
              size: 64,
              color: Get.theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: Get.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Get.offNamed('/projects'),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Volver a Proyectos'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Calcula duración del proyecto en días
  String _calcularDuracionProyecto(ProjectModel project) {
    if (project.startDate == null || project.estimatedEndDate == null) {
      return 'No definida';
    }

    final duracion =
        project.estimatedEndDate!.difference(project.startDate!).inDays;
    return '$duracion días';
  }

  /// Calcula días restantes del proyecto
  String _calcularDiasRestantes(ProjectModel project) {
    if (project.estimatedEndDate == null) {
      return 'No definido';
    }

    if (project.actualEndDate != null) {
      return 'Completado';
    }

    final now = DateTime.now();
    final daysLeft = project.estimatedEndDate!.difference(now).inDays;

    if (daysLeft < 0) {
      return '${daysLeft.abs()} días atrasado';
    }

    return '$daysLeft días restantes';
  }

  /// Calcula la comisión del proyecto
  String _calcularComision(ProjectModel project) {
    if (project.estimatedBudget == null ||
        project.commissionPercentage == null) {
      return 'No definida';
    }

    final comision =
        (project.estimatedBudget! * project.commissionPercentage!) / 100;
    return '\$${comision.toStringAsFixed(2)}';
  }

  /// Calcula el porcentaje de progreso del proyecto basado en actividades finalizadas
  double _calcularPorcentajeActividades(ProjectModel project) {
    // Simulación de porcentaje basado en actividades terminadas (ID 5)
    // Idealmente, este método obtendría datos reales del controlador
    // En un caso real, consultaríamos:
    // - Total de actividades del proyecto
    // - Número de actividades con estado 5 (terminadas)

    // Por ahora, asumimos un porcentaje basado en un cálculo simple
    if (project.actualEndDate != null) {
      return 100.0;
    }

    // Simulación: porcentaje basado en el tiempo transcurrido
    if (project.startDate == null || project.estimatedEndDate == null) {
      return 0.0;
    }

    final totalDias =
        project.estimatedEndDate!.difference(project.startDate!).inDays;
    if (totalDias <= 0) return 0.0;

    final now = DateTime.now();
    if (now.isBefore(project.startDate!)) return 0.0;

    final diasTranscurridos = now.difference(project.startDate!).inDays;
    return (diasTranscurridos / totalDias * 100).clamp(0.0, 99.9);
  }

  /// Obtiene una representación textual del estado del proyecto
  String _getProjectState(ProjectModel project) {
    switch (project.stateId) {
      case 1:
        return 'Planificación';
      case 2:
        return 'En Progreso';
      case 3:
        return 'Completado';
      case 4:
        return 'En Pausa';
      case 5:
        return 'Cancelado';
      default:
        return 'Desconocido';
    }
  }

  /// Obtiene el color según el estado del proyecto
  Color _getStateColor(int stateId) {
    switch (stateId) {
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

  /// Obtiene el icono según el estado del proyecto
  IconData _getStateIcon(int stateId) {
    switch (stateId) {
      case 1:
        return Icons.architecture;
      case 2:
        return Icons.play_circle_filled;
      case 3:
        return Icons.check_circle;
      case 4:
        return Icons.pause_circle_filled;
      case 5:
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  /// Obtiene el estado textual del progreso
  String _getProgressStatus(double percentage, ProjectModel project) {
    if (project.actualEndDate != null) {
      return 'Completado';
    }

    if (project.estimatedEndDate == null || project.startDate == null) {
      return 'No iniciado';
    }

    final now = DateTime.now();
    if (now.isBefore(project.startDate!)) {
      return 'No iniciado';
    }

    if (now.isAfter(project.estimatedEndDate!)) {
      return 'Atrasado';
    }

    if (percentage < 25) {
      return 'Fase inicial';
    } else if (percentage < 50) {
      return 'En desarrollo';
    } else if (percentage < 75) {
      return 'Avanzado';
    } else {
      return 'Etapa final';
    }
  }

  /// Obtiene el color del estado de progreso
  Color _getProgressStatusColor(double percentage, ProjectModel project) {
    if (project.actualEndDate != null) {
      return Colors.green;
    }

    final now = DateTime.now();
    if (project.estimatedEndDate != null &&
        now.isAfter(project.estimatedEndDate!)) {
      return Colors.red;
    }

    if (percentage < 25) {
      return Colors.blue;
    } else if (percentage < 50) {
      return Colors.cyan;
    } else if (percentage < 75) {
      return Colors.amber;
    } else {
      return Colors.orange;
    }
  }

  /// Obtiene el color según los días restantes
  Color _getDaysLeftColor(ProjectModel project) {
    if (project.estimatedEndDate == null) {
      return Colors.grey;
    }

    if (project.actualEndDate != null) {
      return Colors.green;
    }

    final now = DateTime.now();
    final days = project.estimatedEndDate!.difference(now).inDays;

    if (days < 0) {
      return Colors.red;
    } else if (days <= 7) {
      return Colors.orange;
    } else {
      return Colors.blue;
    }
  }

  /// Obtiene el color para la barra de progreso
  Color _getProgressColor(double percentage) {
    if (percentage < 25) {
      return Colors.blue;
    } else if (percentage < 50) {
      return Colors.cyan;
    } else if (percentage < 75) {
      return Colors.amber;
    } else {
      return Colors.green;
    }
  }

  /// Formatea una fecha para mostrarla
  String _formatDate(DateTime? date) {
    if (date == null) return 'No definido';
    return '${date.day}/${date.month}/${date.year}';
  }

  // Métodos de acción

  /// Muestra el diálogo de edición de proyecto
  void _showEditProjectDialog(BuildContext context, ProjectModel project) {
    Get.dialog(
      AddProjectDialog(
        project: project,
        isEditing: true,
        onSaveSuccess: () {
          controller.refreshData();
          Get.snackbar(
            'Éxito',
            'Proyecto actualizado correctamente',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        },
      ),
      barrierDismissible: true,
    );
  }

  /// Muestra confirmación para eliminar proyecto
  void _showDeleteConfirmation(BuildContext context, ProjectModel project) {
    Get.dialog(
      AlertDialog(
        title: const Text('Eliminar Proyecto'),
        content: Text(
            '¿Está seguro que desea eliminar el proyecto "${project.name}"? Esta acción no puede deshacerse.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancelar',
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              // Aquí iría la lógica para eliminar el proyecto
              Get.snackbar(
                'Proyecto eliminado',
                'El proyecto "${project.name}" ha sido eliminado',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
              Get.offNamed('/projects');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }
}
