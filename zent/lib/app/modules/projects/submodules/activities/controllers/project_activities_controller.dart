import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../data/models/project_model.dart';
import '../../../../../data/models/activity_model.dart';
import '../../../../../data/services/activity_service.dart';

/// Controlador para la sección de actividades de un proyecto
class ProjectActivitiesController extends GetxController {
  final ActivityService _activityService = Get.find<ActivityService>();

  final RxBool isLoading = true.obs;
  final RxList<ActivityModel> activities = <ActivityModel>[].obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // Controlador para campo de búsqueda
  final textController = TextEditingController();
  final RxString filter = ''.obs;

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

  /// Carga las actividades del proyecto actual
  void loadActivities(ProjectModel project) {
    isLoading.value = true;
    hasError.value = false;

    try {
      // Aquí se cargarían los datos reales desde el servicio
      // Por ahora usamos datos de ejemplo
      _loadMockActivities();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Error cargando actividades: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Carga datos de ejemplo para la vista previa
  void _loadMockActivities() {}

  /// Agrega una nueva actividad
  void addActivity(ActivityModel activity) {
    activities.add(activity);
  }

  /// Actualiza una actividad existente
  void updateActivity(ActivityModel activity) {
    final index = activities.indexWhere((item) => item.id == activity.id);
    if (index != -1) {
      activities[index] = activity;
    }
  }

  /// Elimina una actividad
  void removeActivity(int activityId) {
    activities.removeWhere((activity) => activity.id == activityId);
  }

  /// Refresca los datos de las actividades
  void refreshData(ProjectModel project) {
    loadActivities(project);
  }

  getFilteredActivities() {}
}
