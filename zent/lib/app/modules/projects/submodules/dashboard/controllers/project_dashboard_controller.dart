import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../data/models/project_model.dart';
import '../../../../../data/models/address_model.dart';
import '../../../../../data/models/client_model.dart';
import '../../../../../data/models/user_model.dart';
import '../../../../../data/models/provider_model.dart';
import '../../../../../data/services/project_service.dart';
import '../../../../../data/services/project_context_service.dart';
import '../../../../../data/services/address_service.dart';
import '../../../../../data/services/client_service.dart';
import '../../../../../data/services/user_service.dart';
import '../../../../../data/services/provider_service.dart';

class ProjectDashboardController extends GetxController {
  final ProjectService projectService;
  final ProjectContextService projectContextService;
  final AddressService addressService = Get.find<AddressService>();
  final ClientService clientService = Get.find<ClientService>();
  final UserService userService = Get.find<UserService>();
  final ProviderService providerService = Get.find<ProviderService>();

  // Mantener el proyecto como observable
  final Rx<ProjectModel?> _project = Rx<ProjectModel?>(null);

  // Propiedades para información relacionada
  final Rx<AddressModel?> address = Rx<AddressModel?>(null);
  final Rx<ClientModel?> client = Rx<ClientModel?>(null);
  final Rx<UserModel?> manager = Rx<UserModel?>(null);
  final Rx<ProviderModel?> provider = Rx<ProviderModel?>(null);

  // Variables para estado de la UI
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // Getters
  ProjectModel? get project => _project.value;

  ProjectDashboardController({
    required this.projectService,
    required this.projectContextService,
  });

  @override
  void onInit() {
    super.onInit();
    _loadProjectData();
  }

  @override
  void onClose() {
    // Limpieza adicional si es necesaria
    super.onClose();
  }

  Future<void> _loadProjectData() async {
    try {
      isLoading(true);
      hasError(false);

      // Intentar obtener el proyecto del contexto
      ProjectModel? contextProject = projectContextService.currentProject;

      // Si no hay proyecto en el contexto, intentar obtenerlo de la ruta
      if (contextProject == null) {
        final String currentRoute = Get.currentRoute;
        final RegExp regex = RegExp(r'/projects/(\d+)/');
        final match = regex.firstMatch(currentRoute);

        if (match != null && match.groupCount >= 1) {
          final String projectIdStr = match.group(1)!;
          final int projectId = int.tryParse(projectIdStr) ?? 0;

          if (projectId > 0) {
            // Cargar el proyecto desde el servicio
            contextProject = await projectService.getProjectById(projectId);

            // Actualizar el contexto con este proyecto
            if (contextProject != null) {
              projectContextService.setCurrentProject(contextProject);
            }
          }
        }
      }

      // Verificar si tenemos un proyecto válido
      if (contextProject != null) {
        _project.value = contextProject;

        // Cargar información relacionada
        await _loadRelatedData();
      } else {
        // No se pudo cargar el proyecto
        hasError(true);
        errorMessage('No se pudo obtener el proyecto actual.');
        _showErrorAndNavigateBack();
      }
    } catch (e) {
      hasError(true);
      errorMessage('Error al cargar datos del proyecto: $e');
      _showErrorAndNavigateBack();
    } finally {
      isLoading(false);
    }
  }

  /// Carga la información relacionada del proyecto (cliente, responsable, proveedor, dirección)
  Future<void> _loadRelatedData() async {
    if (_project.value == null) return;

    try {
      // Cargar cliente
      if (_project.value!.clientId > 0) {
        client.value =
            await clientService.getClientById(_project.value!.clientId);
      }

      // Cargar responsable
      if (_project.value!.managerId > 0) {
        manager.value =
            await userService.getUserById(_project.value!.managerId);
      }

      // Cargar proveedor
      if (_project.value!.providerId != null &&
          _project.value!.providerId! > 0) {
        provider.value =
            await providerService.getProviderById(_project.value!.providerId!);
      }

      // Cargar dirección
      if (_project.value!.addressId != null && _project.value!.addressId! > 0) {
        address.value =
            await addressService.getAddressById(_project.value!.addressId!);
      }
    } catch (e) {
      print('Error cargando datos relacionados: $e');
      // No marcamos como error crítico, solo registramos
    }
  }

  void _showErrorAndNavigateBack() {
    // Mostrar error y regresar a la lista de proyectos
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        duration: const Duration(seconds: 3),
      );

      // Regresar a la lista de proyectos después de mostrar el error
      Future.delayed(const Duration(seconds: 2), () {
        Get.offNamed('/projects');
      });
    });
  }

  void refreshData() {
    _loadProjectData();
  }

  void navigateBack() {
    // Limpiar el proyecto actual al salir
    projectContextService.clearCurrentProject();

    // Navegar a la vista de proyectos
    Get.offNamed('/projects');
  }
}
