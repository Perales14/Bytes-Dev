import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/project_model.dart';
import '../../../data/services/project_service.dart';
import '../../../data/services/client_service.dart';
import '../../../data/services/user_service.dart';
import '../../../data/services/session_service.dart';
import '../../../data/services/project_context_service.dart';
import '../../../shared/controllers/sidebar_controller.dart';
import '../widgets/add_project_dialog.dart';

class ProjectsController extends GetxController {
  final ProjectService _projectService = Get.find<ProjectService>();
  final ClientService _clientService = Get.find<ClientService>();
  final UserService _userService = Get.find<UserService>();
  final SessionService _sessionService = Get.find<SessionService>();
  final SidebarController _sidebarController = Get.find<SidebarController>();
  final ProjectContextService _projectContextService =
      Get.find<ProjectContextService>();

  final RxList<ProjectModel> projects = <ProjectModel>[].obs;
  final RxString filter = ''.obs;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // Cachés reactivos para nombres de clientes y managers
  final RxMap<int, String> clientNames = <int, String>{}.obs;
  final RxMap<int, String> managerNames = <int, String>{}.obs;

  // Controlar si las cachés están completamente cargadas
  final RxBool areClientNamesLoaded = false.obs;
  final RxBool areManagerNamesLoaded = false.obs;

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
    _projectContextService.clearCurrentProject();
    super.onClose();
  }

  Future<void> loadProjects() async {
    try {
      isLoading(true);
      hasError(false);
      areClientNamesLoaded(false);
      areManagerNamesLoaded(false);

      // Limpia las cachés para evitar datos obsoletos
      clientNames.clear();
      managerNames.clear();

      // Carga proyectos según rol del usuario
      if (_sessionService.hasRole(SessionService.ROLE_ADMIN)) {
        // Administradores ven todos los proyectos
        projects.assignAll(await _projectService.getAllProjects());
      } else if (_sessionService.hasRole(SessionService.ROLE_PROMOTOR)) {
        // Promotores solo ven sus proyectos asignados (donde son managers)
        if (_sessionService.currentUser != null) {
          int userId = _sessionService.currentUser!.id;
          projects
              .assignAll(await _projectService.getProjectsByManager(userId));
        } else {
          projects.clear();
        }
      } else {
        // Para otros roles, mostrar proyectos según permisos específicos
        // Por defecto, usar todos los proyectos
        projects.assignAll(await _projectService.getAllProjects());
      }

      // Extraer IDs únicos de clientes y managers para cargar eficientemente
      final Set<int> clientIds = projects.map((p) => p.clientId).toSet();
      final Set<int> managerIds = projects.map((p) => p.managerId).toSet();

      // Cargar todos los nombres en paralelo para mejor rendimiento
      await Future.wait(
          [_loadAllClientNames(clientIds), _loadAllManagerNames(managerIds)]);
    } catch (e) {
      hasError(true);
      errorMessage('Error al cargar proyectos: $e');
    } finally {
      isLoading(false);
    }
  }

  // Cargar todos los nombres de clientes de una vez
  Future<void> _loadAllClientNames(Set<int> clientIds) async {
    try {
      // Inicializar todos con "Cargando..."
      for (var id in clientIds) {
        clientNames[id] = 'Cargando...';
      }

      // Obtener todos los clientes de una vez para evitar múltiples llamadas
      final allClients = await _clientService.getAllClients();

      // Actualizar el caché con nombres completos
      for (var client in allClients) {
        if (clientIds.contains(client.id)) {
          clientNames[client.id] = '${client.name} ${client.fatherLastName}';
        }
      }

      // Verificar si quedaron algunos sin cargar y ponerles un valor por defecto
      for (var id in clientIds) {
        if (clientNames[id] == 'Cargando...') {
          clientNames[id] = 'Cliente #$id';
        }
      }

      areClientNamesLoaded(true);
    } catch (e) {
      print('Error cargando nombres de clientes: $e');
      // En caso de error, establecer valores por defecto
      for (var id in clientIds) {
        clientNames[id] = 'Cliente #$id';
      }
      areClientNamesLoaded(true);
    }
  }

  // Cargar todos los nombres de managers de una vez
  Future<void> _loadAllManagerNames(Set<int> managerIds) async {
    try {
      // Inicializar todos con "Cargando..."
      for (var id in managerIds) {
        managerNames[id] = 'Cargando...';
      }

      // Obtener todos los empleados de una vez
      final allManagers = await _userService.getAllEmployees();

      // Actualizar el caché con nombres completos
      for (var manager in allManagers) {
        if (managerIds.contains(manager.id)) {
          managerNames[manager.id] =
              '${manager.name} ${manager.fatherLastName}';
        }
      }

      // Verificar si quedaron algunos sin cargar y ponerles un valor por defecto
      for (var id in managerIds) {
        if (managerNames[id] == 'Cargando...') {
          managerNames[id] = 'Manager #$id';
        }
      }

      areManagerNamesLoaded(true);
    } catch (e) {
      print('Error cargando nombres de managers: $e');
      // En caso de error, establecer valores por defecto
      for (var id in managerIds) {
        managerNames[id] = 'Manager #$id';
      }
      areManagerNamesLoaded(true);
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

  /// Navega al dashboard de un proyecto específico
  void navigateToProjectDashboard(ProjectModel project) {
    _navigateToProjectSubmenu(project, '/projects/${project.id}/dashboard');
  }

  /// Navega a la vista de actividades de un proyecto
  void navigateToProjectActivities(ProjectModel project) {
    _navigateToProjectSubmenu(project, '/projects/${project.id}/activities');
  }

  /// Navega a la vista de documentos de un proyecto
  void navigateToProjectDocuments(ProjectModel project) {
    _navigateToProjectSubmenu(project, '/projects/${project.id}/documents');
  }

  /// Navega a la vista de reportes de un proyecto
  void navigateToProjectReports(ProjectModel project) {
    _navigateToProjectSubmenu(project, '/projects/${project.id}/reports');
  }

  /// Método común para navegar a submódulos de proyectos
  void _navigateToProjectSubmenu(ProjectModel project, String route) {
    // Establecer el proyecto actual en el ProjectContextService
    _projectContextService.setCurrentProject(project);

    // Establecer el proyecto actual en el controlador de sidebar
    _sidebarController.setCurrentProject(project);

    // Navegar a la ruta del submódulo sin necesidad de pasar argumentos
    Get.toNamed(route);
  }

  /// Muestra un menú de opciones para un proyecto
  void showProjectOptions(BuildContext context, ProjectModel project) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.dashboard_customize),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
                navigateToProjectDashboard(project);
              },
            ),
            ListTile(
              leading: const Icon(Icons.event_note),
              title: const Text('Actividades'),
              onTap: () {
                Navigator.pop(context);
                navigateToProjectActivities(project);
              },
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Documentos'),
              onTap: () {
                Navigator.pop(context);
                navigateToProjectDocuments(project);
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text('Reportes'),
              onTap: () {
                Navigator.pop(context);
                navigateToProjectReports(project);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Editar proyecto'),
              onTap: () {
                Navigator.pop(context);
                showEditProjectDialog(project.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
