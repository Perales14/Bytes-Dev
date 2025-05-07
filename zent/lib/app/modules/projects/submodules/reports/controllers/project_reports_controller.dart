import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../data/models/project_model.dart';
import '../../../../../data/services/project_service.dart';

/// Controlador para la sección de reportes de un proyecto
class ProjectReportsController extends GetxController {
  final ProjectService _projectService = Get.find<ProjectService>();

  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // Controlador para campo de búsqueda
  final textController = TextEditingController();
  final RxString filter = ''.obs;

  // Datos de reportes
  final RxList<Map<String, dynamic>> reports = <Map<String, dynamic>>[].obs;
  final RxInt totalReports = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _setupTextListener();
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  /// Configura el listener para el campo de texto de filtrado
  void _setupTextListener() {
    textController.addListener(() => filter.value = textController.text);
  }

  /// Carga los reportes del proyecto actual
  void loadReports(ProjectModel project) {
    isLoading.value = true;
    hasError.value = false;

    try {
      // Aquí se cargarían los datos reales desde el servicio
      // Por ahora usamos datos de ejemplo
      _loadMockReports();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Error cargando reportes: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Carga datos de ejemplo para la vista previa
  void _loadMockReports() {
    Future.delayed(const Duration(milliseconds: 700), () {
      final now = DateTime.now();

      final mockReports = [
        {
          'id': 1,
          'title': 'Reporte de avance mensual',
          'type': 'Avance',
          'date': now.subtract(const Duration(days: 5)),
          'author': 'Juan Pérez',
          'status': 'Aprobado',
          'fileUrl': 'https://example.com/reports/1',
        },
        {
          'id': 2,
          'title': 'Informe financiero Q1',
          'type': 'Financiero',
          'date': now.subtract(const Duration(days: 12)),
          'author': 'María González',
          'status': 'Pendiente',
          'fileUrl': 'https://example.com/reports/2',
        },
        {
          'id': 3,
          'title': 'Reporte de incidencias técnicas',
          'type': 'Incidencias',
          'date': now.subtract(const Duration(days: 20)),
          'author': 'Carlos López',
          'status': 'Aprobado',
          'fileUrl': 'https://example.com/reports/3',
        },
        {
          'id': 4,
          'title': 'Evaluación de riesgos',
          'type': 'Riesgos',
          'date': now.subtract(const Duration(days: 25)),
          'author': 'Ana Ramírez',
          'status': 'Rechazado',
          'fileUrl': 'https://example.com/reports/4',
        },
      ];

      reports.assignAll(mockReports);
      totalReports.value = mockReports.length;
      isLoading.value = false;
    });
  }

  /// Obtiene reportes filtrados según texto de búsqueda
  List<Map<String, dynamic>> getFilteredReports() {
    if (filter.isEmpty) return reports;

    final searchLower = filter.value.toLowerCase();
    return reports
        .where((report) =>
            report['title'].toString().toLowerCase().contains(searchLower) ||
            report['type'].toString().toLowerCase().contains(searchLower) ||
            report['author'].toString().toLowerCase().contains(searchLower) ||
            report['status'].toString().toLowerCase().contains(searchLower))
        .toList();
  }

  /// Agrega un nuevo reporte
  void addReport(Map<String, dynamic> report) {
    reports.add(report);
    totalReports.value = reports.length;
  }

  /// Elimina un reporte
  void removeReport(int reportId) {
    reports.removeWhere((report) => report['id'] == reportId);
    totalReports.value = reports.length;
  }

  /// Refresca los datos de los reportes
  void refreshData(ProjectModel project) {
    loadReports(project);
  }
}
