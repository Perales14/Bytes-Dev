import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/project_model.dart';
import '../../../data/models/address_model.dart';
import '../../../data/models/client_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/provider_model.dart';
import '../../../data/services/project_service.dart';
import '../../../data/services/address_service.dart';
import '../../../data/services/client_service.dart';
import '../../../data/services/user_service.dart';
import '../../../data/services/provider_service.dart';
import '../../../shared/controllers/base_form_controller.dart';
import '../../../shared/validators/validators.dart' as validators;
import 'projects_controller.dart';
import '../../../data/services/session_service.dart';

class ProjectFormController extends BaseFormController {
  final isLoading = false.obs;
  final ProjectService _projectService = Get.find<ProjectService>();
  final AddressService _addressService = Get.find<AddressService>();
  final ClientService _clientService = Get.find<ClientService>();
  final UserService _userService = Get.find<UserService>();
  final ProviderService _providerService = Get.find<ProviderService>();
  final SessionService _sessionService = Get.find<SessionService>();

  final Rx<ProjectModel> project = ProjectModel(
    name: '',
    clientId: 0,
    managerId: 0,
    stateId: 1,
  ).obs;

  late AddressModel address;
  final showAddress = false.obs;

  // Lists for dropdowns
  final RxList<ClientModel> clients = <ClientModel>[].obs;
  final RxList<UserModel> managers = <UserModel>[].obs;
  final RxList<ProviderModel> providers = <ProviderModel>[].obs;

  // Form controllers
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final estimatedBudgetController = TextEditingController();
  final commissionController = TextEditingController();

  // Address controllers
  final streetController = TextEditingController();
  final streetNumberController = TextEditingController();
  final neighborhoodController = TextEditingController();
  final postalCodeController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();

  final startDate = Rxn<DateTime>();
  final estimatedEndDate = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    _loadDropdownData();
  }

  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }

  void _initializeControllers() {
    nameController.text = project.value.name;
    descriptionController.text = project.value.description ?? '';
    estimatedBudgetController.text =
        project.value.estimatedBudget?.toString() ?? '';
    commissionController.text =
        project.value.commissionPercentage?.toString() ?? '';

    // Initialize address
    address = AddressModel(
      street: '',
      streetNumber: '',
      neighborhood: '',
      postalCode: '',
      state: '',
      country: 'México',
    );

    // Initialize address controllers
    streetController.text = address.street;
    streetNumberController.text = address.streetNumber;
    neighborhoodController.text = address.neighborhood;
    postalCodeController.text = address.postalCode;
    stateController.text = address.state ?? '';
    countryController.text = address.country ?? 'México';
  }

  void _disposeControllers() {
    nameController.dispose();
    descriptionController.dispose();
    estimatedBudgetController.dispose();
    commissionController.dispose();
    streetController.dispose();
    streetNumberController.dispose();
    neighborhoodController.dispose();
    postalCodeController.dispose();
    stateController.dispose();
    countryController.dispose();
  }

  Future<void> _loadDropdownData() async {
    try {
      isLoading(true);
      print('Loading dropdown data...');
      final clientsList = await _clientService.getAllClients();
      final managersList =
          await _userService.getActiveEmployees(); // getAllUsers();
      final providersList = await _providerService.getAllProviders();
      print('clientes ${clientsList.map((e) => e.name)}');
      print('managers ${managersList.map((e) => e.name)}');
      print('providers ${providersList.map((e) => e.companyName)}');
      // print('managers $managersList');
      // print('providers $providersList');
      clients.assignAll(clientsList);
      managers.assignAll(managersList);
      providers.assignAll(providersList);

      // Si es promotor, pre-selecciona su ID como manager
      if (_sessionService.hasRole(SessionService.ROLE_PROMOTOR) &&
          _sessionService.currentUser != null) {
        final currentUser = _sessionService.currentUser!;
        project.update((val) {
          val?.managerId = currentUser.id;
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al cargar datos: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  void loadProject(ProjectModel model) {
    isLoading(true);
    project.value = model;
    _initializeControllers();

    if (model.addressId != null) {
      loadAddress(model.addressId!);
      showAddress.value = true;
    }

    startDate.value = model.startDate;
    estimatedEndDate.value = model.estimatedEndDate;
    isLoading(false);
  }

  Future<void> loadAddress(int addressId) async {
    try {
      final addressModel = await _addressService.getAddressById(addressId);
      if (addressModel != null) {
        address = addressModel;
        streetController.text = address.street;
        streetNumberController.text = address.streetNumber;
        neighborhoodController.text = address.neighborhood;
        postalCodeController.text = address.postalCode;
        stateController.text = address.state ?? '';
        countryController.text = address.country ?? '';
      }
    } catch (e) {
      // Silent error handling
    }
  }

  void updateProject({
    String? name,
    String? description,
    int? clientId,
    int? managerId,
    int? providerId,
    DateTime? startDate,
    DateTime? estimatedEndDate,
    double? estimatedBudget,
    double? commissionPercentage,
    int? addressId,
  }) {
    project.update((val) {
      // print('Updating project: $startDate');
      if (val != null) {
        if (name != null) {
          val.name = name;
          project.value.name = name;
        }
        if (description != null) {
          val.description = description;
          project.value.description = description;
        }
        if (clientId != null) {
          val.clientId = clientId;
          project.value.clientId = clientId;
        }
        if (managerId != null) {
          val.managerId = managerId;
          project.value.managerId = managerId;
        }
        if (providerId != null) {
          val.providerId = providerId;
          project.value.providerId = providerId;
        }
        if (startDate != null) {
          val.startDate = startDate;
          project.value.startDate = startDate;
          this.startDate.value = startDate;
        }
        if (estimatedEndDate != null) {
          val.estimatedEndDate = estimatedEndDate;
          project.value.estimatedEndDate = estimatedEndDate;
          this.estimatedEndDate.value = estimatedEndDate;
        }
        if (estimatedBudget != null) {
          val.estimatedBudget = estimatedBudget;
          project.value.estimatedBudget = estimatedBudget;
        }
        if (commissionPercentage != null) {
          val.commissionPercentage = commissionPercentage;
          project.value.commissionPercentage = commissionPercentage;
        }
        if (addressId != null) {
          val.addressId = addressId;
          project.value.addressId = addressId;
        }
      }
    });
    // print('FECHA: ');
    // print(project.value.startDate);
  }

  void updateAddress({
    String? street,
    String? streetNumber,
    String? neighborhood,
    String? postalCode,
    String? state,
    String? country,
  }) {
    try {
      address = AddressModel(
        id: address.id,
        street: street ?? address.street,
        streetNumber: streetNumber ?? address.streetNumber,
        neighborhood: neighborhood ?? address.neighborhood,
        postalCode: postalCode ?? address.postalCode,
        state: state ?? address.state,
        country: country ?? address.country,
        createdAt: address.createdAt,
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      // Silent error handling
    }
  }

  void toggleAddress() {
    showAddress.toggle();
  }

  // Validations
  String? validateName(String? value) => validators.validateRequired(value);
  String? validateClientId(String? value) => validators.validateRequired(value);
  String? validateManagerId(String? value) =>
      validators.validateRequired(value);
  String? validatePostalCode(String? value) {
    if (showAddress.value && (value == null || value.isEmpty)) {
      return 'Código Postal Requerido';
    }

    if (showAddress.value && value != null && value.isNotEmpty) {
      if (!RegExp(r'^\d{5}$').hasMatch(value)) {
        return 'Código Postal Inválido';
      }
    }
    return null;
  }

  bool _validateForm() {
    if (!formKey.currentState!.validate()) return false;

    if (startDate.value == null) {
      Get.snackbar('Error', 'La fecha de inicio es requerida');
      return false;
    }

    return true;
  }

  //cambio de starDate a startDate
  // void onStartDateChanged(DateTime? date) {
  //   if (date != null) {
  //     startDate.value = date;
  //     updateProject(startDate: date);
  //   }
  // }

  // //cambio del estimatedEndDate a estimatedEndDate
  // void onEstimatedEndDateChanged(DateTime? date) {
  //   if (date != null) {
  //     estimatedEndDate.value = date;
  //     updateProject(estimatedEndDate: date);
  //   }
  // }

  bool _validateAddress() {
    if (!showAddress.value) return true;

    if (address.street.isEmpty) {
      Get.snackbar('Error', 'La calle es requerida',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    if (address.streetNumber.isEmpty) {
      Get.snackbar('Error', 'El número es requerido',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    if (address.neighborhood.isEmpty) {
      Get.snackbar('Error', 'La colonia es requerida',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    if (address.postalCode.isEmpty) {
      Get.snackbar('Error', 'El código postal es requerido',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    if (!RegExp(r'^\d{5}$').hasMatch(address.postalCode)) {
      Get.snackbar('Error', 'Formato de código postal inválido (5 dígitos)',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    return true;
  }

  void prepareModelForSave() {
    final currentId = project.value.id;
    final currentCreatedAt = project.value.createdAt;
    final currentStateId = project.value.stateId;

    project.value = ProjectModel(
      id: currentId,
      name: nameController.text,
      description: descriptionController.text.isEmpty
          ? null
          : descriptionController.text,
      clientId: project.value.clientId,
      managerId: project.value.managerId,
      providerId: project.value.providerId,
      startDate: startDate.value,
      estimatedEndDate: estimatedEndDate.value,
      estimatedBudget: double.tryParse(estimatedBudgetController.text),
      commissionPercentage: double.tryParse(commissionController.text),
      addressId: project.value.addressId,
      stateId: currentStateId,
      createdAt: currentCreatedAt,
      updatedAt: DateTime.now(),
    );

    if (showAddress.value) {
      address = AddressModel(
        id: address.id,
        street: streetController.text,
        streetNumber: streetNumberController.text,
        neighborhood: neighborhoodController.text,
        postalCode: postalCodeController.text,
        state: stateController.text.isEmpty ? null : stateController.text,
        country: countryController.text.isEmpty ? null : countryController.text,
        createdAt: address.createdAt,
        updatedAt: DateTime.now(),
      );
    }
  }

  @override
  void resetForm() {
    formKey.currentState?.reset();
    project.value = ProjectModel(
      name: '',
      clientId: 0,
      managerId: 0,
      stateId: 1,
    );
    address = AddressModel(
      street: '',
      streetNumber: '',
      neighborhood: '',
      postalCode: '',
      state: '',
      country: 'México',
    );
    showAddress.value = false;
    startDate.value = null;
    estimatedEndDate.value = null;
    _initializeControllers();
  }

  @override
  bool submitForm() {
    if (!_validateForm()) return false;

    try {
      prepareModelForSave();
      _handleSubmit();
      refresh();
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al guardar: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  Future<bool> _handleSubmit() async {
    try {
      isLoading(true);

      int? addressId;
      if (showAddress.value && _validateAddress()) {
        final savedAddress = address.id > 0
            ? await _addressService.updateAddress(address)
            : await _addressService.createAddress(address);

        if (savedAddress.id > 0) {
          addressId = savedAddress.id;
          project.value = project.value.copyWith(addressId: addressId);
        } else {
          Get.snackbar(
            'Error',
            'Error al guardar dirección',
            snackPosition: SnackPosition.BOTTOM,
          );
          return false;
        }
      }
      if (project.value.clientId == 0) {
        Get.snackbar(
          'Error',
          'El cliente es requerido',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
      final savedProject = project.value.id > 0
          ? await _projectService.updateProject(project.value)
          : await _projectService.createProject(project.value);

      if (savedProject.id > 0) {
        if (files.isNotEmpty) {
          project.value.id = savedProject.id;
          final uploadedFiles =
              await uploadFilesToSupabase(files, project.value.id.toString());
          if (uploadedFiles.isNotEmpty) {
            await saveFileReferences(
                uploadedFiles, project.value.id, 'project');
          }
        }
        Get.snackbar(
          'Éxito',
          'Proyecto guardado correctamente',
          snackPosition: SnackPosition.BOTTOM,
        );
        // resetForm();
        // Get.back(result: true);
        // Refresh the project list
        Get.find<ProjectsController>().refreshData();

        // final projectsview = Get.find<ProjectsView>();
        // projectsview.controller.refreshData();
        // project.refresh();

        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al guardar el proyecto: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading(false);
    }
  }
}
