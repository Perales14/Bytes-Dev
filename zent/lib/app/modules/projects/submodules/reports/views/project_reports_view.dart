import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/project_reports_controller.dart';
import '../../../../../../app/data/models/project_model.dart';
import '../../../../../../app/data/services/project_context_service.dart';
import '../../../../../../app/shared/widgets/main_layout.dart';

/// Vista para la sección de reportes de un proyecto
class ProjectReportsView extends GetView<ProjectReportsController> {
  const ProjectReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    final projectContextService = Get.find<ProjectContextService>();

    // Verificamos que exista un proyecto en el contexto
    if (projectContextService.currentProject == null) {
      return _buildErrorState('No se ha seleccionado un proyecto');
    }

    final ProjectModel project = projectContextService.currentProject!;

    // Cargamos los datos cuando se construye la vista
    controller.loadReports(project);

    return MainLayout(
      pageTitle: 'Reportes: ${project.name}',
      textController: controller.textController,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Estadísticas
            _buildStatistics(),
            const SizedBox(height: 16),

            // Listado de reportes
            Expanded(
              child: Stack(
                children: [
                  Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.hasError.value) {
                      return _buildErrorState(controller.errorMessage.value);
                    }

                    final reports = controller.getFilteredReports();

                    if (reports.isEmpty) {
                      return _buildEmptyState();
                    }

                    return ListView.separated(
                      itemCount: reports.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final report = reports[index];
                        return _buildReportItem(report);
                      },
                    );
                  }),

                  // Botón flotante dentro del Stack
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: FloatingActionButton(
                      onPressed: _showAddReportDialog,
                      tooltip: 'Crear reporte',
                      child: const Icon(Icons.add_chart),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye la sección de estadísticas
  Widget _buildStatistics() {
    return Obx(() => Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.analytics, color: Get.theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Total de reportes: ${controller.totalReports}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ));
  }

  /// Construye un elemento de reporte
  Widget _buildReportItem(Map<String, dynamic> report) {
    return ListTile(
      title: Text(report['title'].toString()),
      subtitle: Text('${report['type']} - ${_formatDate(report['date'])}'),
      leading: _getReportTypeIcon(report['type'].toString()),
      trailing: Chip(
        label: Text(
          report['status'].toString(),
          style: TextStyle(
            color: _getStatusColor(report['status'].toString()),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor:
            _getStatusColor(report['status'].toString()).withOpacity(0.2),
        padding: EdgeInsets.zero,
      ),
      onTap: () => _showReportDetails(report),
    );
  }

  /// Obtiene el icono según el tipo de reporte
  Widget _getReportTypeIcon(String type) {
    IconData iconData;
    Color iconColor;

    switch (type.toLowerCase()) {
      case 'avance':
        iconData = Icons.trending_up;
        iconColor = Colors.green;
        break;
      case 'financiero':
        iconData = Icons.monetization_on;
        iconColor = Colors.blue;
        break;
      case 'incidencias':
        iconData = Icons.error_outline;
        iconColor = Colors.orange;
        break;
      case 'riesgos':
        iconData = Icons.warning;
        iconColor = Colors.red;
        break;
      default:
        iconData = Icons.description;
        iconColor = Colors.grey;
    }

    return CircleAvatar(
      radius: 20,
      backgroundColor: iconColor.withOpacity(0.2),
      child: Icon(iconData, size: 20, color: iconColor),
    );
  }

  /// Obtiene el color según el estado del reporte
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'aprobado':
        return Colors.green;
      case 'pendiente':
        return Colors.orange;
      case 'rechazado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Formatea una fecha para mostrarla
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Construye el estado de error
  Widget _buildErrorState([String? message]) {
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
            message ?? controller.errorMessage.value,
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

  /// Construye el estado vacío
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 48,
            color: Get.theme.colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No hay reportes para mostrar',
            style: Get.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Crea un nuevo reporte usando el botón de abajo',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Muestra los detalles de un reporte
  void _showReportDetails(Map<String, dynamic> report) {
    Get.dialog(
      AlertDialog(
        title: Text(report['title'].toString()),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem('Tipo', report['type'].toString()),
              _buildDetailItem('Fecha', _formatDate(report['date'])),
              _buildDetailItem('Autor', report['author'].toString()),
              _buildDetailItem('Estado', report['status'].toString()),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.link,
                      size: 16, color: Get.theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      report['fileUrl'].toString(),
                      style: TextStyle(
                        color: Get.theme.colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cerrar'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              // Aquí se implementaría la descarga del reporte
              Get.snackbar(
                'Información',
                'Descargando reporte...',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text('Descargar'),
          ),
        ],
      ),
    );
  }

  /// Construye un item de detalle
  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  /// Muestra el diálogo para agregar un nuevo reporte
  void _showAddReportDialog() {
    // Aquí se implementaría el diálogo para crear un nuevo reporte
    Get.dialog(
      AlertDialog(
        title: const Text('Crear nuevo reporte'),
        content: const Text('Funcionalidad por implementar'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              // Aquí se añadiría la lógica para crear el reporte
              final newReport = {
                'id': DateTime.now().millisecondsSinceEpoch,
                'title': 'Nuevo informe generado',
                'type': 'Avance',
                'date': DateTime.now(),
                'author': 'Usuario Actual',
                'status': 'Pendiente',
                'fileUrl': 'https://example.com/reports/new',
              };
              controller.addReport(newReport);
              Get.snackbar(
                'Éxito',
                'Reporte creado correctamente',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }
}
