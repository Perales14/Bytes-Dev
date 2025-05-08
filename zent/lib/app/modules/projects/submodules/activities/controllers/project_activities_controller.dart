import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../data/models/activity_model.dart';
import '../../../../../data/services/activity_service.dart';
import '../../../../../data/services/project_context_service.dart';
import '../../../../../data/services/user_service.dart';
import '../widgets/add_activity_dialog.dart';

/// Controlador principal para la vista de actividades del proyecto
class ProjectActivitiesController extends GetxController {
  // Servicios
  final ActivityService _activityService = Get.find<ActivityService>();
  final ProjectContextService _projectContextService =
      Get.find<ProjectContextService>();
  final UserService _userService = Get.find<UserService>();

  // Controladores y datos reactivos
  final textController = TextEditingController();
  final RxList<ActivityModel> activities = <ActivityModel>[].obs;
  final RxList<ActivityModel> filteredActivities = <ActivityModel>[].obs;
  final RxMap<int, String> managerNames = <int, String>{}.obs;

  // Estados UI
  final RxBool isLoading = false.obs;
  final RxBool isStateFilterDropdownOpen = false.obs;

  /// Mapa unificado de IDs de estado (compatible con todos los componentes)
  final RxMap<int, bool> stateFilters = {
    1: true, // Sin comenzar
    2: true, // En progreso
    3: true, // Finalizado
    4: true, // Cancelado
    5: true, // Archivado
  }.obs;

  /// Nombres de estados para UI
  final Map<int, String> stateNames = {
    1: 'Sin comenzar',
    2: 'En progreso',
    3: 'Finalizado',
    4: 'Cancelado',
    5: 'Archivado',
  };

  /// Obtiene texto para el selector de filtros
  String get selectedStateFiltersText {
    final selected = stateFilters.entries
        .where((entry) => entry.value)
        .map((entry) => stateNames[entry.key])
        .toList();

    if (selected.length == stateFilters.length) return 'Todos los estados';
    if (selected.isEmpty) return 'Ningún estado seleccionado';
    return selected.join(', ');
  }

  @override
  void onInit() {
    super.onInit();
    _loadActivities();
    ever(stateFilters, (_) => _applyFilters());
    textController.addListener(() => _applyFilters());
  }

  @override
  void onClose() {
    textController.removeListener(_applyFilters);
    textController.dispose();
    super.onClose();
  }

  /// Carga las actividades del proyecto actual
  Future<void> _loadActivities() async {
    isLoading.value = true;

    try {
      final projectId = _projectContextService.currentProject?.id;

      if (projectId != null) {
        final projectActivities =
            await _activityService.getActivitiesByProject(projectId);
        activities.assignAll(projectActivities);
        await _loadManagerNames();
        _applyFilters();
      } else {
        activities.clear();
        filteredActivities.clear();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudieron cargar las actividades: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Carga los nombres de los responsables
  Future<void> _loadManagerNames() async {
    try {
      final managerIds = activities
          .where((activity) => activity.managerId != null)
          .map((activity) => activity.managerId!)
          .toSet()
          .toList();

      for (final managerId in managerIds) {
        final manager = await _userService.getUserById(managerId);
        if (manager != null) managerNames[managerId] = manager.fullName;
      }
    } catch (e) {
      debugPrint('Error al cargar nombres de responsables: $e');
    }
  }

  /// Obtiene el nombre del responsable
  String getManagerName(int? managerId) {
    if (managerId == null) return 'Sin asignar';
    return managerNames[managerId] ?? 'Responsable ID: $managerId';
  }

  /// Aplica filtros por estado y texto
  void _applyFilters() {
    final searchText = textController.text.toLowerCase();
    final activeStateIds = stateFilters.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (activeStateIds.isEmpty) {
      filteredActivities.clear();
      return;
    }

    filteredActivities.assignAll(activities.where((activity) {
      // Filtro por estado
      final matchesState = activeStateIds.contains(activity.stateId);

      // Filtro por texto de búsqueda
      final matchesSearch = searchText.isEmpty ||
          (activity.title?.toLowerCase().contains(searchText) ?? false) ||
          activity.description.toLowerCase().contains(searchText);

      return matchesState && matchesSearch;
    }));
  }

  /// Muestra/oculta el popup de filtros
  void toggleStateFilterDropdown() {
    isStateFilterDropdownOpen.value = !isStateFilterDropdownOpen.value;
    if (isStateFilterDropdownOpen.value) _showStateFilterPopup();
  }

  /// Muestra el popup de filtros de estado
  void _showStateFilterPopup() {
    Get.dialog(
      AlertDialog(
        title: const Text('Filtrar por estado'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: stateFilters.entries.map((entry) {
              return Obx(() => CheckboxListTile(
                    title: Text(stateNames[entry.key] ?? 'Desconocido'),
                    value: stateFilters[entry.key],
                    onChanged: (bool? value) {
                      if (value != null) stateFilters[entry.key] = value;
                    },
                    activeColor: Get.theme.colorScheme.primary,
                  ));
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              isStateFilterDropdownOpen.value = false;
              Get.back();
            },
            child: const Text('Cerrar'),
          ),
        ],
      ),
    ).then((_) => isStateFilterDropdownOpen.value = false);
  }

  /// Actualiza el estado de una actividad (drag & drop)
  Future<bool> updateActivityState(
      ActivityModel activity, int newStateId) async {
    try {
      if (activity.stateId == newStateId) return true;

      // Actualiza localmente primero
      final index = activities.indexWhere((a) => a.id == activity.id);
      if (index >= 0) {
        activities[index] = activity.copyWith(stateId: newStateId);
        _applyFilters();
      }

      // Actualiza en backend
      await _activityService
          .updateActivity(activity.copyWith(stateId: newStateId));

      Get.snackbar(
        'Éxito',
        'Estado de actividad actualizado',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      return true;
    } catch (e) {
      await _loadActivities();
      Get.snackbar(
        'Error',
        'No se pudo actualizar el estado: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  /// Maneja el tap en una actividad
  void onActivityTap(ActivityModel activity) {
    Get.dialog(
      AddActivityDialog(
        activity: activity,
        isEditing: true,
        onSaveSuccess: () => refreshActivities(),
      ),
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
    );
  }

  /// Maneja el botón de añadir actividad
  void onAddActivityPressed() {
    final projectId = _projectContextService.currentProject?.id;
    if (projectId != null) {
      Get.dialog(
        AddActivityDialog(
          onSaveSuccess: () => refreshActivities(),
        ),
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
      );
    } else {
      Get.snackbar(
        'Error',
        'No hay un proyecto activo',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Verifica si debe mostrarse un estado
  bool showStateId(int stateId) => stateFilters[stateId] ?? false;

  /// Obtiene actividades por estado
  List<ActivityModel> getActivitiesByState(int stateId) {
    return filteredActivities.where((a) => a.stateId == stateId).toList();
  }

  /// Recarga las actividades
  Future<void> refreshActivities() async => await _loadActivities();
}
