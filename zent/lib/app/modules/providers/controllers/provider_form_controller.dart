import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/address_model.dart';
import '../../../data/models/specialty_model.dart';
import '../../../data/models/provider_model.dart';
import '../../../data/services/provider_service.dart';
import '../../../data/services/address_service.dart';
import '../../../data/services/specialty_service.dart';
import '../../../data/services/observation_service.dart';
import '../../../shared/controllers/base_form_controller.dart';
import '../../../shared/validators/validators.dart';

class ProviderFormController extends BaseFormController {
  // Services
  final ProviderService _providerService = Get.find<ProviderService>();
  final AddressService _addressService = Get.find<AddressService>();
  final SpecialtyService _specialtyService = Get.find<SpecialtyService>();
  final ObservationService _observationService = Get.find<ObservationService>();

  // Models
  final Rx<ProviderModel> provider = ProviderModel(
    specialtyId: 1, // Default value, should be updated
    companyName: '',
    stateId: 1, // Active by default
  ).obs;

  late AddressModel address;

  // UI control
  final showAddress = false.obs;
  final observationText = ''.obs;

  // Text controllers
  final companyNameController = TextEditingController();
  final mainContactController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final taxIdController = TextEditingController();

  // Address controllers
  final streetController = TextEditingController();
  final streetNumberController = TextEditingController();
  final neighborhoodController = TextEditingController();
  final postalCodeController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();

  // Dropdown lists
  final RxList<SpecialtyModel> specialties = <SpecialtyModel>[].obs;
  final serviceTypes = [
    'Suministros',
    'Mantenimiento',
  ].obs;
  final paymentTerms =
      ['Contado', '1 Mes', '3 Meses', '6 Meses', '12 Meses'].obs;

  // Loading states
  final isLoadingSpecialties = true.obs;
  final hasErrorSpecialties = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeProvider();
    _loadSpecialties();
  }

  @override
  void onClose() {
    // Release controller resources
    companyNameController.dispose();
    mainContactController.dispose();
    phoneController.dispose();
    emailController.dispose();
    taxIdController.dispose();
    streetController.dispose();
    streetNumberController.dispose();
    neighborhoodController.dispose();
    postalCodeController.dispose();
    stateController.dispose();
    countryController.dispose();
    super.onClose();
  }

  // Initialize models with default values
  void _initializeProvider() {
    provider.value = ProviderModel(
      specialtyId: specialties.isNotEmpty ? specialties.first.id : 1,
      companyName: '',
      mainContactName: '',
      phoneNumber: '',
      email: '',
      taxIdentificationNumber: '',
      serviceType: serviceTypes.isNotEmpty ? serviceTypes[0] : null,
      paymentTerms: paymentTerms.isNotEmpty ? paymentTerms[0] : null,
      addressId: null,
      stateId: 1, // Active by default
    );

    // Initialize controllers with initial values
    companyNameController.text = provider.value.companyName;
    mainContactController.text = provider.value.mainContactName ?? '';
    phoneController.text = provider.value.phoneNumber ?? '';
    emailController.text = provider.value.email ?? '';
    taxIdController.text = provider.value.taxIdentificationNumber ?? '';

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

    observationText.value = '';
  }

  Future<void> _loadSpecialties() async {
    try {
      isLoadingSpecialties(true);
      hasErrorSpecialties(false);

      final result = await _specialtyService.getAllSpecialties();
      if (kDebugMode) {
        print('Especialidades cargadas: ${result.length}');
      }

      // Add default specialty if none exist
      if (result.isEmpty) {
        specialties.add(SpecialtyModel(
          id: 1,
          name: 'General',
          description: 'Especialidad predeterminada',
        ));
      } else {
        specialties.assignAll(result);
      }

      // Update model if needed
      if (provider.value.id == 0 && specialties.isNotEmpty) {
        updateProvider(specialtyId: specialties.first.id);
      }
    } catch (e) {
      hasErrorSpecialties(true);
      if (kDebugMode) {
        print('Error al cargar especialidades: $e');
      }

      // Add default specialty as fallback
      specialties.add(SpecialtyModel(
        id: 1,
        name: 'General',
        description: 'Especialidad predeterminada',
      ));
    } finally {
      isLoadingSpecialties(false);
    }
  }

  // Get current specialty by ID
  SpecialtyModel? getCurrentSpecialty() {
    try {
      return specialties.firstWhere(
        (e) => e.id == provider.value.specialtyId,
      );
    } catch (e) {
      // If not found, return first or null
      return specialties.isNotEmpty ? specialties.first : null;
    }
  }

  // Update provider data
  void updateProvider({
    int? specialtyId,
    String? companyName,
    String? mainContactName,
    String? phoneNumber,
    String? email,
    String? taxId,
    String? serviceType,
    String? paymentTerms,
    int? addressId,
    int? stateId,
  }) {
    provider.update((val) {
      if (val != null) {
        if (specialtyId != null) val.specialtyId = specialtyId;
        if (companyName != null) val.companyName = companyName;
        if (mainContactName != null) val.mainContactName = mainContactName;
        if (phoneNumber != null) val.phoneNumber = phoneNumber;
        if (email != null) val.email = email;
        if (taxId != null) val.taxIdentificationNumber = taxId;
        if (serviceType != null) val.serviceType = serviceType;
        if (paymentTerms != null) val.paymentTerms = paymentTerms;
        if (addressId != null) val.addressId = addressId;
        if (stateId != null) val.stateId = stateId;
      }
    });
  }

  // Update address
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
      if (kDebugMode) {
        print("Error al actualizar dirección: $e");
      }
    }
  }

  // Toggle address visibility
  void toggleAddress() {
    showAddress.toggle();
  }

  // Update observation text
  void updateObservation(String value) {
    observationText.value = value;
  }

  // Prepare model for saving
  void prepareModelForSave() {
    provider.update((val) {
      if (val != null) {
        val.companyName = companyNameController.text;
        val.mainContactName = mainContactController.text.isEmpty
            ? null
            : mainContactController.text;
        val.phoneNumber =
            phoneController.text.isEmpty ? null : phoneController.text;
        val.email = emailController.text.isEmpty ? null : emailController.text;
        val.taxIdentificationNumber =
            taxIdController.text.isEmpty ? null : taxIdController.text;
      }
    });

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

  void loadProvider(ProviderModel model) {
    provider.value = model;

    companyNameController.text = model.companyName;
    mainContactController.text = model.mainContactName ?? '';
    phoneController.text = model.phoneNumber ?? '';
    emailController.text = model.email ?? '';
    taxIdController.text = model.taxIdentificationNumber ?? '';

    if (model.serviceType != null &&
        !serviceTypes.contains(model.serviceType)) {
      serviceTypes.add(model.serviceType!);
    }

    if (model.paymentTerms != null &&
        !paymentTerms.contains(model.paymentTerms)) {
      paymentTerms.add(model.paymentTerms!);
    }

    if (model.specialtyId > 0 &&
        specialties.every((s) => s.id != model.specialtyId)) {
      _loadSpecificSpecialty(model.specialtyId);
    }

    if (model.addressId != null) {
      loadAddress(model.addressId!);
      showAddress.value = true;
    }

    update();
  }

  Future<void> _loadSpecificSpecialty(int specialtyId) async {
    try {
      final specialty = await _specialtyService.getSpecialtyById(specialtyId);
      if (specialty != null && !specialties.any((s) => s.id == specialty.id)) {
        specialties.add(specialty);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al cargar esoecialidad especifica: $e');
      }
    }
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
      if (kDebugMode) {
        print('Error al cargar dirección: $e');
      }
    }
  }

  // Validate tax ID
  String? validateTaxId(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Tax ID is optional
    }

    // RegEx to validate tax ID
    final taxIdRegExp = RegExp(
        r'^([A-ZÑ&]{3,4})(\d{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[12]\d|3[01]))([A-Z\d]{2})([A\d])$');
    if (!taxIdRegExp.hasMatch(value)) {
      return 'RFC Inválido';
    }
    return null;
  }

  // Validate postal code
  String? validatePostalCode(String? value) {
    if (showAddress.value && (value == null || value.isEmpty)) {
      return 'Código Postal Requerido';
    }

    if (showAddress.value && value != null && value.isNotEmpty) {
      // Validate postal code format (5 digits in Mexico)
      if (!RegExp(r'^\d{5}$').hasMatch(value)) {
        return 'Código Postal Inválido';
      }
    }
    return null;
  }

  String? validateServiceType(String? value) {
    return validateInList(value, serviceTypes, fieldName: 'tipo de servicio');
  }

  String? validatePaymentTerms(String? value) {
    return validateInList(value, paymentTerms, fieldName: 'términos de pago');
  }

  bool _validateForm() {
    // Validate all form fields
    if (!formKey.currentState!.validate()) {
      return false;
    }

    if (provider.value.companyName.isEmpty) {
      Get.snackbar(
        'Error de validación',
        'El nombre de la empresa es requerido',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }

  // Validate address
  bool _validateAddress() {
    if (!showAddress.value) return true;

    if (address.street.isEmpty) {
      Get.snackbar('Error', 'La calle es requerida');
      return false;
    }

    if (address.streetNumber.isEmpty) {
      Get.snackbar('Error', 'El número es requerido');
      return false;
    }

    if (address.neighborhood.isEmpty) {
      Get.snackbar('Error', 'La colonia es requerida');
      return false;
    }

    if (address.postalCode.isEmpty) {
      Get.snackbar('Error', 'El código postal es requerido');
      return false;
    }

    // Validate postal code format
    if (!RegExp(r'^\d{5}$').hasMatch(address.postalCode)) {
      Get.snackbar('Error', 'Formato de código postal inválido (5 dígitos)');
      return false;
    }

    return true;
  }

  @override
  bool submitForm() {
    if (_validateForm()) {
      try {
        prepareModelForSave(); // Prepare model before saving
        saveProviderWithData();
        return true;
      } catch (e) {
        Get.snackbar(
          'Error',
          'Error al guardar proveedor: $e',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    }
    return false;
  }

  @override
  void resetForm() {
    formKey.currentState?.reset();
    _initializeProvider();
    showAddress.value = false;
  }

  Future<bool> saveProviderWithData() async {
    try {
      int? addressId;

      // 1. If address is active, save it first
      if (showAddress.value) {
        if (_validateAddress()) {
          final savedAddress = await _addressService.createAddress(address);
          if (savedAddress.id > 0) {
            addressId = savedAddress.id;
          } else {
            Get.snackbar(
              'Error',
              'No se pudo guardar la dirección',
              snackPosition: SnackPosition.BOTTOM,
            );
            return false;
          }
        } else {
          return false;
        }
      }

      // 2. Update provider with address ID if exists
      if (addressId != null) {
        provider.update((val) {
          if (val != null) val.addressId = addressId;
        });
      }

      // 3. Save the provider
      final savedProvider =
          await _providerService.createProvider(provider.value);

      if (savedProvider.id <= 0) {
        Get.snackbar(
          'Error',
          'No se pudo guardar el proveedor',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }

      // 4. If there's an observation, save it
      if (observationText.value.trim().isNotEmpty) {
        await _observationService.addQuickObservation(
          sourceTable: 'providers',
          sourceId: savedProvider.id,
          text: observationText.value.trim(),
          userId: 1, // Default user ID, should be updated to current user
        );
      }

      Get.snackbar(
        'Éxito',
        'Proveedor guardado correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al guardar: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return false;
    }
  }
}
