import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../data/models/activity_model.dart';
import '../../../../../data/services/activity_service.dart';
import '../../../../../data/services/project_context_service.dart';
import '../../../../../data/services/user_service.dart';
import '../widgets/add_activity_dialog.dart';

class ProjectActivitiesController extends GetxController {
  // Servicios
  final ActivityService _activityService = Get.find<ActivityService>();
  final ProjectContextService _projectContextService =
      Get.find<ProjectContextService>();
  final UserService _userService = Get.find<UserService>();

  // Controlador de texto para la barra de búsqueda
  final textController = TextEditingController();

  // Listas reactivas de actividades
  final RxList<ActivityModel> activities = <ActivityModel>[].obs;
  final RxList<ActivityModel> filteredActivities = <ActivityModel>[].obs;

  // Mapa reactivo para almacenar nombres de responsables
  final RxMap<int, String> managerNames = <int, String>{}.obs;

  // Estados reactivos para UI
  final RxBool isLoading = false.obs;
  final RxBool isStateFilterDropdownOpen = false.obs;

  // Mapa para controlar qué estados se muestran (todos por defecto)
  final RxMap<int, bool> stateFilters = {
    1: true, // SIN COMENZAR
    2: true, // EN PROGRESO
    3: true, // FINALIZADO
    4: true, // CANCELADO
    5: true, // ARCHIVADO
  }.obs;

  // Nombres de los estados para mostrar en UI
  final Map<int, String> stateNames = {
    1: 'Sin comenzar',
    2: 'En progreso',
    3: 'Finalizado',
    4: 'Cancelado',
    5: 'Archivado',
  };

  // Getter para texto de estados seleccionados
  String get selectedStateFiltersText {
    final selected = stateFilters.entries
        .where((entry) => entry.value)
        .map((entry) => stateNames[entry.key])
        .toList();

    if (selected.length == stateFilters.length) {
      return 'Todos los estados';
    } else if (selected.isEmpty) {
      return 'Ningún estado seleccionado';
    } else {
      return selected.join(', ');
    }
  }

  @override
  void onInit() {
    super.onInit();

    // Cargar actividades cuando se inicia el controlador
    _loadActivities();

    // Escuchar cambios en el filtro de búsqueda
    ever(stateFilters, (_) => _applyFilters());

    // Agregar listener al campo de búsqueda
    textController.addListener(() {
      _applyFilters();
    });
  }

  @override
  void onClose() {
    textController.removeListener(_applyFilters);
    textController.dispose();
    super.onClose();
  }

  // Carga las actividades del proyecto actual
  Future<void> _loadActivities() async {
    isLoading.value = true;

    try {
      final projectId = _projectContextService.currentProject?.id;

      if (projectId != null) {
        final projectActivities =
            await _activityService.getActivitiesByProject(projectId);
        activities.assignAll(projectActivities);

        // Cargar nombres de responsables
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

  // Carga los nombres de los responsables de las actividades
  Future<void> _loadManagerNames() async {
    try {
      final managerIds = activities
          .where((activity) => activity.managerId != null)
          .map((activity) => activity.managerId!)
          .toSet()
          .toList();

      if (managerIds.isNotEmpty) {
        for (final managerId in managerIds) {
          final manager = await _userService.getUserById(managerId);
          if (manager != null) {
            managerNames[managerId] = manager.fullName;
          }
        }
      }
    } catch (e) {
      print('Error al cargar nombres de responsables: $e');
    }
  }

  // Obtiene el nombre del responsable para una actividad
  String getManagerName(int? managerId) {
    if (managerId == null) return 'Sin asignar';
    return managerNames[managerId] ?? 'Responsable ID: $managerId';
  }

  // Aplica los filtros seleccionados a la lista de actividades
  void _applyFilters() {
    final searchText = textController.text.toLowerCase();
    final activeStateIds = stateFilters.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (activeStateIds.isEmpty) {
      filteredActivities.clear();
    } else {
      filteredActivities.assignAll(activities.where((activity) {
        // Filtro por estado
        final matchesState = activeStateIds.contains(activity.stateId);

        // Filtro por texto de búsqueda (titulo y descripción)
        final matchesSearch = searchText.isEmpty ||
            (activity.title?.toLowerCase().contains(searchText) ?? false) ||
            activity.description.toLowerCase().contains(searchText);

        return matchesState && matchesSearch;
      }));
    }
  }

  // Toggle del dropdown de filtros de estado
  void toggleStateFilterDropdown() {
    isStateFilterDropdownOpen.value = !isStateFilterDropdownOpen.value;

    if (isStateFilterDropdownOpen.value) {
      // Aquí se mostraría el popup con checkboxes
      _showStateFilterPopup();
    }
  }

  // Muestra el popup para filtrar por estados
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
                      if (value != null) {
                        stateFilters[entry.key] = value;
                      }
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
    ).then((_) {
      isStateFilterDropdownOpen.value = false;
    });
  }

  // Actualiza el estado de una actividad (usado en drag & drop)
  Future<bool> updateActivityState(
      ActivityModel activity, int newStateId) async {
    try {
      if (activity.stateId == newStateId) return true;

      // Actualiza el estado localmente primero para UI responsiva
      final index = activities.indexWhere((a) => a.id == activity.id);
      if (index >= 0) {
        final updatedActivity = activity.copyWith(stateId: newStateId);
        activities[index] = updatedActivity;
        _applyFilters(); // Re-aplicar filtros
      }

      // Luego actualiza en el backend
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
      // Revertir cambio local si falla
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

  // Maneja el tap en una actividad
  void onActivityTap(ActivityModel activity) {
    // Mostrar diálogo con detalles y opción de editar
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

  // Maneja el botón de añadir actividad
  void onAddActivityPressed() {
    final projectId = _projectContextService.currentProject?.id;
    if (projectId != null) {
      Get.dialog(
        AddActivityDialog(
          onSaveSuccess: () {
            refreshActivities();
          },
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

  // Comprueba si se debe mostrar un estado según los filtros
  bool showStateId(int stateId) {
    return stateFilters[stateId] ?? false;
  }

  // Obtiene actividades filtradas por estado
  List<ActivityModel> getActivitiesByState(int stateId) {
    return filteredActivities.where((a) => a.stateId == stateId).toList();
  }

  // Recarga las actividades (útil para pull-to-refresh)
  Future<void> refreshActivities() async {
    await _loadActivities();
  }
}
