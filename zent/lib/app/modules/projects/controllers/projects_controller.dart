import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/project_model.dart';
import '../../../data/services/project_service.dart';
import '../../../data/services/client_service.dart';
import '../../../data/services/user_service.dart';
import '../widgets/add_project_dialog.dart';

class ProjectsController extends GetxController {
  final ProjectService _projectService = Get.find<ProjectService>();
  final ClientService _clientService = Get.find<ClientService>();
  final UserService _userService = Get.find<UserService>();

  final RxList<ProjectModel> projects = <ProjectModel>[].obs;
  final RxString filter = ''.obs;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // Cachés para nombres de clientes y managers
  final RxMap<int, String> clientNames = <int, String>{}.obs;
  final RxMap<int, String> managerNames = <int, String>{}.obs;

  final textController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadProjects();
    _setupTextListener();
  }

  void _setupTextListener() {
    textController.addListener(() => filter.value = textController.text);
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  Future<void> loadProjects() async {
    try {
      isLoading(true);
      hasError(false);
      projects.assignAll(await _projectService.getAllProjects());

      // Cargar información de clientes y managers
      for (var project in projects) {
        loadClientNameIfNeeded(project.clientId);
        loadManagerNameIfNeeded(project.managerId);
      }
    } catch (e) {
      hasError(true);
      errorMessage('Error al cargar proyectos: $e');
    } finally {
      isLoading(false);
    }
  }

  // Cargar el nombre del cliente si no está en caché
  Future<void> loadClientNameIfNeeded(int clientId) async {
    if (!clientNames.containsKey(clientId)) {
      clientNames[clientId] = 'Cargando...';
      try {
        final client = await _clientService.getClientById(clientId);
        if (client != null) {
          clientNames[clientId] = client.fullName;
        } else {
          clientNames[clientId] = 'Cliente #$clientId';
        }
      } catch (e) {
        clientNames[clientId] = 'Cliente #$clientId';
      }
    }
  }

  // Cargar el nombre del manager si no está en caché
  Future<void> loadManagerNameIfNeeded(int managerId) async {
    if (!managerNames.containsKey(managerId)) {
      managerNames[managerId] = 'Cargando...';
      try {
        final manager = await _userService.getUserById(managerId);
        if (manager != null) {
          managerNames[managerId] = manager.fullName;
        } else {
          managerNames[managerId] = 'Manager #$managerId';
        }
      } catch (e) {
        managerNames[managerId] = 'Manager #$managerId';
      }
    }
  }

  // Obtener el nombre del cliente
  String getClientName(int clientId) {
    return clientNames[clientId] ?? 'Cliente #$clientId';
  }

  // Obtener el nombre del manager
  String getManagerName(int managerId) {
    return managerNames[managerId] ?? 'Manager #$managerId';
  }

  void refreshData() => loadProjects();

  ProjectModel getProjectById(int id) {
    return projects.firstWhere(
      (project) => project.id == id,
      orElse: () => throw Exception('Proyecto con ID $id no encontrado'),
    );
  }

  List<ProjectModel> getFilteredProjects() {
    if (projects.isEmpty) return [];
    if (filter.isEmpty) return projects;

    return projects
        .where((project) =>
            project.name.toLowerCase().contains(filter.value.toLowerCase()) ||
            getClientName(project.clientId)
                .toLowerCase()
                .contains(filter.value.toLowerCase()) ||
            getManagerName(project.managerId)
                .toLowerCase()
                .contains(filter.value.toLowerCase()))
        .toList();
  }

  Future<void> setProjectInactive(int id) async {
    try {
      await _projectService.setProjectInactive(id);
      refreshData();
    } catch (e) {
      throw Exception('Error al desactivar el proyecto: $e');
    }
  }

  void showEditProjectDialog(int projectId) {
    try {
      final project = getProjectById(projectId);
      Get.dialog(
        AddProjectDialog(
          project: project,
          onSaveSuccess: refreshData,
          isEditing: true,
        ),
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo encontrar la información del proyecto para editar',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }
}
