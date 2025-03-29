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
  // SERVICIOS
  final ProviderService _providerService = Get.find<ProviderService>();
  final AddressService _addressService = Get.find<AddressService>();
  final SpecialtyService _specialtyService = Get.find<SpecialtyService>();
  final ObservationService _observationService = Get.find<ObservationService>();

  // MODELOS REACTIVOS
  final Rx<ProviderModel> provider = ProviderModel(
    specialtyId: 1,
    companyName: '',
    stateId: 1,
  ).obs;

  late AddressModel address;
  final showAddress = false.obs;
  final observationText = ''.obs;

  // CONTROLADORES DE FORMULARIO
  final companyNameController = TextEditingController();
  final mainContactController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final taxIdController = TextEditingController();

  // CONTROLADORES DE DIRECCIÓN
  final streetController = TextEditingController();
  final streetNumberController = TextEditingController();
  final neighborhoodController = TextEditingController();
  final postalCodeController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();

  // LISTAS DE OPCIONES
  final RxList<SpecialtyModel> specialties = <SpecialtyModel>[].obs;
  final serviceTypes = ['Suministros', 'Mantenimiento'].obs;
  final paymentTerms =
      ['Contado', '1 Mes', '3 Meses', '6 Meses', '12 Meses'].obs;

  // ESTADOS
  final isLoadingSpecialties = true.obs;
  final hasErrorSpecialties = false.obs;

  // CICLO DE VIDA
  @override
  void onInit() {
    super.onInit();
    _initializeProvider();
    _loadSpecialties();
  }

  @override
  void onClose() {
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

  // MÉTODOS DE INICIALIZACIÓN
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
      stateId: 1,
    );

    // Inicializar controladores
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

    // Inicializar controladores de dirección
    streetController.text = address.street;
    streetNumberController.text = address.streetNumber;
    neighborhoodController.text = address.neighborhood;
    postalCodeController.text = address.postalCode;
    stateController.text = address.state ?? '';
    countryController.text = address.country ?? 'México';

    observationText.value = '';
  }

  // MÉTODOS DE CARGA DE DATOS
  Future<void> _loadSpecialties() async {
    try {
      isLoadingSpecialties(true);
      hasErrorSpecialties(false);

      final result = await _specialtyService.getAllSpecialties();

      if (result.isEmpty) {
        specialties.add(SpecialtyModel(
          id: 1,
          name: 'General',
          description: 'Especialidad predeterminada',
        ));
      } else {
        specialties.assignAll(result);
      }

      if (provider.value.id == 0 && specialties.isNotEmpty) {
        updateProvider(specialtyId: specialties.first.id);
      }
    } catch (e) {
      hasErrorSpecialties(true);
      specialties.add(SpecialtyModel(
        id: 1,
        name: 'General',
        description: 'Especialidad predeterminada',
      ));
    } finally {
      isLoadingSpecialties(false);
    }
  }

  Future<void> _loadSpecificSpecialty(int specialtyId) async {
    try {
      final specialty = await _specialtyService.getSpecialtyById(specialtyId);
      if (specialty != null && !specialties.any((s) => s.id == specialty.id)) {
        specialties.add(specialty);
      }
    } catch (e) {
      // Manejo silencioso de errores
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
      // Manejo silencioso de errores
    }
  }

  // MÉTODOS DE ESPECIALIDAD
  SpecialtyModel? getCurrentSpecialty() {
    try {
      if (specialties.isEmpty) return null;

      return specialties.firstWhere(
        (e) => e.id == provider.value.specialtyId,
        orElse: () => specialties.first,
      );
    } catch (e) {
      return null;
    }
  }

  // MÉTODOS DE ACTUALIZACIÓN DE MODELOS
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
      // Manejo silencioso de errores
    }
  }

  void updateObservation(String value) {
    observationText.value = value;
  }

  void toggleAddress() {
    showAddress.toggle();
  }

  // MÉTODOS DE CARGA DE MODELOS
  void loadProvider(ProviderModel model) {
    // Usar copyWith para preservar valores incluido el ID
    provider.value = model.copyWith();

    // Cargar datos en controladores de texto
    companyNameController.text = model.companyName;
    mainContactController.text = model.mainContactName ?? '';
    phoneController.text = model.phoneNumber ?? '';
    emailController.text = model.email ?? '';
    taxIdController.text = model.taxIdentificationNumber ?? '';

    // Añadir valores a listas si no existen
    if (model.serviceType != null &&
        !serviceTypes.contains(model.serviceType)) {
      serviceTypes.add(model.serviceType!);
    }

    if (model.paymentTerms != null &&
        !paymentTerms.contains(model.paymentTerms)) {
      paymentTerms.add(model.paymentTerms!);
    }

    // Cargar especialidad si no existe
    if (model.specialtyId > 0 &&
        specialties.every((s) => s.id != model.specialtyId)) {
      _loadSpecificSpecialty(model.specialtyId);
    }

    // Cargar dirección si existe
    if (model.addressId != null) {
      loadAddress(model.addressId!);
      showAddress.value = true;
    } else {
      address = AddressModel(
        street: '',
        streetNumber: '',
        neighborhood: '',
        postalCode: '',
        state: '',
        country: 'México',
      );
      showAddress.value = false;
    }

    update();
  }

  // MÉTODOS DE PREPARACIÓN DE MODELOS
  void prepareModelForSave() {
    final currentId = provider.value.id;
    final currentCreatedAt = provider.value.createdAt;
    final currentStateId = provider.value.stateId;

    final updatedProvider = ProviderModel(
      id: currentId, // Preservar ID original
      specialtyId: provider.value.specialtyId,
      companyName: companyNameController.text,
      mainContactName: mainContactController.text.isEmpty
          ? null
          : mainContactController.text,
      phoneNumber: phoneController.text.isEmpty ? null : phoneController.text,
      email: emailController.text.isEmpty ? null : emailController.text,
      taxIdentificationNumber:
          taxIdController.text.isEmpty ? null : taxIdController.text,
      serviceType: provider.value.serviceType,
      paymentTerms: provider.value.paymentTerms,
      addressId: provider.value.addressId,
      stateId: currentStateId,
      createdAt: currentCreatedAt,
      updatedAt: DateTime.now(),
    );

    provider.value = updatedProvider;

    // Actualizar modelo de dirección
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

  // MÉTODOS DE VALIDACIÓN
  String? validateTaxId(String? value) {
    if (value == null || value.isEmpty) return null;

    final taxIdRegExp = RegExp(
        r'^([A-ZÑ&]{3,4})(\d{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[12]\d|3[01]))([A-Z\d]{2})([A\d])$');
    if (!taxIdRegExp.hasMatch(value)) {
      return 'RFC Inválido';
    }
    return null;
  }

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

  String? validateServiceType(String? value) {
    return validateInList(value, serviceTypes, fieldName: 'tipo de servicio');
  }

  String? validatePaymentTerms(String? value) {
    return validateInList(value, paymentTerms, fieldName: 'términos de pago');
  }

  bool _validateForm() {
    if (!formKey.currentState!.validate()) return false;

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

  // MÉTODOS DE FORMULARIO
  @override
  bool submitForm() {
    if (_validateForm()) {
      try {
        final int originalId = provider.value.id;

        prepareModelForSave();

        ProviderModel providerToSave = provider.value;

        if (originalId > 0 && providerToSave.id != originalId) {
          providerToSave = providerToSave.copyWith(id: originalId);
        }

        Future.delayed(Duration.zero, () {
          saveProviderWithDataWithModel(providerToSave);
        });

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
    return false;
  }

  @override
  void resetForm() {
    formKey.currentState?.reset();

    // Limpiar controladores
    companyNameController.clear();
    mainContactController.clear();
    phoneController.clear();
    emailController.clear();
    taxIdController.clear();
    streetController.clear();
    streetNumberController.clear();
    neighborhoodController.clear();
    postalCodeController.clear();
    stateController.clear();
    countryController.clear();

    // Restablecer listas predefinidas
    serviceTypes.value = ['Suministros', 'Mantenimiento'];
    paymentTerms.value = ['Contado', '1 Mes', '3 Meses', '6 Meses', '12 Meses'];

    // Reinicializar modelos
    provider.value = ProviderModel(
      specialtyId: specialties.isNotEmpty ? specialties.first.id : 1,
      companyName: '',
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
    observationText.value = '';
    update();
  }

  // MÉTODOS DE GUARDADO
  Future<bool> saveProviderWithDataWithModel(
      ProviderModel providerToSave) async {
    try {
      int? addressId;
      final bool isEditing = providerToSave.id > 0;

      // 1. Guardar dirección si está habilitada
      if (showAddress.value) {
        if (_validateAddress()) {
          try {
            final savedAddress = address.id > 0
                ? await _addressService.updateAddress(address)
                : await _addressService.createAddress(address);

            if (savedAddress.id > 0) {
              addressId = savedAddress.id;
              providerToSave = providerToSave.copyWith(addressId: addressId);
            } else {
              Get.snackbar(
                'Error',
                'Error al guardar dirección',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Get.theme.colorScheme.errorContainer,
                colorText: Get.theme.colorScheme.onErrorContainer,
              );
              return false;
            }
          } catch (e) {
            Get.snackbar(
              'Error',
              'Error al guardar dirección: $e',
              snackPosition: SnackPosition.BOTTOM,
            );
            return false;
          }
        } else {
          return false;
        }
      } else if (providerToSave.addressId != null) {
        // Si se desactivó la dirección pero antes existía, desasociarla
        providerToSave = providerToSave.copyWith(addressId: null);
      }

      // 2. Guardar el proveedor
      ProviderModel savedProvider;
      if (isEditing) {
        savedProvider = await _providerService.updateProvider(providerToSave);
      } else {
        savedProvider = await _providerService.createProvider(providerToSave);
      }

      // 3. Mostrar mensaje de éxito
      Get.snackbar(
        'Éxito',
        isEditing
            ? 'Proveedor actualizado correctamente'
            : 'Proveedor creado correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );

      // 4. Guardar observación si existe
      if (observationText.value.trim().isNotEmpty) {
        try {
          await _observationService.addQuickObservation(
            sourceTable: 'providers',
            sourceId: savedProvider.id,
            text: observationText.value.trim(),
            userId: 1,
          );
        } catch (e) {
          Get.snackbar(
            'Advertencia',
            'Proveedor guardado pero hubo un error con la observación',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }

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
}
