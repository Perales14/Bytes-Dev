import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zent/controllers/base_form_controller.dart';

/// Controller for the client registration form
class ClientFormController extends BaseFormController {
  // Client data
  final nombreEmpresa = ''.obs;
  final cargo = ''.obs;
  final calle = ''.obs;
  final colonia = ''.obs;
  final cp = ''.obs;
  final nombre = ''.obs;
  final apellidoPaterno = ''.obs;
  final apellidoMaterno = ''.obs;
  final correo = ''.obs;
  final telefono = ''.obs;
  final rfc = ''.obs;

  // Company assigned data
  final id = ''.obs;
  final fechaRegistro = ''.obs;
  final tipoCliente = Rx<String?>(null);

  // Observations
  final observaciones = ''.obs;

  // Client types
  final List<String> tiposCliente = ['Nuevo', 'Regular', 'VIP', 'Corporativo'];

  @override
  void onInit() {
    super.onInit();
    // Initialize date with current date
    fechaRegistro.value = DateTime.now().toString().split(' ')[0];
  }

  // Validation methods
  String? validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo electrónico es requerido';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Ingrese un correo electrónico válido';
    }
    return null;
  }

  String? validateRFC(String? value) {
    if (value == null || value.isEmpty) {
      return 'El RFC es requerido';
    }
    if (value.length != 13) {
      return 'El RFC debe tener 13 caracteres';
    }
    return null;
  }

  String? validateCP(String? value) {
    if (value == null || value.isEmpty) {
      return 'El código postal es requerido';
    }
    if (value.length != 5 || !GetUtils.isNumericOnly(value)) {
      return 'Ingrese un código postal válido (5 dígitos)';
    }
    return null;
  }

  @override
  Map<String, dynamic> getFormData() {
    return {
      'nombreEmpresa': nombreEmpresa.value,
      'cargo': cargo.value,
      'calle': calle.value,
      'colonia': colonia.value,
      'cp': cp.value,
      'nombre': nombre.value,
      'apellidoPaterno': apellidoPaterno.value,
      'apellidoMaterno': apellidoMaterno.value,
      'correo': correo.value,
      'telefono': telefono.value,
      'rfc': rfc.value,
      'id': id.value,
      'fechaRegistro': fechaRegistro.value,
      'tipoCliente': tipoCliente.value,
      'observaciones': observaciones.value,
    };
  }

  @override
  void resetForm() {
    formKey.currentState?.reset();
    nombreEmpresa.value = '';
    cargo.value = '';
    calle.value = '';
    colonia.value = '';
    cp.value = '';
    nombre.value = '';
    apellidoPaterno.value = '';
    apellidoMaterno.value = '';
    correo.value = '';
    telefono.value = '';
    rfc.value = '';
    id.value = '';
    fechaRegistro.value = DateTime.now().toString().split(' ')[0];
    tipoCliente.value = null;
    observaciones.value = '';
  }

  /// Validate client form specifically
  bool validateClientForm() {
    // Basic form validation
    if (!formKey.currentState!.validate()) {
      return false;
    }

    // Business rules validation
    if (tipoCliente.value == null) {
      Get.snackbar(
        'Error de validación',
        'Debe seleccionar un tipo de cliente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return false;
    }

    return true;
  }

  /// Override submitForm to add client-specific validation
  @override
  void submitForm() {
    if (validateClientForm()) {
      // Get form data
      final formData = getFormData();

      // Call external handler or show success message
      if (externalSubmitHandler != null) {
        externalSubmitHandler!(formData);
      } else {
        Get.snackbar(
          'Éxito',
          'Cliente registrado correctamente',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }
}
